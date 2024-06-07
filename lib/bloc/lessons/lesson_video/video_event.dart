// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:tobetoapp/models/lesson_model.dart';

abstract class VideoEvent {}

class LoadVideos extends VideoEvent {
  final List<String> videoIds;

  LoadVideos(this.videoIds);
}

class AddVideo extends VideoEvent {
  final Video video;

  AddVideo(this.video);
}

class UpdateVideo extends VideoEvent {
  final Video video;

  UpdateVideo(this.video);
}

class UpdateVideoCompletion extends VideoEvent {
  final String videoUrl;
  final bool isCompleted;

  UpdateVideoCompletion(this.videoUrl, this.isCompleted);
}

class VideosUpdated extends VideoEvent {
  final List<Video> videos;
  VideosUpdated(
   this.videos,
 );
}

class DeleteVideo extends VideoEvent {
  final String videoId;

  DeleteVideo(this.videoId);
}