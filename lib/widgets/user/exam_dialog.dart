import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/exam/exam_bloc.dart';
import 'package:tobetoapp/bloc/exam/exam_event.dart';
import 'package:tobetoapp/bloc/exam/exam_state.dart';
import 'package:tobetoapp/widgets/user/result_dialog.dart';

class ExamDialog extends StatefulWidget {
  final String subject;
  final VoidCallback onQuizCompleted;

  const ExamDialog(
      {super.key, required this.subject, required this.onQuizCompleted});

  @override
  _ExamDialogState createState() => _ExamDialogState();
}

class _ExamDialogState extends State<ExamDialog> {
  @override
  void initState() {
    super.initState();
    context.read<ExamBloc>().add(LoadQuestions(widget.subject));
  }

  void _showResultDialog(BuildContext context, ExamCompleted state) {
    Navigator.of(context).pop(); // Close the QuizDialog
    widget.onQuizCompleted(); // Notify parent to refresh state

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return ResultDialog(subject: widget.subject);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ).drive(Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          )),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExamBloc, ExamState>(
      listener: (context, state) {
        if (state is ExamCompleted) {
          _showResultDialog(context, state);
        }
      },
      child: BlocBuilder<ExamBloc, ExamState>(
        builder: (context, state) {
          if (state is ExamLoading) {
            return const AlertDialog(
              title: Text('Quiz'),
              content: Center(child: CircularProgressIndicator()),
            );
          } else if (state is ExamLoaded) {
            final currentQuestion = state.questions[state.currentQuestionIndex];
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              title: Center(
                child: Text(
                  widget.subject,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Soru ${state.currentQuestionIndex + 1}:',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    currentQuestion.question,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ...currentQuestion.answers.asMap().entries.map((entry) {
                    int idx = entry.key;
                    String answer = entry.value;
                    bool isCorrect = currentQuestion.correct == idx;
                    bool isSelected = state.selectedAnswer == idx;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.purple[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: state.isAnswered
                            ? null
                            : () =>
                                context.read<ExamBloc>().add(CheckAnswer(idx)),
                        child: Row(
                          children: [
                            Expanded(child: Text(answer)),
                            if (state.isAnswered && isSelected && !isCorrect)
                              const Icon(Icons.close, color: Colors.red),
                            if (state.isAnswered && isCorrect)
                              const Icon(Icons.check, color: Colors.green),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
              actions: [
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.grey,
                      backgroundColor: Colors.purple[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: state.isAnswered
                        ? () => context.read<ExamBloc>().add(NextQuestion())
                        : null,
                    child: Text(
                      'Sonraki Soru',
                      style: TextStyle(
                        color:
                            state.isAnswered ? Colors.deepPurple : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is ExamError) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(state.message),
            );
          } else {
            return const AlertDialog(
              title: Text('Quiz'),
              content: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
