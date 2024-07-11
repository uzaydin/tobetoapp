import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/lessons/lesson_event.dart';
import 'package:tobetoapp/bloc/lessons/lesson_state.dart';
import 'package:tobetoapp/models/lesson_model.dart';
import 'package:tobetoapp/repository/lessons/lesson_repository.dart';

class LessonBloc extends Bloc<LessonEvent, LessonState> {
  final LessonRepository _lessonRepository;
  StreamSubscription<List<LessonModel>>? _lessonsSubscription;

  LessonBloc(this._lessonRepository) : super(LessonsLoading()) {
    on<LoadLessons>(_loadLessons);
    on<AddLesson>(_addLesson);
    on<DeleteLesson>(_deleteLesson);
    on<LessonsUpdated>(_onLessonsUpdated);
    on<LoadTeacherLessons>(_loadTeacherLessons);
    on<FetchStudentsForLesson>(_fetchStudentsForLesson);
    on<FetchTeachersForLesson>(_fetchTeachersForLesson);
  }

  Future<void> _loadLessons(
      LoadLessons event, Emitter<LessonState> emit) async {
    emit(LessonsLoading());
    try {
      final lessons = await _lessonRepository.getLessons(event.classIds);
      if (lessons.isEmpty) {
        emit(LessonOperationFailure('No lessons found.'));
      } else {
        emit(LessonsLoaded(lessons));
      }
    } catch (e) {
      emit(LessonOperationFailure(e.toString()));
    }
  }

  void _onLessonsUpdated(LessonsUpdated event, Emitter<LessonState> emit) {
    emit(LessonsLoaded(event.lessons));
  }

  Future<void> _addLesson(AddLesson event, Emitter<LessonState> emit) async {
    try {
      await _lessonRepository.addLesson(event.lessonModel);
      emit(LessonOperationSuccess());
    } catch (e) {
      emit(LessonOperationFailure(e.toString()));
    }
  }

  Future<void> _deleteLesson(
      DeleteLesson event, Emitter<LessonState> emit) async {
    try {
      await _lessonRepository.deleteLesson(event.id);
      emit(LessonOperationSuccess());
    } catch (e) {
      emit(LessonOperationFailure(e.toString()));
    }
  }

  Future<void> _loadTeacherLessons(
      LoadTeacherLessons event, Emitter<LessonState> emit) async {
    emit(LessonsLoading());
    try {
      final lessons =
          await _lessonRepository.getLessonsByTeacherId(event.teacherId);
      if (lessons.isEmpty) {
        emit(LessonOperationFailure('No lessons found for this teacher.'));
      } else {
        emit(LessonsLoaded(lessons));
      }
    } catch (e) {
      emit(LessonOperationFailure(e.toString()));
    }
  }

  Future<void> _fetchStudentsForLesson(
      FetchStudentsForLesson event, Emitter<LessonState> emit) async {
    emit(LessonsLoading());
    try {
      final students = await _lessonRepository.fetchStudents(event.lesson);
      emit(StudentsLoaded(students));
    } catch (e) {
      emit(LessonOperationFailure(e.toString()));
    }
  }

  Future<void> _fetchTeachersForLesson(
      FetchTeachersForLesson event, Emitter<LessonState> emit) async {
    emit(LessonsLoading());
    try {
      final teachers = await _lessonRepository.getTeacherDetails(event.lesson);
      emit(TeachersLoaded(teachers));
    } catch (e) {
      emit(LessonOperationFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _lessonsSubscription?.cancel();
    return super.close();
  }
} 












// class LessonBloc extends Bloc<LessonEvent, LessonState> {
//   final LessonRepository _lessonRepository;
//   StreamSubscription<List<LessonModel>>? _lessonsSubscription;

//   LessonBloc(this._lessonRepository) : super(LessonsLoading()) {
//     on<LoadLessons>(_loadLessons);
//     // on<AddLesson>(_addLesson);
//     // on<DeleteLesson>(_deleteLesson);
//     // on<LessonsUpdated>(_onLessonsUpdated);
//   }

//   Future<void> _loadLessons(
//       LoadLessons event, Emitter<LessonState> emit) async {
//     try {
//       emit(LessonsLoading());
//       _lessonsSubscription?.cancel();
//       _lessonsSubscription =
//           _lessonRepository.getLessonsStream(event.classId).listen(
//         (lessons) {
//           add(LessonsUpdated(lessons));
//         },
//         onError: (error) {
//           emit(LessonOperationFailure(error.toString()));
//         },
//       );
//     } catch (e) {
//       emit(LessonOperationFailure(e.toString()));
//     }
//   }

//   // void _onLessonsUpdated(LessonsUpdated event, Emitter<LessonState> emit) {
//   //   emit(LessonsLoaded(event.lessons));
//   // }

//   // Future<void> _addLesson(AddLesson event, Emitter<LessonState> emit) async {
//   //   try {
//   //     await _lessonRepository.addLesson(event.lessonModel);
//   //     emit(LessonOperationSuccess());
//   //   } catch (e) {
//   //     emit(LessonOperationFailure(e.toString()));
//   //   }
//   // }

//   // Future<void> _deleteLesson(DeleteLesson event, Emitter<LessonState> emit) async {
//   //   try {
//   //     await _lessonRepository.deleteLesson(event.id);
//   //     emit(LessonOperationSuccess());
//   //   } catch (e) {
//   //     emit(LessonOperationFailure(e.toString()));
//   //   }
//   // }

//   @override
//   Future<void> close() {
//     _lessonsSubscription?.cancel();
//     return super.close();
//   }
// }
