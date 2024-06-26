import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/admin/admin_bloc.dart';
import 'package:tobetoapp/bloc/admin/admin_event.dart';
import 'package:tobetoapp/bloc/admin/admin_state.dart';
import 'package:tobetoapp/models/lesson_model.dart';
import 'package:tobetoapp/screens/admin/lesson_edit.dart';
import 'package:tobetoapp/widgets/admin/lesson_tile.dart';
import 'package:tobetoapp/widgets/search_bar.dart';

class LessonManagementPage extends StatefulWidget {
  const LessonManagementPage({super.key});

  @override
  _LessonManagementPageState createState() => _LessonManagementPageState();
}

class _LessonManagementPageState extends State<LessonManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  List<LessonModel> _filteredLessons = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(LoadLessons());
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final searchQuery = _searchController.text.toLowerCase();
    final adminBlocState = context.read<AdminBloc>().state;
    if (adminBlocState is LessonsLoaded) {
      setState(() {
        _filteredLessons = adminBlocState.lessons.where((lesson) {
          final title = lesson.title?.toLowerCase() ?? '';
          return title.contains(searchQuery);
        }).toList();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ders Yönetimi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
              });
            },
          ),
        ],
        bottom: _isSearching
            ? PreferredSize(
                preferredSize: const Size.fromHeight(56.0),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SearchBarWidget(
                      controller: _searchController,
                      hintText: 'Ders başlığı giriniz',
                    )),
              )
            : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<AdminBloc, AdminState>(
              builder: (context, state) {
                if (state is AdminLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is LessonsLoaded) {
                  final lessonsToDisplay = _searchController.text.isEmpty
                      ? state.lessons
                      : _filteredLessons;

                  return ListView.builder(
                    itemCount: lessonsToDisplay.length,
                    itemBuilder: (context, index) {
                      final lesson = lessonsToDisplay[index];
                      return Column(
                        children: [
                          LessonTile(
                            lesson: lesson,
                            onEdit: () =>
                                _navigateToEditLessonPage(context, lesson.id!),
                            onDelete: () =>
                                _showDeleteLessonDialog(context, lesson.id!),
                          ),
                          const Divider(
                            thickness: 1, // Çizginin kalınlığı
                            color: Colors.grey, // Çizginin rengi
                          ),
                        ],
                      );
                    },
                  );
                } else if (state is AdminError) {
                  return const Center(
                      child: Text(
                          'Dersler yüklenirken bir hata olustu. Lütfen tekrar deneyiniz.'));
                } else {
                  return const Center(child: Text('No lessons found'));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddLessonDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToEditLessonPage(BuildContext context, String lessonId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
            value: context.read<AdminBloc>(),
            child: PopScope(
              onPopInvoked: (popped) {
                if (popped) {
                  context.read<AdminBloc>().add(LoadLessons());
                }
              },
              child: LessonEditPage(lessonId: lessonId),
            )),
      ),
    );
  }

  void _showAddLessonDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ders ekle'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Başlık'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'İçerik'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                final newLesson = LessonModel(
                  id: '',
                  title: titleController.text,
                  description: descriptionController.text,
                );
                context.read<AdminBloc>().add(AddLesson(newLesson));
                Navigator.pop(context);
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteLessonDialog(BuildContext context, String lessonId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ders sil'),
          content: const Text('Bu dersi silmek istediğinize emin misiniz ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                context.read<AdminBloc>().add(DeleteLesson(lessonId));
                Navigator.pop(context);
              },
              child: const Text('Sil'),
            ),
          ],
        );
      },
    );
  }
}
