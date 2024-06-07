import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tobetoapp/bloc/lessons/lesson_video/video_bloc.dart';
import 'package:tobetoapp/bloc/lessons/lesson_video/video_event.dart';
import 'package:tobetoapp/models/lesson_model.dart';
import 'package:tobetoapp/screens/lesson_details_and_video/sample_player.dart';
import 'package:tobetoapp/screens/lesson_details_and_video/video_list_widget.dart';

class LessonDetailsPage extends StatefulWidget {
  final LessonModel lesson;

  const LessonDetailsPage({Key? key, required this.lesson}) : super(key: key);

  @override
  _LessonDetailsPageState createState() => _LessonDetailsPageState();
}

class _LessonDetailsPageState extends State<LessonDetailsPage> {
  String? _currentVideoUrl;

  @override
  void initState() {
    super.initState();
    context.read<VideoBloc>().add(LoadVideos(widget.lesson.videoIds ?? []));
  }

  void _onVideoTap(String videoUrl) {
    setState(() {
      _currentVideoUrl = videoUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title ?? 'Ders Detayları'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.lesson.title ?? 'Başlık Yok',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(widget.lesson.description ?? 'Açıklama Yok'),
            SizedBox(height: 16),
            Text(
              'Başlangıç: ${widget.lesson.startDate != null ? DateFormat('dd MMM yyyy, HH:mm', 'tr').format(widget.lesson.startDate!) : 'Tarih Yok'}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              'Bitiş: ${widget.lesson.endDate != null ? DateFormat('dd MMM yyyy, HH:mm', 'tr').format(widget.lesson.endDate!) : 'Tarih Yok'}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 16),
            if (_currentVideoUrl != null)
              Container(
                height: 200,
                child: SamplePlayer(videoUrl: _currentVideoUrl!),
              ),
            SizedBox(height: 16),
            Expanded(
              child: VideoListWidget(onVideoTap: _onVideoTap),
            ),
          ],
        ),
      ),
    );
  }
}