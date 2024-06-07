// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tobetoapp/bloc/lessons_yagmur/lessons_event.dart';
// import 'package:tobetoapp/bloc/lessons_yagmur/lessons_state.dart';
// import 'package:tobetoapp/models/lesson_model_yagmur.dart';
// import 'package:tobetoapp/repository/lesson_repository_yagmur.dart';

// class LessonBloc extends Bloc<LessonEvent, LessonState> {
//   final LessonRepository lessonRepository;

//   LessonBloc({required this.lessonRepository}) : super(LessonInitial()) {
//     on<FetchUserLessons>(_onFetchUserLessons);
//     on<ResetFetchLessons>(_onReset);
//     on<LoadLessons>(_onLoadLessons);
//   }

//   Future<void> _onFetchUserLessons(FetchUserLessons event, Emitter<LessonState> emit) async {
//     emit(LessonLoading());
//     try {
//       final userLessonList = await lessonRepository.getLessons(event.userLessonList);
//       emit(LessonLoaded(lessonList: userLessonList));
//     } catch (e) {
//       emit(LessonError());
//     }
//   }

//   Future<void> _onReset(ResetFetchLessons event, Emitter<LessonState> emit) async {
//     emit(LessonInitial());
//   }

//   Future<void> _onLoadLessons(LoadLessons event, Emitter<LessonState> emit) async {
//     emit(LessonLoading());
//     try {
//       List<Lesson> lessons = await lessonRepository.getLessons(event.userLessonList);
//       emit(LessonLoaded(lessonList: lessons));
//     } catch (e) {
//       emit(LessonError());
//     }
//   }
// }
