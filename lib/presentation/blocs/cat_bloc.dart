import 'package:Catinder/di/setup.dart';
import 'package:Catinder/domain/repositories/cat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../domain/usecases/fetch_cats.dart';
import '../../data/models/cat.dart';
import 'cat_event.dart';
import 'cat_state.dart';

class CatBloc extends Bloc<CatEvent, CatState> {
  final FetchCats fetchCatsUseCase;
  final CatRepository repository;

  CatBloc(this.fetchCatsUseCase, {CatRepository? repository})
      : repository = repository ?? getIt<CatRepository>(),
        super(const CatState()) {
    on<FetchCatsEvent>(_onFetchCats);
    on<SwipeCatEvent>(_onSwipeCat);
    on<RemoveLikedCatEvent>(_onRemoveLikedCat);
    on<ToggleThemeEvent>(_onToggleTheme);
    on<ToggleSoundEvent>(_onToggleSound);
    on<ResetProgressEvent>(_onResetProgress);

    add(FetchCatsEvent());
  }

  Future<void> _onFetchCats(
      FetchCatsEvent event, Emitter<CatState> emit) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final isOffline = connectivityResult == ConnectivityResult.none;

    try {
      emit(state.copyWith(isLoading: true, error: null));
      final fetchedCats = await fetchCatsUseCase();
      final likedCats = await repository.getLikedCats();
      emit(state.copyWith(
        cats: fetchedCats,
        likedCats: likedCats,
        likeCount: likedCats.length,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: isOffline ? 'No internet connection' : 'Network Error: $e',
      ));
    }
  }

  Future<void> _onSwipeCat(SwipeCatEvent event, Emitter<CatState> emit) async {
    if (event.previousIndex < 0 || event.previousIndex >= state.cats.length) {
      print(
          'Invalid previousIndex: ${event.previousIndex}, cats length: ${state.cats.length}');
      return;
    }

    print(
        'SwipeCatEvent: previousIndex=${event.previousIndex}, direction=${event.direction}, currentStreak=${state.streakCount}');

    if (event.direction == CardSwiperDirection.right) {
      final cat = state.cats[event.previousIndex];
      await repository.likeCat(cat);
      final newLikeCount = state.likeCount + 1;
      final newStreakCount = state.streakCount + 1;
      final newLikedCats = await repository.getLikedCats();

      print('Right swipe: newStreakCount=$newStreakCount');

      if (newStreakCount == 10) {
        final newCats = [...state.cats, CatModel.getSecretCat()];
        emit(state.copyWith(
          cats: newCats,
          likedCats: newLikedCats,
          likeCount: newLikeCount,
          streakCount: 0,
          showSecretCat: true,
        ));
        print('Secret cat triggered, streak reset to 0');
      } else {
        emit(state.copyWith(
          likedCats: newLikedCats,
          likeCount: newLikeCount,
          streakCount: newStreakCount,
        ));
      }
    } else {
      emit(state.copyWith(streakCount: 0));
      print('Left swipe: streak reset to 0');
    }

    if (event.previousIndex == state.cats.length - 2 && !state.showSecretCat) {
      add(FetchCatsEvent());
    }
  }

  Future<void> _onRemoveLikedCat(
      RemoveLikedCatEvent event, Emitter<CatState> emit) async {
    await repository.removeCat(event.cat);
    final newLikedCats = await repository.getLikedCats();
    emit(state.copyWith(
      likedCats: newLikedCats,
      likeCount: newLikedCats.length,
    ));
  }

  void _onToggleTheme(ToggleThemeEvent event, Emitter<CatState> emit) {
    emit(state.copyWith(
        themeMode: event.isDark ? ThemeMode.dark : ThemeMode.light));
  }

  void _onToggleSound(ToggleSoundEvent event, Emitter<CatState> emit) {
    emit(state.copyWith(soundEnabled: event.enabled));
  }

  Future<void> _onResetProgress(
      ResetProgressEvent event, Emitter<CatState> emit) async {
    for (var cat in state.likedCats) {
      await repository.removeCat(cat);
    }
    emit(state.copyWith(
      likeCount: 0,
      streakCount: 0,
      likedCats: [],
    ));
  }
}
