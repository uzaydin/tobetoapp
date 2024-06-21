import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import 'package:intl/intl.dart';
import 'package:tobetoapp/bloc/lessons/lesson_bloc.dart';
import 'package:tobetoapp/bloc/lessons/lesson_event.dart';
import 'package:tobetoapp/bloc/lessons/lesson_live/live_session_bloc.dart';
import 'package:tobetoapp/bloc/lessons/lesson_live/live_session_event.dart';
import 'package:tobetoapp/bloc/lessons/lesson_live/live_session_state.dart';
import 'package:tobetoapp/bloc/lessons/lesson_state.dart';
import 'package:tobetoapp/homework/homework_bloc.dart';
import 'package:tobetoapp/homework/homework_event.dart';
import 'package:tobetoapp/homework/homework_state.dart';
import 'package:tobetoapp/models/lesson_model.dart';

class StudentLiveLessonPage extends StatefulWidget {
  final LessonModel lesson;

  const StudentLiveLessonPage({Key? key, required this.lesson})
      : super(key: key);

  @override
  _StudentLiveLessonPageState createState() => _StudentLiveLessonPageState();
}

class _StudentLiveLessonPageState extends State<StudentLiveLessonPage> {
  bool showHomework = false;

  @override
  void initState() {
    super.initState();
    context.read<HomeworkBloc>().add(LoadHomeworks(widget.lesson.id!));
    context
        .read<LiveSessionBloc>()
        .add(FetchLiveSessions(widget.lesson.liveSessions ?? []));
    context
        .read<LessonBloc>()
        .add(LoadTeacherNames(widget.lesson.teacherIds ?? []));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<LessonBloc>().add(LoadLessons(widget.lesson.classIds));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.lesson.title ?? 'Kurs Detayları'),
        ),
        body: BlocListener<HomeworkBloc, HomeworkState>(
          listener: (context, state) {
            if (state is HomeworkSuccess) {
              context
                  .read<HomeworkBloc>()
                  .add(LoadHomeworks(widget.lesson.id!));
            }
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  widget.lesson.image ?? '',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.lesson.title ?? '',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      OutlinedButton(
                        onPressed: _showCourseInfoDialog,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.purple,
                          side: const BorderSide(color: Colors.purple),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'DETAY',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Oturumlar',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      BlocBuilder<LiveSessionBloc, LiveSessionState>(
                        builder: (context, state) {
                          if (state is LiveSessionLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is LiveSessionLoaded) {
                            final liveSessions = state.liveSessions;
                            return Column(
                              children: liveSessions.map((session) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: ExpansionTile(
                                    title: Text(session.title ?? 'Oturum'),
                                    children: [
                                      ListTile(
                                        leading:
                                            const Icon(Icons.calendar_today),
                                        title: Text(
                                            'Başlangıç: ${_formatDate(session.startDate)}'),
                                        subtitle: Text(
                                            'Bitiş: ${_formatDate(session.endDate)}'),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          } else if (state is LiveSessionFailure) {
                            return Center(child: Text('Error: ${state.error}'));
                          } else {
                            return const Center(
                                child: Text('Unknown error occurred.'));
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Icon(Icons.school),
                          SizedBox(width: 8),
                          Text(
                            'Eğitmenler',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      BlocBuilder<LessonBloc, LessonState>(
                        builder: (context, state) {
                          if (state is LessonsLoading) {
                            return const CircularProgressIndicator();
                          } else if (state is TeacherNamesLoaded) {
                            final teacherNames = state.teacherNames;
                            return Wrap(
                              children: teacherNames.entries.map((entry) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Text(
                                    entry.value,
                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                );
                              }).toList(),
                            );
                          } else if (state is LessonOperationFailure) {
                            return const Text('Hata');
                          } else {
                            return const Text('Bilinmeyen bir hata oluştu.');
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            showHomework = !showHomework;
                          });
                        },
                        child: Row(
                          children: [
                            const Text(
                              'Ödevler',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                            Icon(
                              showHomework
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: Colors.purple,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (showHomework)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BlocBuilder<HomeworkBloc, HomeworkState>(
                      builder: (context, homeworkState) {
                        if (homeworkState is HomeworkLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (homeworkState is HomeworkLoaded) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('Ödev Adı')),
                                DataColumn(label: Text('Açıklama')),
                                DataColumn(label: Text('Son Teslim Tarihi')),
                                DataColumn(label: Text('Gönderim Durumu')),
                                DataColumn(label: Text('Yükle')),
                              ],
                              rows: homeworkState.homeworks.map((homework) {
                                bool hasSubmitted = homework.studentSubmissions
                                        ?.any((submission) =>
                                            submission['uid'] ==
                                            FirebaseAuth
                                                .instance.currentUser!.uid) ??
                                    false;
                                return DataRow(cells: [
                                  DataCell(Text(homework.title ?? '')),
                                  DataCell(Text(homework.description ?? '')),
                                  DataCell(Text(homework.dueDate != null
                                      ? _formatDate(homework.dueDate)
                                      : '')),
                                  DataCell(Text(hasSubmitted
                                      ? 'Gönderildi'
                                      : 'Gönderilmedi')),
                                  DataCell(
                                    ElevatedButton(
                                      onPressed: hasSubmitted
                                          ? null
                                          : () => _pickAndUploadHomework(
                                              homework.id!),
                                      child: const Text('Yükle'),
                                    ),
                                  ),
                                ]);
                              }).toList(),
                            ),
                          );
                        } else if (homeworkState is HomeworkFailure) {
                          return Center(
                              child: Text('Error: ${homeworkState.error}'));
                        } else {
                          return const Center(
                              child: Text('Unknown error occurred.'));
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickAndUploadHomework(String homeworkId) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      return;
    }

    context.read<HomeworkBloc>().add(UploadHomework(
          lessonId: widget.lesson.id!,
          homeworkId: homeworkId,
          filePath: pickedFile.path,
        ));
  }

  void _showCourseInfoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text(widget.lesson.title ?? '')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const Icon(Icons.description),
                title: Text('Açıklama: ${widget.lesson.description ?? 'Yok'}'),
              ),
              ListTile(
                leading: const Icon(Icons.category),
                title: Text(
                    'Kategori: ${widget.lesson.category ?? 'Kategori belirtilmemiş'}'),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title:
                    Text('Başlangıç: ${_formatDate(widget.lesson.startDate)}'),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text('Bitiş: ${_formatDate(widget.lesson.endDate)}'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Kapat'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Tarih yok';
    return DateFormat('dd MMM yyyy, hh:mm', 'tr').format(date);
  }
}
