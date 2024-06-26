import 'package:tobetoapp/models/lesson_model.dart';
import 'package:tobetoapp/models/user_model.dart';

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

class StudentsLoaded extends LessonState {
  final List<UserModel> students;

  StudentsLoaded(this.students);
}

class TeacherNamesLoaded extends LessonState {
  final Map<String, String> teacherNames;

  TeacherNamesLoaded(this.teacherNames);
}
