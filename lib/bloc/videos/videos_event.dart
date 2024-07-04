import 'package:tobetoapp/models/video_model.dart';

abstract class VideoEvent {}

class LoadVideos extends VideoEvent {
  final List<String> videoIds;
  final String collectionId;

  LoadVideos(this.videoIds, this.collectionId);
}

class UpdateUserVideo extends VideoEvent {
  final String userId;
  final String collectionId;
  final Video video;
  final List<String> videoIds;

  UpdateUserVideo({required this.userId, required this.collectionId, required this.video, required this.videoIds});
}

class VideoCompletedEvent extends VideoEvent {
  final String userId;
  final String collectionId;
  final String videoId;

  VideoCompletedEvent({required this.userId, required this.collectionId, required this.videoId});
}

class UpdateSpentTime extends VideoEvent {
  final String userId;
  final String collectionId;
  final String videoId;
  final Duration spentTime;
  final List<String> videoIds;

  UpdateSpentTime({required this.userId, required this.collectionId, required this.videoId, required this.spentTime, required this.videoIds});
}

class VideoSelected extends VideoEvent {
  final String collectionId;
  final Video video;
  final List<String> videoIds;

  VideoSelected({required this.collectionId, required this.video, required this.videoIds});
}