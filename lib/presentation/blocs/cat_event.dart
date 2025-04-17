import 'package:equatable/equatable.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../domain/entities/cat.dart';

abstract class CatEvent extends Equatable {
  const CatEvent();

  @override
  List<Object?> get props => [];
}

class FetchCatsEvent extends CatEvent {}

class SwipeCatEvent extends CatEvent {
  final int previousIndex;
  final CardSwiperDirection direction;

  const SwipeCatEvent(this.previousIndex, this.direction);

  @override
  List<Object?> get props => [previousIndex, direction];
}

class RemoveLikedCatEvent extends CatEvent {
  final Cat cat;

  const RemoveLikedCatEvent(this.cat);

  @override
  List<Object?> get props => [cat];
}

class ToggleThemeEvent extends CatEvent {
  final bool isDark;

  const ToggleThemeEvent(this.isDark);

  @override
  List<Object?> get props => [isDark];
}

class ToggleSoundEvent extends CatEvent {
  final bool enabled;

  const ToggleSoundEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class ResetProgressEvent extends CatEvent {}
