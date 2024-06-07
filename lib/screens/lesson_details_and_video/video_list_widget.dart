import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/lessons/lesson_video/video_bloc.dart';
import 'package:tobetoapp/bloc/lessons/lesson_video/video_state.dart';

class VideoListWidget extends StatelessWidget {
  final Function(String) onVideoTap;

  VideoListWidget({Key? key, required this.onVideoTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoBloc, VideoState>(
      builder: (context, state) {
        if (state is VideosLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is VideosLoaded) {
          if (state.videos.isEmpty) {
            return Center(child: Text("Henüz video tanımlanmamıştır"));
          } else {
            return ListView.builder(
              itemCount: state.videos.length,
              itemBuilder: (context, index) {
                final video = state.videos[index];
                return ListTile(
                  leading: Icon(video.isCompleted ?? false
                      ? Icons.check_circle
                      : Icons.play_circle),
                  title: Text(video.videoTitle ?? 'No title'),
                  subtitle: Text('Süre: ${video.duration}'),
                  onTap: () {
                    onVideoTap(video.link ?? '');
                  },
                );
              },
            );
          }
        } else if (state is VideoOperationFailure) {
          return Center(child: Text(state.error));
        } else {
          return Center(child: Text('Bir hata oluştu.'));
        }
      },
    );
  }
}