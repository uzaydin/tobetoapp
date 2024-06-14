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

  TextEditingController _searchController =
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
        title: Text("Tobeto"),
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
      body: Column(
        children: [
          // Banner
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
          // Arama Çubuğu
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller:
                  _searchController, // Arama çubuğu için controller atanıyor
              decoration: InputDecoration(
                hintText: 'Ders arayın...', // Placeholder metni
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: Icon(Icons.search), // Arama ikonu
              ),
            ),
          ),
          Expanded(
            child: _buildBody(), // Body bölümü
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
          final lessonsToShow = _searchController.text.isEmpty
              ? state.lessons
              : _filteredLessons; // Arama çubuğunda metin varsa filtrelenmiş dersler gösterilir
          if (lessonsToShow.isEmpty) {
            return Center(child: Text("Henüz ders tanımlanmamıştır"));
          } else {
            return isListView
                ? ListView.builder(
                    itemCount: lessonsToShow.length,
                    itemBuilder: (context, index) {
                      return _buildLessonItem(lessonsToShow[index]);
                    },
                  )
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
