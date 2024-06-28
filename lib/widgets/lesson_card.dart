import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tobetoapp/models/lesson_model.dart';
import 'package:tobetoapp/screens/lesson_details_and_video/lesson_details_page.dart';
import 'package:tobetoapp/screens/student_live_lesson_page.dart';

class LessonCard extends StatelessWidget {
  final LessonModel lesson;

  const LessonCard({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _navigateToLessonPage(context, lesson);
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            lesson.image != null
                ? Image.network(
                    lesson.image!,
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: 100,
                  )
                : Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.grey,
                    child: const Icon(Icons.image, size: 30),
                  ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                lesson.title ?? "No title",
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                _formatDate(lesson.startDate),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
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