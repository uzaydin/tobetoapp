import 'package:tobetoapp/models/class_model.dart';

class ClassEvent {}

class LoadClasses extends ClassEvent {}

class AddClass extends ClassEvent {
  final ClassModel classModels;

  AddClass(this.classModels);
}

class DeleteClass extends ClassEvent {
  final String id;

  DeleteClass(this.id);
}

class ClassUpdated extends ClassEvent {
  final List<ClassModel> classes;

  ClassUpdated(this.classes);
}