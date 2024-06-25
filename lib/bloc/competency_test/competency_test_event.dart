abstract class CompetencyTestEvent {
  const CompetencyTestEvent();
}

class LoadQuestions extends CompetencyTestEvent {}

class SaveResult extends CompetencyTestEvent {
  final Map<String, double> scores;

  const SaveResult(this.scores);
}

class FetchCompetencyTestResult extends CompetencyTestEvent {}
