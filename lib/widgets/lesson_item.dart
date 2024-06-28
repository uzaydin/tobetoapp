import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tobetoapp/models/lesson_model.dart';
import 'package:tobetoapp/screens/lesson_details_and_video/lesson_details_page.dart';
import 'package:tobetoapp/screens/student_live_lesson_page.dart';

class LessonItem extends StatelessWidget {
  final LessonModel lesson;

  const LessonItem({Key? key, required this.lesson}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: lesson.image != null
          ? Image.network(
              lesson.image!,
              fit: BoxFit.fill,
              width: 120,
              height: double.infinity,
            )
          : Container(width: 50, height: 50, color: Colors.grey),
      title: Text(lesson.title ?? "No title"),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lesson.description ?? "No description"),
          Text(_formatDate(lesson.startDate)),
        ],
      ),
      onTap: () {
        _navigateToLessonPage(context, lesson);
      },
    );
  }

  void _navigateToLessonPage(BuildContext context, LessonModel lesson) {
    if (lesson.isLive ?? false) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => StudentLiveLessonPage(lesson: lesson),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LessonDetailsPage(lesson: lesson),
        ),
      );
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Tarih yok';
    return DateFormat('dd MMM yyyy, hh:mm', 'tr').format(date);
  }
}