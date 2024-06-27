abstract class CatalogFavoritesEvent {}

class LoadCatalogFavorites extends CatalogFavoritesEvent {}

class AddCatalogFavorite extends CatalogFavoritesEvent {
  final String catalogId;
  AddCatalogFavorite({required this.catalogId});
}

class RemoveCatalogFavorite extends CatalogFavoritesEvent {
  final String catalogId;
  RemoveCatalogFavorite({required this.catalogId});
}
