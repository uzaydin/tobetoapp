import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/videos/videos_bloc.dart';
import 'package:tobetoapp/bloc/videos/videos_state.dart';
import 'package:tobetoapp/models/video_model.dart';

class CommonVideoList extends StatelessWidget {
  final Function(Video) onVideoTap;
  final VideoBloc videoBloc;

  const CommonVideoList({super.key, required this.onVideoTap, required this.videoBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoBloc, VideoState>(
      bloc: videoBloc,
      builder: (context, state) {
        if (state is VideosLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is VideosLoaded) {
          return _buildVideoList(state.videos);
        } else if (state is VideoUpdated && videoBloc.state is VideosLoaded) {
          final videos = _updateVideoInList((videoBloc.state as VideosLoaded).videos, state.video);
          return _buildVideoList(videos);
        } else if (state is VideoOperationFailure) {
          return Center(child: Text(state.error));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildVideoList(List<Video> videos) {
    if (videos.isEmpty) {
      return const Center(child: Text("Henüz video tanımlanmamıştır"));
    } else {
      return ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return ListTile(
            leading: Icon(video.isCompleted ?? false ? Icons.check_circle : Icons.play_circle),
            title: Text(video.videoTitle ?? 'No title'),
            subtitle: Text('Süre: ${video.duration}'),
            onTap: () {
              onVideoTap(video);
            },
          );
        },
      );
    }
  }

  List<Video> _updateVideoInList(List<Video> videos, Video updatedVideo) {
    return videos.map((video) {
      if (video.id == updatedVideo.id) {
        return updatedVideo;
      }
      return video;
    }).toList();
  }
}
