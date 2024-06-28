import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:tobetoapp/bloc/auth/auth_drawer/drawer_manager.dart';

import 'package:tobetoapp/bloc/lessons/lesson_bloc.dart';
import 'package:tobetoapp/bloc/lessons/lesson_event.dart';
import 'package:tobetoapp/bloc/lessons/lesson_state.dart';
import 'package:tobetoapp/models/lesson_model.dart';
import 'package:tobetoapp/screens/catalog/catalog_page.dart';
import 'package:tobetoapp/screens/lesson_details_and_video/lesson_details_page.dart';
import 'package:tobetoapp/screens/student_live_lesson_page.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';
import 'package:tobetoapp/widgets/banner_widget.dart';
import 'package:tobetoapp/widgets/lesson_card.dart';
import 'package:tobetoapp/widgets/lesson_item.dart';
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
    _searchController.addListener(_filterLessons);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterLessons);
    _searchController.dispose();
    super.dispose();
  }

  void _filterLessons() {
    final query = _searchController.text.toLowerCase();
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
        title: Image.asset(
          "assets/logo/tobetologo.PNG",
          width: AppConstants.screenWidth * 0.43,
        ),
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
        centerTitle: true,
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
      return _buildEmptyState();
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
                      return LessonItem(lesson: lessonsToShow[index]);
                    },
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: lessonsToShow.length,
                    itemBuilder: (context, index) {
                      return LessonCard(lesson: lessonsToShow[index]);
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.info_outline,
              size: 100,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 20),
            const Text(
              "Henüz ders tanımlanmamıştır.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Ancak kataloğumuza göz atabilirsin!",
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CatalogPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "Kataloga git",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
