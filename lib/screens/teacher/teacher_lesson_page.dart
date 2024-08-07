import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:tobetoapp/bloc/auth/auth_drawer/drawer_manager.dart';

import 'package:tobetoapp/bloc/lessons/lesson_bloc.dart';
import 'package:tobetoapp/bloc/lessons/lesson_event.dart';
import 'package:tobetoapp/bloc/lessons/lesson_state.dart';
import 'package:tobetoapp/models/lesson_model.dart';
import 'package:tobetoapp/models/user_model.dart';
import 'package:tobetoapp/repository/lessons/lesson_repository.dart';
import 'package:tobetoapp/screens/teacher/teacher_live_lesson_page.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eğitimlerim",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      drawer: DrawerManager(),
      body: Column(
        children: [
          _buildBannerWidget(),
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
                  return const Center(
                      child:
                          Text("Henüz size atanmış bir kurs bulunmamaktadır!"));
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

  Widget _buildBannerWidget() {
    return SizedBox(
      width: double.infinity,
      height: AppConstants.screenHeight * 0.2, // Banner yüksekliği
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/logo/general_banner.png', // Banner resmi
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(AppConstants.paddingMedium),
              child: const Text(
                "Eğitimlerim", // Banner içindeki yazı
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
    );
  }

  Widget _buildLessonItem(LessonModel lesson) {
    return Column(
      children: [
        ListTile(
          leading: lesson.image != null
              ? Image.network(
                  lesson.image!,
                  width: AppConstants.screenWidth * 0.1,
                  height: AppConstants.screenWidth * 0.1,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: AppConstants.screenWidth * 0.1,
                  height: AppConstants.screenWidth * 0.1,
                  color: Colors.grey,
                ),
          title: Text(lesson.title ?? "Başlık Yok"),
          subtitle: _buildLessonSubtitle(lesson),
          onTap: () => _navigateToLessonPage(lesson),
        ),
      ],
    );
  }

  Widget _buildLessonSubtitle(LessonModel lesson) {
    return FutureBuilder<List<UserModel>>(
      future: context.read<LessonRepository>().fetchStudents(lesson),
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
                  SizedBox(width: AppConstants.sizedBoxWidthSmall),
                  Text('Başlangıç: ${_formatDate(lesson.startDate)}'),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  SizedBox(width: AppConstants.sizedBoxWidthSmall),
                  Text('Bitiş: ${_formatDate(lesson.endDate)}'),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.people, size: 16),
                  SizedBox(width: AppConstants.sizedBoxWidthSmall),
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
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Tarih yok';
    return DateFormat('dd MMM yyyy, hh:mm', 'tr').format(date);
  }

  void _showStudentsBottomSheet(
      BuildContext context, List<UserModel> students) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Öğrenci Sayısı: ${students.length}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              SizedBox(height: AppConstants.sizedBoxHeightSmall),
              students.isEmpty
                  ? const Text(
                      'Bu ders için henüz kayıtlı öğrenci bulunmamaktadır.')
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            radius: AppConstants.screenWidth * 0.05,
                            backgroundImage: students[index].profilePhotoUrl !=
                                    null
                                ? NetworkImage(students[index].profilePhotoUrl!)
                                : const AssetImage(
                                        'assets/images/profile_photo.png')
                                    as ImageProvider,
                          ),
                          title: Text(
                              '${index + 1}. ${students[index].firstName} ${students[index].lastName}'),
                        );
                      },
                    ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToLessonPage(LessonModel lesson) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => TeacherLiveLessonPage(lesson: lesson)))
        .then((_) {
      _loadLessons(); // geri dönüldüğünde kursların tekrar listelenmesi için
    });
  }
}
