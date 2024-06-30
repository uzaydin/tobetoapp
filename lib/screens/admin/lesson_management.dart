import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/admin/admin_bloc.dart';
import 'package:tobetoapp/bloc/admin/admin_event.dart';
import 'package:tobetoapp/bloc/admin/admin_state.dart';
import 'package:tobetoapp/models/lesson_model.dart';
import 'package:tobetoapp/screens/admin/lesson_edit.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';
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

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  void _loadData() {
    context.read<AdminBloc>().add(LoadLessons());
  }

  void _onSearchChanged() {
    final searchQuery = _searchController.text.toLowerCase();
    final adminBlocState = context.read<AdminBloc>().state;

    setState(() {
      if (adminBlocState is LessonsLoaded) {
        _filteredLessons = adminBlocState.lessons.where((lesson) {
          final title = lesson.title?.toLowerCase() ?? '';
          return title.contains(searchQuery);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(AppConstants.paddingSmall),
            child: SearchBarWidget(
              controller: _searchController,
              hintText: 'Ders başlığı giriniz',
            ),
          ),
          Expanded(
            child: BlocBuilder<AdminBloc, AdminState>(
              builder: (context, state) {
                if (state is AdminLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AdminError) {
                  return const Center(
                      child: Text(
                          'Yüklenirken bir hata oluştu. Lütfen tekrar deneyiniz.'));
                } else if (state is LessonsLoaded) {
                  final itemsToDisplay = _searchController.text.isEmpty
                      ? state.lessons
                      : _filteredLessons;

                  return ListView.builder(
                    itemCount: itemsToDisplay.length,
                    itemBuilder: (context, index) {
                      final lesson = itemsToDisplay[index];
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
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return const SizedBox.shrink();
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
          child: LessonEditPage(lessonId: lessonId),
        ),
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
