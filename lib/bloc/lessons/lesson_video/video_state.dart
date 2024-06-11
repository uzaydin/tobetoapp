
import 'package:tobetoapp/models/lesson_model.dart';

abstract class VideoState {}

class VideosLoading extends VideoState {}

class VideosLoaded extends VideoState {
  final List<Video> videos;

  VideosLoaded(this.videos);
}

class VideoUpdated extends VideoState {
  final Video video;

  VideoUpdated({required this.video});
}

class VideoOperationFailure extends VideoState {
  final String error;

  VideoOperationFailure({required this.error});
}

class VideoUpdating extends VideoState {}