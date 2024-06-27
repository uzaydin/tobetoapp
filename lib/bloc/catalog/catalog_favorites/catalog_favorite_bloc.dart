import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tobetoapp/bloc/catalog/catalog_favorites/catalog_favorite_event.dart';
import 'package:tobetoapp/bloc/catalog/catalog_favorites/catalog_favorite_state.dart';

class CatalogFavoritesBloc extends Bloc<CatalogFavoritesEvent, CatalogFavoritesState> {
  final SharedPreferences _prefs;

  CatalogFavoritesBloc(this._prefs) : super(CatalogFavoritesLoading()) {
    on<LoadCatalogFavorites>(_onLoadCatalogFavorites);
    on<AddCatalogFavorite>(_onAddCatalogFavorite);
    on<RemoveCatalogFavorite>(_onRemoveCatalogFavorite);
  }

  void _onLoadCatalogFavorites(LoadCatalogFavorites event, Emitter<CatalogFavoritesState> emit) async {
    emit(CatalogFavoritesLoading());
    try {
      final favoriteCatalogIds = _prefs.getStringList('favorites') ?? [];
      emit(CatalogFavoritesLoaded(favoriteCatalogIds));
    } catch (e) {
      emit(CatalogFavoritesError(e.toString()));
    }
  }

  void _onAddCatalogFavorite(AddCatalogFavorite event, Emitter<CatalogFavoritesState> emit) async {
    try {
      final favoriteCatalogIds = List<String>.from(_prefs.getStringList('favorites') ?? []);
      if (!favoriteCatalogIds.contains(event.catalogId)) {
        favoriteCatalogIds.add(event.catalogId);
        await _prefs.setStringList('favorites', favoriteCatalogIds);
      }
      emit(CatalogFavoritesLoaded(favoriteCatalogIds));
    } catch (e) {
      emit(CatalogFavoritesError(e.toString()));
    }
  }

  void _onRemoveCatalogFavorite(RemoveCatalogFavorite event, Emitter<CatalogFavoritesState> emit) async {
    try {
      final favoriteCatalogIds = List<String>.from(_prefs.getStringList('favorites') ?? []);
      if (favoriteCatalogIds.contains(event.catalogId)) {
        favoriteCatalogIds.remove(event.catalogId);
        await _prefs.setStringList('favorites', favoriteCatalogIds);
      }
      emit(CatalogFavoritesLoaded(favoriteCatalogIds));
    } catch (e) {
      emit(CatalogFavoritesError(e.toString()));
    }
  }
}
