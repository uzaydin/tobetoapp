import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/videos/videos_bloc.dart';
import 'package:tobetoapp/bloc/videos/videos_state.dart';
import 'package:tobetoapp/models/catalog_model.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';
import 'package:tobetoapp/widgets/common_header.dart';
import 'package:tobetoapp/widgets/common_info_dialog.dart';
import 'package:tobetoapp/widgets/common_video_handler.dart';
import 'package:tobetoapp/widgets/common_video_player.dart';
import 'package:tobetoapp/widgets/common_video_progress.dart';

class CatalogLessonPage extends StatefulWidget {
  final CatalogModel catalog;

  const CatalogLessonPage({Key? key, required this.catalog}) : super(key: key);

  @override
  _CatalogLessonPageState createState() => _CatalogLessonPageState();
}

class _CatalogLessonPageState extends State<CatalogLessonPage> {
  late VideoHandler _videoHandler;

  @override
  void initState() {
    super.initState();
    _videoHandler = VideoHandler(
      context: context,
      collectionId: widget.catalog.catalogId!,
      videoIds: widget.catalog.videoIds ?? [],
    );
    _videoHandler.loadVideos();
  }

  @override
  void dispose() {
    _videoHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/logo/tobetologo.PNG",
          width: MediaQuery.of(context).size.width * 0.43,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<VideoBloc, VideoState>(
        builder: (context, state) {
          if (state is VideosLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is VideosLoaded) {
            final videos = state.videos;
            final progress = _videoHandler.calculateProgress(videos);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonHeader(
                  itemId: widget.catalog.catalogId,
                  title: widget.catalog.title,
                  onInfoPressed: () => showCommonInfoDialog(
                    context,
                    videos,
                    widget.catalog.startDate,
                    widget.catalog.endDate,
                    widget.catalog.title!,
                  ),
                ),
                SizedBox(height: AppConstants.sizedBoxHeightSmall),
                CommonVideoPlayer(
                  videoUrl: _videoHandler.currentVideoUrl,
                  onVideoComplete: _videoHandler.onVideoComplete,
                  onTimeUpdate: _videoHandler.onTimeUpdate,
                ),
                Expanded(
                  child: CommonVideoProgress(
                    videos: videos,
                    onVideoTap: _videoHandler.onVideoTap,
                    progress: progress,
                  ),
                ),
              ],
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}

