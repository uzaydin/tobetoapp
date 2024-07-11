import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/exam/exam_bloc.dart';
import 'package:tobetoapp/bloc/exam/exam_event.dart';
import 'package:tobetoapp/bloc/exam/exam_state.dart';
import 'package:tobetoapp/repository/exam_repository.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';

class ResultDialog extends StatelessWidget {
  final String subject;

  const ResultDialog({Key? key, required this.subject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExamBloc(examRepository: ExamRepository())
        ..add(FetchResults(subject)),
      child: BlocBuilder<ExamBloc, ExamState>(
        builder: (context, state) {
          if (state is ExamResultLoading) {
            return _buildLoadingDialog();
          } else if (state is ExamResultLoaded) {
            return _buildResultDialog(context, state);
          } else if (state is ExamError) {
            return _buildErrorDialog(context, state);
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildLoadingDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppConstants.br20)),
      ),
      title: const Center(child: Text('Test Bitti')),
      content: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildResultDialog(BuildContext context, ExamResultLoaded state) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppConstants.br20)),
      ),
      title: const Center(
        child: Text(
          'Test Bitti',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildResultItem('Doğru', state.correctAnswers, context),
          SizedBox(height: AppConstants.sizedBoxHeightSmall),
          _buildResultItem('Yanlış', state.wrongAnswers, context),
          SizedBox(height: AppConstants.sizedBoxHeightSmall),
          _buildResultItem('Puan', state.score.toInt(), context),
        ],
      ),
      actions: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.br10),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Kapat',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorDialog(BuildContext context, ExamError state) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppConstants.br20)),
      ),
      title: const Center(child: Text('Test Bitti')),
      content: Text(state.message),
      actions: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.br10),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Kapat'),
          ),
        ),
      ],
    );
  }

  Widget _buildResultItem(String label, int value, BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: AppConstants.sizedBoxHeightSmall / 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
