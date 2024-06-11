// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:tobetoapp/models/lesson_model.dart';

abstract class VideoEvent {}

class LoadVideos extends VideoEvent {

  final String lessonId;
  final List<String> videoIds;

  LoadVideos(
      { required this.lessonId, required this.videoIds});
}

class UpdateUserVideo extends VideoEvent {
  final String userId;
  final String lessonId;
  final Video video;
  final List<String> videoIds; // Listeyi ekledik

  UpdateUserVideo({
    required this.userId,
    required this.lessonId,
    required this.video,
    required this.videoIds,
  });
}
class UpdateSpentTime extends VideoEvent {
  final String userId;
  final String lessonId;
  final String? videoId;
  final Duration spentTime;
  final List<String> videoIds;

  UpdateSpentTime({
    required this.userId,
    required this.lessonId,
    required this.videoId,
    required this.spentTime,
    required this.videoIds,
  });
}

class VideoSelected extends VideoEvent {
  final String lessonId;
  final Video video;
  final List<String> videoIds;

  VideoSelected({
    required this.lessonId,
    required this.video,
    required this.videoIds,
  });
}