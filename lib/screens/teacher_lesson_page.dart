import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:tobetoapp/bloc/auth/auth_drawer/auth_provider_drawer.dart';
import 'package:tobetoapp/bloc/lessons/lesson_bloc.dart';
import 'package:tobetoapp/bloc/lessons/lesson_event.dart';
import 'package:tobetoapp/bloc/lessons/lesson_state.dart';
import 'package:tobetoapp/models/lesson_model.dart';
import 'package:tobetoapp/models/user_model.dart';
import 'package:tobetoapp/repository/lessons/lesson_repository.dart';
import 'package:tobetoapp/screens/teacher_live_lesson_page.dart';

class TeacherLessonPage extends StatefulWidget {
  final String teacherId;

  const TeacherLessonPage({super.key, required this.teacherId});

  @override
  _TeacherLessonPageState createState() => _TeacherLessonPageState();
}

class _TeacherLessonPageState extends State<TeacherLessonPage> {
  @override
  void initState() {
    super.initState();
    _loadLessons();
    initializeDateFormatting();
  }

  void _loadLessons() {
    context.read<LessonBloc>().add(LoadTeacherLessons(widget.teacherId));
  }

  Future<List<UserModel>> _fetchStudents(LessonModel lesson) async {
    final students =
        await context.read<LessonRepository>().fetchStudents(lesson);
    return students;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sınıflar",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      drawer: const DrawerManager(),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 150, // Banner yüksekliği
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/logo/general_banner.png', // Banner resmi
                    fit: BoxFit.cover,
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Sınıflar", // Banner içindeki yazı
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<LessonBloc, LessonState>(
              builder: (context, state) {
                if (state is LessonsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is LessonsLoaded) {
                  if (state.lessons.isEmpty) {
                    return const Center(child: Text("Kurs bulunamadı."));
                  } else {
                    return ListView.builder(
                      itemCount: state.lessons.length,
                      itemBuilder: (context, index) {
                        return _buildLessonItem(state.lessons[index]);
                      },
                    );
                  }
                } else if (state is LessonOperationFailure) {
                  return Center(
                      child: Text(
                          "Kurslar yüklenirken hata oluştu: ${state.error}"));
                } else {
                  return const Center(
                      child: Text("Bilinmeyen bir hata oluştu."));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonItem(LessonModel lesson) {
    return Column(
      children: [
        ListTile(
          leading: lesson.image != null
              ? Image.network(
                  lesson.image!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              : Container(width: 50, height: 50, color: Colors.grey),
          title: Text(lesson.title ?? "Başlık Yok"),
          subtitle: FutureBuilder<List<UserModel>>(
            future: _fetchStudents(lesson),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Öğrenci sayısı yükleniyor...');
              } else if (snapshot.hasError) {
                return Text('Hata: ${snapshot.error}');
              } else {
                final students = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 4),
                        Text('Başlangıç: ${_formatDate(lesson.startDate)}'),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 4),
                        Text('Bitiş: ${_formatDate(lesson.endDate)}'),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.people, size: 16),
                        const SizedBox(width: 4),
                        Text('Öğrenci Sayısı: ${students.length}'),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        _showStudentsBottomSheet(context, students);
                      },
                      child: const Text('Kullanıcı listesini görüntüle'),
                    ),
                    const Divider(),
                  ],
                );
              }
            },
          ),
          onTap: () {
            _navigateToLessonPage(lesson);
          },
        ),
      ],
    );
  }

  void _navigateToLessonPage(LessonModel lesson) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => LessonLivePage(lesson: lesson)))
        .then((_) {
      _loadLessons(); // geri dönüldüğünde kursların tekrar listelenmesi için
    });
  }

  void _showStudentsBottomSheet(
      BuildContext context, List<UserModel> students) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Öğrenci Sayısı: ${students.length}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              students.isEmpty
                  ? const Text(
                      'Bu ders için henüz kayıtlı öğrenci bulunmamaktadır.')
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            '${index + 1}. ${students[index].firstName} ${students[index].lastName}',
                          ),
                        );
                      },
                    ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Tarih yok';
    return DateFormat('dd MMM yyyy, hh:mm', 'tr').format(date);
  }
}
