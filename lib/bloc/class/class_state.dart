
import 'package:tobetoapp/models/class_model.dart';

class ClassState {}

class ClassLoading extends ClassState {}

class ClassesLoaded extends ClassState {
  final List<ClassModel> classes;

  ClassesLoaded(this.classes);
}

class ClassOperationSuccess extends ClassState {}

class ClassOperationFailure extends ClassState {
  final String error;

  ClassOperationFailure(this.error);
}