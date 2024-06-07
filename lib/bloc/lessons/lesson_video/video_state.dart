
import 'package:tobetoapp/models/lesson_model.dart';

abstract class VideoState {}

class VideosLoading extends VideoState {}

class VideosLoaded extends VideoState {
  final List<Video> videos;

  VideosLoaded(this.videos);
}

class VideoOperationSuccess extends VideoState {}

class VideoOperationFailure extends VideoState {
  final String error;

  VideoOperationFailure(this.error);
}