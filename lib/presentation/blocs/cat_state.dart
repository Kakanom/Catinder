import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/cat.dart';
import "../../domain/entities/cat.dart";

class CatState extends Equatable {
  final List<Cat> cats;
  final List<Cat> likedCats;
  final int likeCount;
  final int streakCount;
  final bool showSecretCat;
  final bool isLoading;
  final bool soundEnabled;
  final ThemeMode themeMode;
  final String? error;

  const CatState({
    this.cats = const [],
    this.likedCats = const [],
    this.likeCount = 0,
    this.streakCount = 0,
    this.showSecretCat = false,
    this.isLoading = false,
    this.soundEnabled = true,
    this.themeMode = ThemeMode.light,
    this.error,
  });

  CatState copyWith({
    List<Cat>? cats,
    List<Cat>? likedCats,
    int? likeCount,
    int? streakCount,
    bool? showSecretCat,
    bool? isLoading,
    bool? soundEnabled,
    ThemeMode? themeMode,
    String? error,
  }) {
    return CatState(
      cats: cats ?? this.cats,
      likedCats: likedCats ?? this.likedCats,
      likeCount: likeCount ?? this.likeCount,
      streakCount: streakCount ?? this.streakCount,
      showSecretCat: showSecretCat ?? this.showSecretCat,
      isLoading: isLoading ?? this.isLoading,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      themeMode: themeMode ?? this.themeMode,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        cats,
        likedCats,
        likeCount,
        streakCount,
        showSecretCat,
        isLoading,
        soundEnabled,
        themeMode,
        error,
      ];
}
