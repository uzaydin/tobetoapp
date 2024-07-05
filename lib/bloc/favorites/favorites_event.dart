
abstract class FavoritesEvent {
  const FavoritesEvent();
}

class LoadFavorites extends FavoritesEvent {
  const LoadFavorites();
}

class AddFavorite extends FavoritesEvent {
  final favoriteId;
  const AddFavorite(this.favoriteId);
}

class RemoveFavorite extends FavoritesEvent {
  final favoriteId;
  const RemoveFavorite(this.favoriteId);
}

