import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../domain/entities/cat.dart';
import '../../domain/usecases/fetch_cats.dart';
import '../../data/models/cat.dart';
import 'cat_event.dart';
import 'cat_state.dart';

class CatBloc extends Bloc<CatEvent, CatState> {
  final FetchCats fetchCatsUseCase;

  CatBloc(this.fetchCatsUseCase) : super(const CatState()) {
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
    if (connectivityResult == ConnectivityResult.none) {
      emit(state.copyWith(error: 'No internet connection'));
      return;
    }

    try {
      emit(state.copyWith(isLoading: true, error: null));
      final fetchedCats = await fetchCatsUseCase();
      emit(state.copyWith(cats: fetchedCats, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Network Error: $e'));
    }
  }

  Future<void> _onSwipeCat(SwipeCatEvent event, Emitter<CatState> emit) async {
    // Validate previousIndex
    if (event.previousIndex < 0 || event.previousIndex >= state.cats.length) {
      print(
          'Invalid previousIndex: ${event.previousIndex}, cats length: ${state.cats.length}');
      return;
    }

    print(
        'SwipeCatEvent: previousIndex=${event.previousIndex}, direction=${event.direction}, currentStreak=${state.streakCount}');

    if (event.direction == CardSwiperDirection.right) {
      final newLikeCount = state.likeCount + 1;
      final newStreakCount = state.streakCount + 1;
      final newLikedCats = [
        Cat(
          id: state.cats[event.previousIndex].id,
          url: state.cats[event.previousIndex].url,
          breedName: state.cats[event.previousIndex].breedName,
          breedDescription: state.cats[event.previousIndex].breedDescription,
          likedAt: DateTime.now(),
        ),
        ...state.likedCats,
      ];

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

    // Trigger fetch if nearing the end of the cat list
    if (event.previousIndex == state.cats.length - 2 && !state.showSecretCat) {
      add(FetchCatsEvent());
    }
  }

  void _onRemoveLikedCat(RemoveLikedCatEvent event, Emitter<CatState> emit) {
    final newLikedCats = [...state.likedCats]..remove(event.cat);
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

  void _onResetProgress(ResetProgressEvent event, Emitter<CatState> emit) {
    emit(state.copyWith(
      likeCount: 0,
      streakCount: 0,
      likedCats: [],
    ));
  }
}
