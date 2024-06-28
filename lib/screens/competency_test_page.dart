import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/competency_test/competency_test_bloc.dart';
import 'package:tobetoapp/bloc/competency_test/competency_test_event.dart';
import 'package:tobetoapp/bloc/competency_test/competency_test_state.dart';
import 'package:tobetoapp/models/competency_test_question.dart';
import 'package:tobetoapp/screens/competency_test_result_page.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';

class CompetencyTestPage extends StatefulWidget {
  const CompetencyTestPage({super.key});

  @override
  _CompetencyTestPageState createState() => _CompetencyTestPageState();
}

class _CompetencyTestPageState extends State<CompetencyTestPage> {
  final Map<int, int> answers = {};
  List<CompetencyQuestion>? questions;
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    //AppConstants.init(context);
    context.read<CompetencyTestBloc>().add(LoadQuestions());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool areAllQuestionsAnswered(List<CompetencyQuestion> questions) {
    for (var question in questions) {
      if (!answers.containsKey(question.id)) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tobeto İşte Başarı Modeli'),
        backgroundColor: const Color(0xFFF3E5F5),
        centerTitle: true,
      ),
      body: BlocConsumer<CompetencyTestBloc, CompetencyTestState>(
        listener: (context, state) {
          if (state is CompetencyTestResultSaved) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const CompetencyTestResultPage(),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CompetencyTestLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CompetencyTestLoaded) {
            questions = state.questions;
            questions!.sort(
                (a, b) => a.id.compareTo(b.id)); // Soruları id'ye göre sırala
            int totalPages = (questions!.length / 10).ceil();

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(AppConstants.paddingMedium),
                  child: const Text(
                    'Tobeto İşte Başarı Modeli',
                    style: TextStyle(
                      color: Color(0xFF9933ff),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingMedium),
                  child: LinearProgressIndicator(
                    value: (currentPage + 1) / totalPages,
                    backgroundColor: const Color(0xFFD8D8D8),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xFF9933ff)),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: totalPages,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    itemBuilder: (context, pageIndex) {
                      int start = pageIndex * 10;
                      int end = (start + 10 < questions!.length)
                          ? start + 10
                          : questions!.length;
                      List<CompetencyQuestion> pageQuestions =
                          questions!.sublist(start, end);

                      return ListView.builder(
                        itemCount: pageQuestions.length,
                        itemBuilder: (context, index) {
                          final question = pageQuestions[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: AppConstants.verticalPaddingSmall,
                                horizontal: AppConstants.paddingMedium),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${question.id}. ${question.text}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: List.generate(5, (i) {
                                    return Column(
                                      children: [
                                        Radio<int>(
                                          value: i - 2, // --, -, 0, +, ++
                                          groupValue: answers[question.id],
                                          onChanged: (value) {
                                            setState(() {
                                              answers[question.id] = value!;
                                            });
                                          },
                                        ),
                                        Text(
                                          ['--', '-', '0', '+', '++'][i],
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(AppConstants.paddingMedium),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xFF9933ff),
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFF9933ff)),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppConstants.br8),
                          ),
                        ),
                        onPressed: currentPage == 0
                            ? null
                            : () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                        child: const Text('Geri'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: areAllQuestionsAnswered(questions!
                                  .sublist(
                                      currentPage * 10,
                                      (currentPage * 10 + 10 <
                                              questions!.length)
                                          ? currentPage * 10 + 10
                                          : questions!.length))
                              ? Colors.white
                              : const Color(0xFF9933ff),
                          backgroundColor: areAllQuestionsAnswered(questions!
                                  .sublist(
                                      currentPage * 10,
                                      (currentPage * 10 + 10 <
                                              questions!.length)
                                          ? currentPage * 10 + 10
                                          : questions!.length))
                              ? const Color(0xFF9933ff)
                              : Colors.white,
                          side: BorderSide(
                              color: areAllQuestionsAnswered(questions!.sublist(
                                      currentPage * 10,
                                      (currentPage * 10 + 10 <
                                              questions!.length)
                                          ? currentPage * 10 + 10
                                          : questions!.length))
                                  ? const Color(0xFF9933ff)
                                  : Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppConstants.br8),
                          ),
                        ),
                        onPressed: areAllQuestionsAnswered(questions!.sublist(
                                currentPage * 10,
                                (currentPage * 10 + 10 < questions!.length)
                                    ? currentPage * 10 + 10
                                    : questions!.length))
                            ? () {
                                if (currentPage == totalPages - 1) {
                                  final scores = calculateScores(answers);
                                  context
                                      .read<CompetencyTestBloc>()
                                      .add(SaveResult(scores));
                                } else {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              }
                            : null,
                        child: Text(currentPage == totalPages - 1
                            ? 'Değerlendirmeyi Bitir'
                            : 'İleri'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is CompetencyTestError) {
            return Center(child: Text(state.message));
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Map<String, double> calculateScores(Map<int, int> answers) {
    Map<String, List<int>> categorizedAnswers = {};
    for (var entry in answers.entries) {
      var question = questions!.firstWhere((q) => q.id == entry.key);
      if (!categorizedAnswers.containsKey(question.category)) {
        categorizedAnswers[question.category] = [];
      }
      categorizedAnswers[question.category]!.add(entry.value);
    }

    Map<String, double> scores = {};
    categorizedAnswers.forEach((category, values) {
      double rawScore = values.reduce((a, b) => a + b) / values.length;
      scores[category] = ((rawScore + 2) / 4) * 5; // Normalize to 5 scale
    });

    return scores;
  }
}
