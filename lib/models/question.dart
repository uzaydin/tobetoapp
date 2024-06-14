import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String id;
  final String question;
  final List<String> answers;
  final int correct;

  Question({
    required this.id,
    required this.question,
    required this.answers,
    required this.correct,
  });

  factory Question.fromDocument(DocumentSnapshot doc) {
    return Question(
      id: doc.id,
      question: doc['question'],
      answers: List<String>.from(doc['answers']),
      correct: doc['correct'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answers': answers,
      'correct': correct,
    };
  }
}
