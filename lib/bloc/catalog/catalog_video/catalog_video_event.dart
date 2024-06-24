// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:tobetoapp/models/catalog_model.dart';

abstract class CatalogVideoEvent {}

class LoadVideos extends CatalogVideoEvent {
  final String catalogId;
  final List<String> videoIds;

  LoadVideos({
    required this.catalogId,
    required this.videoIds,
  });
}

class UpdateUserVideo extends CatalogVideoEvent {
  final String userId;
  final String catalogId;
  final Video video;
  final List<String> videoIds;

  UpdateUserVideo({
    required this.userId,
    required this.catalogId,
    required this.video,
    required this.videoIds,
  });
}

class UpdateSpentTime extends CatalogVideoEvent {
  final String userId;
  final String catalogId;
  final String? videoId;
  final Duration spentTime;
  final List<String> videoIds;

  UpdateSpentTime({
    required this.userId,
    required this.catalogId,
    required this.videoId,
    required this.spentTime,
    required this.videoIds,
  });
}

class VideoSelected extends CatalogVideoEvent {
  final String catalogId;
  final Video video;
  final List<String> videoIds;

  VideoSelected({
    required this.catalogId,
    required this.video,
    required this.videoIds,
  });
}
