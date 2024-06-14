import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/exam/exam_bloc.dart';
import 'package:tobetoapp/bloc/exam/exam_event.dart';
import 'package:tobetoapp/bloc/exam/exam_state.dart';
import 'package:tobetoapp/repository/exam_repository.dart';

class ResultDialog extends StatelessWidget {
  final String subject;

  const ResultDialog({super.key, required this.subject});

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
        const SizedBox(height: 8.0),
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExamBloc(examRepository: ExamRepository())
        ..add(FetchResults(subject)),
      child: BlocBuilder<ExamBloc, ExamState>(
        builder: (context, state) {
          if (state is ExamResultLoading) {
            return const AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              title: Center(
                child: Text('Test Bitti'),
              ),
              content: Center(child: CircularProgressIndicator()),
            );
          } else if (state is ExamResultLoaded) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
                  const SizedBox(height: 8.0),
                  _buildResultItem('Yanlış', state.wrongAnswers, context),
                  const SizedBox(height: 8.0),
                  _buildResultItem('Puan', state.score.toInt(), context),
                ],
              ),
              actions: [
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
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
          } else if (state is ExamError) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              title: const Center(
                child: Text('Test Bitti'),
              ),
              content: Text(state.message),
              actions: [
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
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
          } else {
            return Container(); // Handle other states if needed
          }
        },
      ),
    );
  }
}
