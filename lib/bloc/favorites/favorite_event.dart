abstract class FavoritesEvent {}

class LoadFavorites extends FavoritesEvent {}

class AddFavorite extends FavoritesEvent {
  final String lessonId;
  AddFavorite({required this.lessonId});
}

class RemoveFavorite extends FavoritesEvent {
  final String lessonId;
  RemoveFavorite({required this.lessonId});
}