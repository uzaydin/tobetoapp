import 'package:flutter/material.dart';
import 'package:tobetoapp/models/video_model.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';

class CommonVideoProgress extends StatelessWidget {
  final List<Video> videos;
  final Function(Video) onVideoTap;
  final double progress;

  const CommonVideoProgress({
    Key? key,
    required this.videos,
    required this.onVideoTap,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return ListTile(
          title: Text(video.videoTitle!),
          subtitle: Text(video.duration.toString()),
          onTap: () => onVideoTap(video),
        );
      },
    );
  }
}

class CommonProgressIndicator extends StatelessWidget {
  final double progress;

  const CommonProgressIndicator({Key? key, required this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppConstants.screenWidth * 0.04),
      child: Row(
        children: [
          Expanded(
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress == 100 ? Colors.green : Colors.blue,
              ),
            ),
          ),
          SizedBox(width: AppConstants.sizedBoxWidthSmall),
          Text('%${progress.toStringAsFixed(0)}'),
        ],
      ),
    );
  }
}

