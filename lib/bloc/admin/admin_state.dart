import 'package:tobetoapp/models/class_model.dart';
import 'package:tobetoapp/models/lesson_model.dart';
import 'package:tobetoapp/models/userModel.dart';

abstract class AdminState {}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminError extends AdminState {
  final String message;

  AdminError({required this.message});
}

// AdminPanel Chart
class ChartDataLoaded extends AdminState {
  final Map<String, int> classDistribution;
  final List<int> monthlyRegistrations;

  ChartDataLoaded(
      {required this.classDistribution, required this.monthlyRegistrations});
}

// User Management
class UsersDataLoaded extends AdminState {
  final List<UserModel> users;
  final Map<String, String> classNames;

  UsersDataLoaded({required this.users, required this.classNames});
}

// User Management for user's class name
class ClassNamesForUserLoaded extends AdminState {
  final UserModel user;
  final Map<String, String> classNames;

  ClassNamesForUserLoaded({required this.user, required this.classNames});
}

class ClassesLoaded extends AdminState {
  final List<ClassModel> classes;

  ClassesLoaded({
    required this.classes,
  });
}

class ClassDetailsLoaded extends AdminState {
  final ClassModel classDetails;
  final List<UserModel> users;
  final List<LessonModel> lessons;

  ClassDetailsLoaded(
      {required this.classDetails, required this.users, required this.lessons});
}

// Ders işlemleri
class LessonsLoaded extends AdminState {
  final List<LessonModel> lessons;

  LessonsLoaded({required this.lessons});
}

class LessonImageUploaded extends AdminState {
  final String imageUrl;

  LessonImageUploaded({required this.imageUrl});
}

class LessonDetailsLoaded extends AdminState {
  final LessonModel lesson;
  final List<UserModel> teachers;
  final List<ClassModel> classes;

  LessonDetailsLoaded(
      {required this.lesson, required this.teachers, required this.classes});
}