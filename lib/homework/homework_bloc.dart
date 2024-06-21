import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/homework/homework_event.dart';
import 'package:tobetoapp/homework/homework_state.dart';
import 'package:tobetoapp/repository/lessons/homework_repository.dart';

class HomeworkBloc extends Bloc<HomeworkEvent, HomeworkState> {
  final HomeworkRepository _homeworkRepository;

  HomeworkBloc(this._homeworkRepository) : super(HomeworkInitial()) {
    on<AddHomework>(_onAddHomework);
    on<UpdateHomework>(_onUpdateHomework);
    on<DeleteHomework>(_onDeleteHomework);
    on<LoadHomeworks>(_onLoadHomeworks);
    on<UploadHomework>(_onUploadHomework);
  }

  Future<void> _onAddHomework(
      AddHomework event, Emitter<HomeworkState> emit) async {
    emit(HomeworkLoading());
    try {
      await _homeworkRepository.addHomework(event.homework);
      add(LoadHomeworks(event.homework.lessonId!)); // Reload homeworks
      emit(HomeworkSuccess());
    } catch (e) {
      emit(HomeworkFailure(e.toString()));
    }
  }

  Future<void> _onUpdateHomework(
      UpdateHomework event, Emitter<HomeworkState> emit) async {
    emit(HomeworkLoading());
    try {
      await _homeworkRepository.updateHomework(event.homework);
      add(LoadHomeworks(event.homework.lessonId!)); // Reload homeworks
      emit(HomeworkSuccess());
    } catch (e) {
      emit(HomeworkFailure(e.toString()));
    }
  }

  Future<void> _onDeleteHomework(
      DeleteHomework event, Emitter<HomeworkState> emit) async {
    emit(HomeworkLoading());
    try {
      await _homeworkRepository.deleteHomework(event.id, event.lessonId);
      add(LoadHomeworks(event.lessonId)); // Reload homeworks
      emit(HomeworkSuccess());
    } catch (e) {
      emit(HomeworkFailure(e.toString()));
    }
  }

  Future<void> _onLoadHomeworks(
      LoadHomeworks event, Emitter<HomeworkState> emit) async {
    emit(HomeworkLoading());
    try {
      final homeworks = await _homeworkRepository.getHomeworks(event.lessonId);
      emit(HomeworkLoaded(homeworks));
    } catch (e) {
      emit(HomeworkFailure(e.toString()));
    }
  }

  Future<void> _onUploadHomework(
      UploadHomework event, Emitter<HomeworkState> emit) async {
    emit(HomeworkLoading());
    try {
      await _homeworkRepository.uploadHomework(
          event.lessonId, event.homeworkId, event.filePath);
      add(LoadHomeworks(event.lessonId)); // Reload homeworks
      emit(HomeworkSuccess());
    } catch (e) {
      emit(HomeworkFailure(e.toString()));
    }
  }
}
