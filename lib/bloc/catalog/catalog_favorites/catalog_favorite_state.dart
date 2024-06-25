abstract class CatalogFavoritesState {}

class FavoritesLoading extends CatalogFavoritesState {}

class FavoritesLoaded extends CatalogFavoritesState {
  final List<String> favoriteCatalogIds;
  FavoritesLoaded(this.favoriteCatalogIds);
}

class FavoritesError extends CatalogFavoritesState {
  final String message;
  FavoritesError(this.message);
}
