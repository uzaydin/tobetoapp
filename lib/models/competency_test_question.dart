class CompetencyQuestion {
  final String category;
  final int id;
  final String text;

  CompetencyQuestion(
      {required this.category, required this.id, required this.text});

  factory CompetencyQuestion.fromMap(Map<String, dynamic> map) {
    return CompetencyQuestion(
      category: map['category'],
      id: map['id'],
      text: map['text'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'id': id,
      'text': text,
    };
  }
}

class CompetencyTestResult {
  final Map<String, double> scores; // category -> score

  CompetencyTestResult({required this.scores});

  factory CompetencyTestResult.fromMap(Map<String, dynamic> map) {
    return CompetencyTestResult(
      scores: Map<String, double>.from(map['scores']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'scores': scores,
    };
  }
}
