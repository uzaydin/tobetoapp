import 'package:tobetoapp/models/competency_test_question.dart';

abstract class CompetencyTestState {
  const CompetencyTestState();
}

class CompetencyTestInitial extends CompetencyTestState {}

class CompetencyTestLoading extends CompetencyTestState {}

class CompetencyTestLoaded extends CompetencyTestState {
  final List<CompetencyQuestion> questions;

  const CompetencyTestLoaded({required this.questions});
}

class CompetencyTestResultSaved extends CompetencyTestState {}

class CompetencyTestResultFetched extends CompetencyTestState {
  final CompetencyTestResult result;

  const CompetencyTestResultFetched({required this.result});
}

class CompetencyTestError extends CompetencyTestState {
  final String message;

  const CompetencyTestError({required this.message});
}
