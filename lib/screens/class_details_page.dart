import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:tobetoapp/bloc/lessons/lesson_bloc.dart';
import 'package:tobetoapp/bloc/lessons/lesson_event.dart';
import 'package:tobetoapp/bloc/lessons/lesson_state.dart';
import 'package:tobetoapp/models/lesson_model.dart';
import 'package:tobetoapp/screens/lesson_details_and_video/lesson_details_page.dart';

class ClassDetailPage extends StatefulWidget {
  final List<String>? classIds;

  const ClassDetailPage({
    Key? key,
    this.classIds,
  }) : super(key: key);

  @override
  _ClassDetailPageState createState() => _ClassDetailPageState();
}

class _ClassDetailPageState extends State<ClassDetailPage> {
  bool isListView = true;

  @override
  void initState() {
    super.initState();
    // Derslerin, sınıf id'lerine göre yüklenmesi
    if (widget.classIds != null && widget.classIds!.isNotEmpty) {
      context.read<LessonBloc>().add(LoadLessons(widget.classIds));
    }
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tobeto"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isListView ? Icons.grid_view : Icons.list),
            onPressed: () {
              setState(() {
                isListView = !isListView;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner
          Container(
            width: double.infinity,
            height: 150, // Banner yüksekliği
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/logo/lessons_banner.png', // Banner resmi
                    fit: BoxFit.cover,
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0), 
                    child: Text(
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
          ),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }
  Widget _buildBody() {
    if (widget.classIds == null || widget.classIds!.isEmpty) {
      return Center(
        child: Text("Henüz ders tanımlanmamıştır."),
      );
    }

    return BlocBuilder<LessonBloc, LessonState>(
      builder: (context, state) {
        if (state is LessonsLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is LessonsLoaded) {
          if (state.lessons.isEmpty) {
            return Center(child: Text("Henüz ders tanımlanmamıştır"));
          } else {
            return isListView
                ? ListView.builder(
                    itemCount: state.lessons.length,
                    itemBuilder: (context, index) {
                      return _buildLessonItem(state.lessons[index]);
                    },
                  )
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: state.lessons.length,
                    itemBuilder: (context, index) {
                      return _buildLessonCard(state.lessons[index]);
                    },
                  );
          }
        } else if (state is LessonOperationFailure) {
          return Center(child: Text("Ders yükleme başarısız oldu! ${state.error}"));
        } else {
          return const Center(child: Text("Bilinmeyen bir hata oluştu."));
        }
      },
    );
  }

  Widget _buildLessonItem(LessonModel lesson) {
    return ListTile(
      leading: lesson.image != null
          ? Image.network(lesson.image!)
          : Container(width: 50, height: 50, color: Colors.grey),
      title: Text(lesson.title ?? "No title"),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lesson.description ?? "No description"),
          Text(_formatDate(lesson.startDate)),
        ],
      ),
      onTap: () {
        _navigateToLessonPage(lesson);
      },
    );
  }

  Widget _buildLessonCard(LessonModel lesson) {
    return GestureDetector(
      onTap: () {
        _navigateToLessonPage(lesson);
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            lesson.image != null
                ? Image.network(lesson.image!)
                : Container(height: 100, color: Colors.grey),
            SizedBox(height: 10),
            Text(lesson.title ?? "No title"),
            SizedBox(height: 10),
            Text(_formatDate(lesson.startDate)),
          ],
        ),
      ),
    );
  }

  void _navigateToLessonPage(LessonModel lesson) {
    if (lesson.isLive ?? false) {
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => LiveLessonPage(lesson: lesson),
      //   ),
      // );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LessonDetailsPage(lesson: lesson),
        ),
      );
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Tarih yok';
    return DateFormat('dd MMM yyyy, hh:mm', 'tr').format(date);
  }
}