import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/admin/admin_bloc.dart';
import 'package:tobetoapp/bloc/admin/admin_event.dart';
import 'package:tobetoapp/bloc/admin/admin_state.dart';
import 'package:tobetoapp/models/class_model.dart';
import 'package:tobetoapp/screens/admin/class_detail.dart';
import 'package:tobetoapp/widgets/admin/class_tile.dart';
import 'package:tobetoapp/widgets/search_bar.dart';

class ClassManagementPage extends StatefulWidget {
  const ClassManagementPage({super.key});

  @override
  _ClassManagementPageState createState() => _ClassManagementPageState();
}

class _ClassManagementPageState extends State<ClassManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  List<ClassModel> _filteredClasses = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(LoadClasses());
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final searchQuery = _searchController.text.toLowerCase();
    final adminBlocState = context.read<AdminBloc>().state;
    if (adminBlocState is ClassesLoaded) {
      setState(() {
        _filteredClasses = adminBlocState.classes.where((classModel) {
          final className = classModel.name!.toLowerCase();
          return className.contains(searchQuery);
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
        title: const Text('Sınıf Yönetimi'),
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
                  child: SearchBarWidget(controller: _searchController, hintText: "Sınıf ismi giriniz",)
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
                } else if (state is ClassesLoaded) {
                  final classesToDisplay = _searchController.text.isEmpty
                      ? state.classes
                      : _filteredClasses;

                  return ListView.builder(
                    itemCount: classesToDisplay.length,
                    itemBuilder: (context, index) {
                      final classModel = classesToDisplay[index];
                      return ClassTile(
                        classModel: classModel,
                        onDetailsPressed: _navigateToClassDetails,
                        onEditPressed: _showEditClassDialog,
                        onLongPress: _showDeleteClassDialog,
                      );
                    },
                  );
                } else if (state is AdminError) {
                  return const Center(
                      child: Text(
                          'Sınıfları yüklerken bir problem olustu. Lütfen tekrar deneyiniz.'));
                } else {
                  return const Center(child: Text('No classes found'));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddClassDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToClassDetails(BuildContext context, String classId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: context.read<AdminBloc>(),
          child: ClassDetailsPage(classId: classId),
        ),
      ),
    );
  }

  void _showAddClassDialog(BuildContext context) {
    final classNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sınıf ekle'),
          content: TextField(
            controller: classNameController,
            decoration: const InputDecoration(hintText: 'Sınıf ismi'),
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
                final newClass = ClassModel(name: classNameController.text);
                Navigator.pop(context);
                if (mounted) {
                  context.read<AdminBloc>().add(AddClass(newClass));
                }
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }

  void _showEditClassDialog(BuildContext context, ClassModel classModel) {
    final classNameController = TextEditingController(text: classModel.name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sınıf düzenle'),
          content: TextField(
            controller: classNameController,
            decoration: const InputDecoration(hintText: 'Sınıf ismi'),
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
                final updatedClass =
                    classModel.copyWith(name: classNameController.text);
                Navigator.pop(context);
                if (mounted) {
                  context.read<AdminBloc>().add(UpdateClass(updatedClass));
                }
              },
              child: const Text('Güncelle'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteClassDialog(BuildContext context, String classId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sınıf sil'),
          content: const Text('Bu sınıfı silmek istediğinize emin misiniz ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (mounted) {
                  context.read<AdminBloc>().add(DeleteClass(classId));
                }
              },
              child: const Text('Sil'),
            ),
          ],
        );
      },
    );
  }
}