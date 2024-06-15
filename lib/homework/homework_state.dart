import 'package:tobetoapp/models/lesson_model.dart';

abstract class HomeworkState {}

class HomeworkInitial extends HomeworkState {}

class HomeworkLoading extends HomeworkState {}

class HomeworkLoaded extends HomeworkState {
  final List<HomeworkModel> homeworks;

  HomeworkLoaded(this.homeworks);
}

class HomeworkSuccess extends HomeworkState {}

class HomeworkFailure extends HomeworkState {
  final String error;

  HomeworkFailure(this.error);
}
