import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/admin/admin_bloc.dart';
import 'package:tobetoapp/bloc/admin/admin_event.dart';
import 'package:tobetoapp/bloc/admin/admin_state.dart';
import 'package:tobetoapp/models/lesson_model.dart';
import 'package:tobetoapp/screens/admin/lesson_edit.dart';

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
        title: const Text('Lesson Management'),
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
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search by title',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
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
                      return LessonTile(
                        lesson: lesson,
                        onEdit: () =>
                            _navigateToEditLessonPage(context, lesson.id!),
                        onDelete: () =>
                            _showDeleteLessonDialog(context, lesson.id!),
                      );
                    },
                  );
                } else if (state is AdminError) {
                  return Center(
                      child: Text('Failed to load lessons: ${state.message}'));
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
          title: const Text('Add Lesson'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Content'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
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
              child: const Text('Add'),
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
          title: const Text('Delete Lesson'),
          content: const Text('Are you sure you want to delete this lesson?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<AdminBloc>().add(DeleteLesson(lessonId));
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

// Baska sayfaya tasinabilir.
class LessonTile extends StatelessWidget {
  final LessonModel lesson;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const LessonTile({
    super.key,
    required this.lesson,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(lesson.title!),
      subtitle: Text(lesson.description!),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
