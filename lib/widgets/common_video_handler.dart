import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/auth/auth_bloc.dart';
import 'package:tobetoapp/bloc/videos/videos_bloc.dart';
import 'package:tobetoapp/bloc/videos/videos_event.dart';
import 'package:tobetoapp/models/video_model.dart';

class VideoHandler {
  final BuildContext context;
  final String collectionId;
  final List<String> videoIds;
  int currentIndex = 0;
  String? currentVideoUrl;
  Video? currentVideo;
  Duration totalSpentTime = Duration.zero;
  final Map<String, Duration> videoSpentTimes = {};

  VideoHandler({
    required this.context,
    required this.collectionId,
    required this.videoIds,
  });

  void loadVideos() {
    final userId = context.read<AuthBloc>().currentUser?.id;
    if (userId != null) {
      context.read<VideoBloc>().add(
            LoadVideos(videoIds, collectionId),
          );
    }
  }

  void onVideoTap(Video video) {
    currentVideoUrl = video.link;
    currentVideo = video;
    totalSpentTime = videoSpentTimes[video.id] ?? Duration.zero;
  }

  void onVideoComplete() {
    if (currentVideo != null) {
      final userId = context.read<AuthBloc>().currentUser?.id;
      if (userId != null) {
        context.read<VideoBloc>().add(
              UpdateSpentTime(
                userId: userId,
                collectionId: collectionId,
                videoId: currentVideo!.id,
                spentTime: totalSpentTime,
                videoIds: videoIds,
              ),
            );
      }
      context.read<VideoBloc>().add(
            VideoSelected(
              collectionId: collectionId,
              video: currentVideo!,
              videoIds: videoIds,
            ),
          );
    }
  }

  void onTimeUpdate(Duration spentTime) {
    totalSpentTime = spentTime;
    if (currentVideo != null) {
      videoSpentTimes[currentVideo!.id] = spentTime;
    }
  }

  double calculateProgress(List<Video> videos) {
    if (videos.isEmpty) return 0.0;
    final completedVideos = videos.where((video) => video.isCompleted!).length;
    return completedVideos / videos.length;
  }

  Duration calculateSpentTime(List<Video> videos) {
    return videos.fold(
      Duration.zero,
      (sum, video) => sum + (video.spentTime ?? Duration.zero),
    );
  }

  void dispose() {
  }
}
