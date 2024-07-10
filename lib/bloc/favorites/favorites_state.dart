abstract class FavoritesState {
  const FavoritesState();
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

class FavoritesLoaded extends FavoritesState {
  final List<String> favoriteId;
  const FavoritesLoaded(this.favoriteId);
}

class FavoritesError extends FavoritesState {
  final String message;
  const FavoritesError(this.message);
}
