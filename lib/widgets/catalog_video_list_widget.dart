import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/catalog/catalog_video/catalog_video_bloc.dart';
import 'package:tobetoapp/bloc/catalog/catalog_video/catalog_video_state.dart';
import 'package:tobetoapp/models/catalog_model.dart';

class VideoListWidget extends StatelessWidget {
  final Function(Video) onVideoTap;

  const VideoListWidget({super.key, required this.onVideoTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogVideoBloc, CatalogVideoState>(
      builder: (context, state) {
        if (state is VideosLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is VideosLoaded) {
          return _buildVideoList(state.videos);
        } else if (state is VideoUpdated) {
          final videos = _updateVideoInList((context.read<CatalogVideoBloc>().state as VideosLoaded).videos, state.video);
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
            leading: Icon(video.isCompleted! ? Icons.check_circle : Icons.play_circle),
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