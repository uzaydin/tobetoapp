abstract class CatalogFavoritesEvent {}

class LoadFavorites extends CatalogFavoritesEvent {}

class AddFavorite extends CatalogFavoritesEvent {
  final String catalogId;
  AddFavorite({required this.catalogId});
}

class RemoveFavorite extends CatalogFavoritesEvent {
  final String catalogId;
  RemoveFavorite({required this.catalogId});
}
