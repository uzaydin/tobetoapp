
abstract class FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<String> favoriteLessonIds;
  FavoritesLoaded(this.favoriteLessonIds);
}

class FavoritesError extends FavoritesState {
  final String message;
  FavoritesError(this.message);
}