import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/competency_test/competency_test_event.dart';
import 'package:tobetoapp/bloc/competency_test/competency_test_state.dart';
import 'package:tobetoapp/repository/competency_test_repository.dart';

class CompetencyTestBloc
    extends Bloc<CompetencyTestEvent, CompetencyTestState> {
  final CompetencyTestRepository repository;

  CompetencyTestBloc({required this.repository})
      : super(CompetencyTestInitial()) {
    on<LoadQuestions>(_onLoadQuestions);
    on<SaveResult>(_onSaveResult);
    on<FetchCompetencyTestResult>(_onFetchCompetencyTestResult);
  }

  Future<void> _onLoadQuestions(
      LoadQuestions event, Emitter<CompetencyTestState> emit) async {
    emit(CompetencyTestLoading());
    try {
      final questions = await repository.fetchQuestions();
      emit(CompetencyTestLoaded(questions: questions));
    } catch (e) {
      emit(CompetencyTestError(message: e.toString()));
    }
  }

  Future<void> _onSaveResult(
      SaveResult event, Emitter<CompetencyTestState> emit) async {
    emit(CompetencyTestLoading());
    try {
      await repository.saveResult(event.scores);
      emit(CompetencyTestResultSaved());
      add(FetchCompetencyTestResult());
    } catch (e) {
      emit(CompetencyTestError(message: e.toString()));
    }
  }

  Future<void> _onFetchCompetencyTestResult(FetchCompetencyTestResult event,
      Emitter<CompetencyTestState> emit) async {
    emit(CompetencyTestLoading());
    try {
      final result = await repository.getResult();
      if (result != null) {
        emit(CompetencyTestResultFetched(result: result));
      } else {
        emit(CompetencyTestInitial());
      }
    } catch (e) {
      emit(CompetencyTestError(message: e.toString()));
    }
  }
}
