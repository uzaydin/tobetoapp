
import 'package:tobetoapp/models/lesson_model.dart';

abstract class LessonState {}

class LessonsLoading extends LessonState {}

class LessonsLoaded extends LessonState {
  final List<LessonModel> lessons;

  LessonsLoaded(this.lessons);
}

class LessonOperationSuccess extends LessonState {}

class LessonOperationFailure extends LessonState {
  final String error;

  LessonOperationFailure(this.error);
}