import 'package:tobetoapp/models/lesson_model.dart';

abstract class HomeworkEvent {}

class AddHomework extends HomeworkEvent {
  final HomeworkModel homework;

  AddHomework(this.homework);
}

class UpdateHomework extends HomeworkEvent {
  final HomeworkModel homework;

  UpdateHomework(this.homework);
}

class DeleteHomework extends HomeworkEvent {
  final String id;
  final String lessonId;

  DeleteHomework(this.id, this.lessonId);
}

class LoadHomeworks extends HomeworkEvent {
  final String lessonId;

  LoadHomeworks(this.lessonId);
}

class UploadHomework extends HomeworkEvent {
  final String lessonId;
  final String homeworkId;
  final String filePath;

  UploadHomework(
      {required this.lessonId,
      required this.homeworkId,
      required this.filePath});
}
