import 'package:tobetoapp/models/lesson_model.dart';

abstract class LessonEvent {}

class LoadLessons extends LessonEvent {
  final List<String>? classIds;

  LoadLessons(this.classIds);
}

class AddLesson extends LessonEvent {
  final LessonModel lessonModel;

  AddLesson(this.lessonModel);
}

class DeleteLesson extends LessonEvent {
  final String id;

  DeleteLesson(this.id);
}

class LessonsUpdated extends LessonEvent {
  final List<LessonModel> lessons;

  LessonsUpdated(this.lessons);
}

class LoadTeacherLessons extends LessonEvent {
  final String teacherId;

  LoadTeacherLessons(this.teacherId);
}

class FetchStudentsForLesson extends LessonEvent {
  final LessonModel lesson;

  FetchStudentsForLesson(this.lesson);
}

class FetchTeacherssForLesson extends LessonEvent {
  final LessonModel lesson;

  FetchTeacherssForLesson(this.lesson);
}
