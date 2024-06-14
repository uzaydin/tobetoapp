abstract class ExamEvent {}

class LoadQuestions extends ExamEvent {
  final String subject;

  LoadQuestions(this.subject);
}

class CheckAnswer extends ExamEvent {
  final int selectedAnswer;

  CheckAnswer(this.selectedAnswer);
}

class NextQuestion extends ExamEvent {}

class CompleteExam extends ExamEvent {
  final String subject;

  CompleteExam(this.subject);
}

class CheckExamCompletionStatus extends ExamEvent {
  final String subject;

  CheckExamCompletionStatus(this.subject);
}

class FetchResults extends ExamEvent {
  final String subject;

  FetchResults(this.subject);
}
