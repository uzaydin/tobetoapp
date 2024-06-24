import 'package:tobetoapp/models/catalog_model.dart';

abstract class CatalogVideoState {}

class VideosLoading extends CatalogVideoState {}

class VideosLoaded extends CatalogVideoState {
  final List<Video> videos;

  VideosLoaded(this.videos);
}

class VideoUpdated extends CatalogVideoState {
  final Video video;

  VideoUpdated({required this.video});
}

class VideoOperationFailure extends CatalogVideoState {
  final String error;

  VideoOperationFailure({required this.error});
}

class VideoUpdating extends CatalogVideoState {}