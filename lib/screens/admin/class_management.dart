import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/admin/admin_bloc.dart';
import 'package:tobetoapp/bloc/admin/admin_event.dart';
import 'package:tobetoapp/bloc/admin/admin_state.dart';
import 'package:tobetoapp/models/class_model.dart';
import 'package:tobetoapp/screens/admin/class_detail.dart';

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
        title: const Text('Class Management'),
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
                      hintText: 'Search by class name',
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
                } else if (state is ClassesLoaded) {
                  final classesToDisplay = _searchController.text.isEmpty
                      ? state.classes
                      : _filteredClasses;

                  return ListView.builder(
                    itemCount: classesToDisplay.length,
                    itemBuilder: (context, index) {
                      final classModel = classesToDisplay[index];
                      return ListTile(
                        title: Text(classModel.name!),
                        onTap: () =>
                            _navigateToClassDetails(context, classModel.id!),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () =>
                              _showEditClassDialog(context, classModel),
                        ),
                        onLongPress: () =>
                            _showDeleteClassDialog(context, classModel.id!),
                      );
                    },
                  );
                } else if (state is AdminError) {
                  return Center(
                      child: Text('Failed to load classes: ${state.message}'));
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
          child: PopScope(
            onPopInvoked: (popped) {
              if (popped) {
                context.read<AdminBloc>().add(LoadClasses());
              }
            },
            child: ClassDetailsPage(classId: classId),
          ),
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
          title: const Text('Add Class'),
          content: TextField(
            controller: classNameController,
            decoration: const InputDecoration(hintText: 'Class Name'),
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
                final newClass = ClassModel(name: classNameController.text);
                Navigator.pop(context);
                if (mounted) {
                  context.read<AdminBloc>().add(AddClass(newClass));
                }
              },
              child: const Text('Add'),
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
          title: const Text('Edit Class'),
          content: TextField(
            controller: classNameController,
            decoration: const InputDecoration(hintText: 'Class Name'),
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
                final updatedClass =
                    classModel.copyWith(name: classNameController.text);
                Navigator.pop(context);
                if (mounted) {
                  context.read<AdminBloc>().add(UpdateClass(updatedClass));
                }
              },
              child: const Text('Update'),
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
          title: const Text('Delete Class'),
          content: const Text('Are you sure you want to delete this class?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (mounted) {
                  context.read<AdminBloc>().add(DeleteClass(classId));
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}