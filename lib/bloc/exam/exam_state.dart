import 'package:tobetoapp/models/question.dart';

abstract class ExamState {}

class ExamInitial extends ExamState {}

class ExamLoading extends ExamState {}

class ExamLoaded extends ExamState {
  final List<Question> questions;
  final int currentQuestionIndex;
  final int correctAnswers;
  final int wrongAnswers;
  final bool isAnswered;
  final int selectedAnswer;
  final String subject;

  ExamLoaded({
    required this.questions,
    required this.currentQuestionIndex,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.isAnswered,
    required this.selectedAnswer,
    required this.subject,
  });

  ExamLoaded copyWith({
    List<Question>? questions,
    int? currentQuestionIndex,
    int? correctAnswers,
    int? wrongAnswers,
    bool? isAnswered,
    int? selectedAnswer,
    String? subject,
  }) {
    return ExamLoaded(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
      isAnswered: isAnswered ?? this.isAnswered,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      subject: subject ?? this.subject,
    );
  }
}

class ExamCompleted extends ExamState {
  final int correctAnswers;
  final int totalQuestions;
  final String subject;

  ExamCompleted({
    required this.correctAnswers,
    required this.totalQuestions,
    required this.subject,
  });
}

class ExamError extends ExamState {
  final String message;

  ExamError(this.message);
}

class ExamCompletionStatus extends ExamState {
  final String subject;
  final bool isCompleted;

  ExamCompletionStatus({
    required this.subject,
    required this.isCompleted,
  });
}

class ExamResultLoading extends ExamState {}

class ExamResultLoaded extends ExamState {
  final int correctAnswers;
  final int wrongAnswers;
  final int score;

  ExamResultLoaded({
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.score,
  });
}
