import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tobetoapp/bloc/favorites/favorites_event.dart';
import 'package:tobetoapp/bloc/favorites/favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final SharedPreferences _prefs;
  final String _prefsKey;

  FavoritesBloc(this._prefs, this._prefsKey) : super(FavoritesLoading()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddFavorite>(_onAddFavorite);
    on<RemoveFavorite>(_onRemoveFavorite);
  }

  void _onLoadFavorites(LoadFavorites event, Emitter<FavoritesState> emit) async {
    emit(FavoritesLoading());
    try {
      final favoriteId = _prefs.getStringList(_prefsKey) ?? [];
      emit(FavoritesLoaded(favoriteId));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  void _onAddFavorite(AddFavorite event, Emitter<FavoritesState> emit) async {
    try {
      final favoriteId = List<String>.from(_prefs.getStringList(_prefsKey) ?? []);
      if (!favoriteId.contains(event.favoriteId)) {
        favoriteId.add(event.favoriteId);
        await _prefs.setStringList(_prefsKey, favoriteId);
      }
      emit(FavoritesLoaded(favoriteId));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  void _onRemoveFavorite(RemoveFavorite event, Emitter<FavoritesState> emit) async {
    try {
      final favoriteId = List<String>.from(_prefs.getStringList(_prefsKey) ?? []);
      if (favoriteId.contains(event.favoriteId)) {
        favoriteId.remove(event.favoriteId);
        await _prefs.setStringList(_prefsKey, favoriteId);
      }
      emit(FavoritesLoaded(favoriteId));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
}
