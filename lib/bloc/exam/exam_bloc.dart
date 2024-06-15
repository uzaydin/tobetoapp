import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/exam/exam_event.dart';
import 'package:tobetoapp/bloc/exam/exam_state.dart';
import 'package:tobetoapp/models/question.dart';
import 'package:tobetoapp/repository/exam_repository.dart';

class ExamBloc extends Bloc<ExamEvent, ExamState> {
  final ExamRepository _examRepository;

  ExamBloc({required ExamRepository examRepository})
      : _examRepository = examRepository,
        super(ExamInitial()) {
    on<LoadQuestions>(_loadQuestions);
    on<CheckAnswer>(_checkAnswer);
    on<NextQuestion>(_nextQuestion);
    on<CompleteExam>(_completeQuiz);
    on<CheckExamCompletionStatus>(_checkExamCompletionStatus);
    on<FetchResults>(_fetchResults);
  }

  Future<void> _loadQuestions(
      LoadQuestions event, Emitter<ExamState> emit) async {
    emit(ExamLoading());
    try {
      List<Question> questions =
          await _examRepository.loadQuestions(event.subject);

      emit(ExamLoaded(
        questions: questions,
        currentQuestionIndex: 0,
        correctAnswers: 0,
        wrongAnswers: 0,
        isAnswered: false,
        selectedAnswer: -1,
        subject: event.subject,
      ));
    } catch (e) {
      emit(ExamError("Sorular yüklenirken bir hata oluştu"));
    }
  }

  void _checkAnswer(CheckAnswer event, Emitter<ExamState> emit) {
    final currentState = state as ExamLoaded;
    final isCorrect =
        currentState.questions[currentState.currentQuestionIndex].correct ==
            event.selectedAnswer;

    emit(currentState.copyWith(
      isAnswered: true,
      selectedAnswer: event.selectedAnswer,
      correctAnswers: isCorrect
          ? currentState.correctAnswers + 1
          : currentState.correctAnswers,
      wrongAnswers:
          isCorrect ? currentState.wrongAnswers : currentState.wrongAnswers + 1,
    ));
  }

  void _nextQuestion(NextQuestion event, Emitter<ExamState> emit) {
    final currentState = state as ExamLoaded;

    if (currentState.currentQuestionIndex < currentState.questions.length - 1) {
      emit(currentState.copyWith(
        currentQuestionIndex: currentState.currentQuestionIndex + 1,
        isAnswered: false,
        selectedAnswer: -1,
      ));
    } else {
      add(CompleteExam(currentState.subject));
    }
  }

  Future<void> _completeQuiz(
      CompleteExam event, Emitter<ExamState> emit) async {
    final currentState = state as ExamLoaded;
    final totalQuestions = currentState.questions.length;
    final questionValue = 100 / totalQuestions;
    final finalScore = (currentState.correctAnswers * questionValue).round();

    emit(ExamCompleted(
      correctAnswers: currentState.correctAnswers,
      totalQuestions: totalQuestions,
      subject: event.subject,
    ));

    try {
      await _examRepository.saveResult(
        subject: event.subject,
        correctAnswers: currentState.correctAnswers,
        wrongAnswers: currentState.wrongAnswers,
        score: finalScore,
      );
      add(CheckExamCompletionStatus(
          event.subject)); // Add this line to trigger UI update
    } catch (e) {
      emit(ExamError("Cevaplar kaydedilirken bir hata oluştu"));
    }
  }

  Future<void> _checkExamCompletionStatus(
      CheckExamCompletionStatus event, Emitter<ExamState> emit) async {
    try {
      bool isCompleted = await _examRepository.hasCompletedExam(event.subject);
      emit(ExamCompletionStatus(
          subject: event.subject, isCompleted: isCompleted));
    } catch (e) {
      emit(ExamError("Sınav durumu kontrol edilirken bir hata oluştu"));
    }
  }

  Future<void> _fetchResults(
      FetchResults event, Emitter<ExamState> emit) async {
    emit(ExamResultLoading());
    try {
      DocumentSnapshot snapshot =
          await _examRepository.fetchResults(event.subject);
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        emit(ExamResultLoaded(
          correctAnswers: data['correctAnswers'],
          wrongAnswers: data['wrongAnswers'],
          score: data['score'],
        ));
      } else {
        emit(ExamError("Sonuçlar bulunamadı"));
      }
    } catch (e) {
      emit(ExamError("Sonuçlar yüklenirken bir hata oluştu"));
    }
  }
}
