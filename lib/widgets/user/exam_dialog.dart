import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/exam/exam_bloc.dart';
import 'package:tobetoapp/bloc/exam/exam_event.dart';
import 'package:tobetoapp/bloc/exam/exam_state.dart';
import 'package:tobetoapp/models/question.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';
import 'package:tobetoapp/widgets/user/result_dialog.dart';

class ExamDialog extends StatefulWidget {
  final String subject;
  final VoidCallback onQuizCompleted;

  const ExamDialog({
    Key? key,
    required this.subject,
    required this.onQuizCompleted,
  }) : super(key: key);

  @override
  _ExamDialogState createState() => _ExamDialogState();
}

class _ExamDialogState extends State<ExamDialog> {
  @override
  void initState() {
    super.initState();
    context.read<ExamBloc>().add(LoadQuestions(widget.subject));
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
            return _buildExamDialog(context, state);
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

  void _showResultDialog(BuildContext context, ExamCompleted state) {
    Navigator.of(context).pop();
    widget.onQuizCompleted();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return ResultDialog(subject: widget.subject);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          )),
          child: child,
        );
      },
    );
  }

  Widget _buildExamDialog(BuildContext context, ExamLoaded state) {
    final currentQuestion = state.questions[state.currentQuestionIndex];

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppConstants.br20)),
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
          SizedBox(height: AppConstants.sizedBoxHeightSmall),
          Text(
            currentQuestion.question,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppConstants.sizedBoxHeightLarge),
          ..._buildAnswerButtons(context, currentQuestion, state),
        ],
      ),
      actions: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.grey,
              backgroundColor: Colors.purple[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.br10),
              ),
            ),
            onPressed: state.isAnswered
                ? () => context.read<ExamBloc>().add(NextQuestion())
                : null,
            child: Text(
              'Sonraki Soru',
              style: TextStyle(
                color: state.isAnswered ? Colors.deepPurple : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildAnswerButtons(
      BuildContext context, Question currentQuestion, ExamLoaded state) {
    return currentQuestion.answers.asMap().entries.map((entry) {
      int idx = entry.key;
      String answer = entry.value;
      bool isCorrect = currentQuestion.correct == idx;
      bool isSelected = state.selectedAnswer == idx;

      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppConstants.verticalPaddingSmall / 3,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.purple[200],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.br10),
            ),
          ),
          onPressed: state.isAnswered
              ? null
              : () => context.read<ExamBloc>().add(CheckAnswer(idx)),
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
    }).toList();
  }
}
