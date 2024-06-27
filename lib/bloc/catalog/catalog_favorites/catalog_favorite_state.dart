abstract class CatalogFavoritesState {}

class CatalogFavoritesLoading extends CatalogFavoritesState {}

class CatalogFavoritesLoaded extends CatalogFavoritesState {
  final List<String> favoriteCatalogIds;
  CatalogFavoritesLoaded(this.favoriteCatalogIds);
}

class CatalogFavoritesError extends CatalogFavoritesState {
  final String message;
  CatalogFavoritesError(this.message);
}
