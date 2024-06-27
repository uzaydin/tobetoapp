import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:tobetoapp/bloc/auth/auth_drawer/drawer_manager.dart';

import 'package:tobetoapp/bloc/lessons/lesson_bloc.dart';
import 'package:tobetoapp/bloc/lessons/lesson_event.dart';
import 'package:tobetoapp/bloc/lessons/lesson_state.dart';
import 'package:tobetoapp/models/lesson_model.dart';
import 'package:tobetoapp/screens/lesson_details_and_video/lesson_details_page.dart';
import 'package:tobetoapp/screens/student_live_lesson_page.dart';
import 'package:tobetoapp/widgets/banner_widget.dart';
import 'package:tobetoapp/widgets/search_bar.dart';

class ClassDetailPage extends StatefulWidget {
  final List<String>? classIds;

  const ClassDetailPage({
    super.key,
    this.classIds,
  });

  @override
  _ClassDetailPageState createState() => _ClassDetailPageState();
}

class _ClassDetailPageState extends State<ClassDetailPage> {
  bool isListView = true;

  final TextEditingController _searchController =
      TextEditingController(); // Arama çubuğu için controller
  List<LessonModel> _filteredLessons = []; // Filtrelenmiş dersler listesi

  @override
  void initState() {
    super.initState();
    if (widget.classIds != null && widget.classIds!.isNotEmpty) {
      context.read<LessonBloc>().add(LoadLessons(widget.classIds));
    }
    initializeDateFormatting();
    _searchController
        .addListener(_filterLessons); // Arama çubuğu dinleyici ekleniyor
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterLessons); // Dinleyici kaldırılıyor
    _searchController.dispose();
    super.dispose();
  }

  void _filterLessons() {
    final query = _searchController.text
        .toLowerCase(); // Arama çubuğundaki metin küçük harfe dönüştürülüyor
    final state = context.read<LessonBloc>().state;
    if (state is LessonsLoaded) {
      setState(() {
        _filteredLessons = state.lessons.where((lesson) {
          final title = lesson.title!.toLowerCase();
          return title.contains(
              query); // Ders başlığı arama sorgusunu içeriyorsa true döner
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tobeto"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isListView ? Icons.grid_view : Icons.list),
            onPressed: () {
              setState(() {
                isListView =
                    !isListView; // Liste ve Grid görünümü arasında geçiş yapılır
              });
            },
          ),
        ],
      ),
      drawer: const DrawerManager(),
      body: Column(
        children: [
          // Banner
          const BannerWidget(
            imagePath: 'assets/logo/general_banner.png',
            text: 'Eğitimlerim',
          ),
          // Arama Çubuğu
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchBarWidget(
                controller: _searchController,
                hintText: "Ders arayın...",
              )),
          Expanded(
            child: _buildBody(), // Body bölümü
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (widget.classIds == null || widget.classIds!.isEmpty) {
      return const Center(
        child: Text("Henüz ders tanımlanmamıştır."),
      );
    }

    return BlocBuilder<LessonBloc, LessonState>(
      builder: (context, state) {
        if (state is LessonsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LessonsLoaded) {
          final lessonsToShow = _searchController.text.isEmpty
              ? state.lessons
              : _filteredLessons; // Arama çubuğunda metin varsa filtrelenmiş dersler gösterilir
          if (lessonsToShow.isEmpty) {
            return const Center(child: Text("Henüz ders tanımlanmamıştır"));
          } else {
            return isListView
                ? ListView.builder(
                    itemCount: lessonsToShow.length,
                    itemBuilder: (context, index) {
                      return _buildLessonItem(lessonsToShow[index]);
                    },
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: lessonsToShow.length,
                    itemBuilder: (context, index) {
                      return _buildLessonCard(lessonsToShow[index]);
                    },
                  );
          }
        } else if (state is LessonOperationFailure) {
          return Center(
              child: Text("Ders yükleme başarısız oldu! ${state.error}"));
        } else {
          return const Center(child: Text("Bilinmeyen bir hata oluştu."));
        }
      },
    );
  }

  Widget _buildLessonItem(LessonModel lesson) {
    return ListTile(
      leading: lesson.image != null
          ? Image.network(
              lesson.image!,
              fit: BoxFit.fill,
              width: 120,
              height: double.infinity,
            )
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
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            lesson.image != null
                ? Image.network(
                    lesson.image!,
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: 100,
                  )
                : Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.grey,
                    child: const Icon(Icons.image, size: 30),
                  ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                lesson.title ?? "No title",
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                _formatDate(lesson.startDate),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _navigateToLessonPage(LessonModel lesson) {
    if (lesson.isLive ?? false) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => StudentLiveLessonPage(lesson: lesson),
        ),
      );
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
