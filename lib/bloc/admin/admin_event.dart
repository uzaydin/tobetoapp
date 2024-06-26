import 'package:image_picker/image_picker.dart';
import 'package:tobetoapp/models/class_model.dart';
import 'package:tobetoapp/models/lesson_model.dart';
import 'package:tobetoapp/models/user_model.dart';

abstract class AdminEvent {}

class LoadChartData extends AdminEvent {}

class LoadUserData extends AdminEvent {}

class LoadClassNamesForUser extends AdminEvent {
  final UserModel user;

  LoadClassNamesForUser(this.user);
}

class UpdateUser extends AdminEvent {
  final UserModel user;

  UpdateUser(this.user);
}

class DeleteUser extends AdminEvent {
  final String userId;

  DeleteUser(this.userId);
}

// Sınıf işlemleri
class LoadClasses extends AdminEvent {}

class AddClass extends AdminEvent {
  final ClassModel newClass;
  AddClass(this.newClass);
}

class UpdateClass extends AdminEvent {
  final ClassModel updatedClass;
  UpdateClass(this.updatedClass);
}

class DeleteClass extends AdminEvent {
  final String classId;
  DeleteClass(this.classId);
}

class LoadClassDetails extends AdminEvent {
  final String classId;
  LoadClassDetails(this.classId);
}

// Ders İşlemleri

class LoadLessons extends AdminEvent {}

class AddLesson extends AdminEvent {
  final LessonModel newLesson;
  AddLesson(this.newLesson);
}

class UpdateLesson extends AdminEvent {
  final LessonModel updatedLesson;

  UpdateLesson(
    this.updatedLesson,
  );
}

class UploadLessonImage extends AdminEvent {
  final String lessonId;
  final XFile imageFile;

  UploadLessonImage({required this.lessonId, required this.imageFile});
}

class DeleteLesson extends AdminEvent {
  final String lessonId;
  DeleteLesson(this.lessonId);
}

class LoadLessonDetails extends AdminEvent {
  final String lessonId;
  LoadLessonDetails(this.lessonId);
}

class AssignClassToLesson extends AdminEvent {
  final String lessonId;
  final String classId;
  AssignClassToLesson(this.lessonId, this.classId);
}

class RemoveClassFromLesson extends AdminEvent {
  final String lessonId;
  final String classId;
  RemoveClassFromLesson(this.lessonId, this.classId);
}