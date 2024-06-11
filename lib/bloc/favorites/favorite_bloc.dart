import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tobetoapp/bloc/favorites/favorite_event.dart';
import 'package:tobetoapp/bloc/favorites/favorite_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final SharedPreferences _prefs;

  FavoritesBloc(this._prefs) : super(FavoritesLoading()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddFavorite>(_onAddFavorite);
    on<RemoveFavorite>(_onRemoveFavorite);
  }

  void _onLoadFavorites(LoadFavorites event, Emitter<FavoritesState> emit) async {
    emit(FavoritesLoading());
    try {
      final favoriteLessonIds = _prefs.getStringList('favorites') ?? [];
      emit(FavoritesLoaded(favoriteLessonIds));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  void _onAddFavorite(AddFavorite event, Emitter<FavoritesState> emit) async {
    try {
      final favoriteLessonIds = List<String>.from(_prefs.getStringList('favorites') ?? []);
      if (!favoriteLessonIds.contains(event.lessonId)) {
        favoriteLessonIds.add(event.lessonId);
        await _prefs.setStringList('favorites', favoriteLessonIds);
      }
      emit(FavoritesLoaded(favoriteLessonIds));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  void _onRemoveFavorite(RemoveFavorite event, Emitter<FavoritesState> emit) async {
    try {
      final favoriteLessonIds = List<String>.from(_prefs.getStringList('favorites') ?? []);
      if (favoriteLessonIds.contains(event.lessonId)) {
        favoriteLessonIds.remove(event.lessonId);
        await _prefs.setStringList('favorites', favoriteLessonIds);
      }
      emit(FavoritesLoaded(favoriteLessonIds));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
}