
import 'package:tobetoapp/models/lesson_model.dart';

abstract class LessonEvent {}

class LoadLessons extends LessonEvent {
  final List<String>? classIds;

  LoadLessons(this.classIds);
}
class LoadLiveLessons extends LessonEvent {
  final List<String>? classIds;

  LoadLiveLessons(this.classIds);
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