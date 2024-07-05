import 'package:tobetoapp/models/video_model.dart';

abstract class VideoState {}

class VideosLoading extends VideoState {}

class VideosLoaded extends VideoState {
  final List<Video> videos;

  VideosLoaded(this.videos);
}

class VideoUpdating extends VideoState {}

class VideoOperationFailure extends VideoState {
  final String error;

  VideoOperationFailure({required this.error});
}

class VideoUpdated extends VideoState {
  final Video video;

  VideoUpdated({required this.video});
}