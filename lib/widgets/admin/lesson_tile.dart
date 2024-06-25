import 'package:flutter/material.dart';
import 'package:tobetoapp/models/lesson_model.dart';

class LessonTile extends StatelessWidget {
  final LessonModel lesson;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const LessonTile({
    super.key,
    required this.lesson,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(lesson.title!),
      subtitle: Text(lesson.description!),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}