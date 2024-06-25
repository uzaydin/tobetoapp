import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tobetoapp/bloc/catalog/catalog_favorites/catalog_favorite_event.dart';
import 'package:tobetoapp/bloc/catalog/catalog_favorites/catalog_favorite_state.dart';

class CatalogFavoritesBloc extends Bloc<CatalogFavoritesEvent, CatalogFavoritesState> {
  final SharedPreferences _prefs;

  CatalogFavoritesBloc(this._prefs) : super(FavoritesLoading()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddFavorite>(_onAddFavorite);
    on<RemoveFavorite>(_onRemoveFavorite);
  }

  void _onLoadFavorites(LoadFavorites event, Emitter<CatalogFavoritesState> emit) async {
    emit(FavoritesLoading());
    try {
      final favoriteCatalogIds = _prefs.getStringList('favorites') ?? [];
      emit(FavoritesLoaded(favoriteCatalogIds));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  void _onAddFavorite(AddFavorite event, Emitter<CatalogFavoritesState> emit) async {
    try {
      final favoriteCatalogIds = List<String>.from(_prefs.getStringList('favorites') ?? []);
      if (!favoriteCatalogIds.contains(event.catalogId)) {
        favoriteCatalogIds.add(event.catalogId);
        await _prefs.setStringList('favorites', favoriteCatalogIds);
      }
      emit(FavoritesLoaded(favoriteCatalogIds));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  void _onRemoveFavorite(RemoveFavorite event, Emitter<CatalogFavoritesState> emit) async {
    try {
      final favoriteCatalogIds = List<String>.from(_prefs.getStringList('favorites') ?? []);
      if (favoriteCatalogIds.contains(event.catalogId)) {
        favoriteCatalogIds.remove(event.catalogId);
        await _prefs.setStringList('favorites', favoriteCatalogIds);
      }
      emit(FavoritesLoaded(favoriteCatalogIds));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
}
