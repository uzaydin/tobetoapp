
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/announcements/announcement_bloc.dart';
import 'package:tobetoapp/bloc/announcements/announcement_event.dart';
import 'package:tobetoapp/bloc/auth/auth_bloc.dart';
import 'package:tobetoapp/bloc/auth/auth_state.dart';
import 'package:tobetoapp/bloc/class/class_bloc.dart';
import 'package:tobetoapp/bloc/class/class_event.dart';
import 'package:tobetoapp/bloc/class/class_state.dart';
import 'package:tobetoapp/models/announcement_model.dart';
import 'package:tobetoapp/models/class_model.dart';



class AddAnnouncementPage extends StatefulWidget {
  const AddAnnouncementPage({super.key});

  @override
  _AddAnnouncementPageState createState() => _AddAnnouncementPageState();
}

class _AddAnnouncementPageState extends State<AddAnnouncementPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<ClassModel> _selectedClasses = [];

  @override
  void initState() {
    super.initState();
    context.read<ClassBloc>().add(LoadClasses()); // Dinamik sınıf yükleme için ClassBloc kullanımı
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Announcement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<ClassBloc, ClassState>(
                builder: (context, state) {
                  if (state is ClassLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ClassesLoaded) {
                    return ListView.builder(
                      itemCount: state.classes.length,
                      itemBuilder: (context, index) {
                        final classModel = state.classes[index];
                        return CheckboxListTile(
                          title: Text(classModel.name ?? ''),
                          value: _selectedClasses.contains(classModel),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedClasses.add(classModel);
                              } else {
                                _selectedClasses.remove(classModel);
                              }
                            });
                          },
                        );
                      },
                    );
                  } else if (state is ClassOperationFailure) {
                    return Center(child: Text('Failed to load classes: ${state.error}'));
                  } else {
                    return const Center(child: Text('No classes available.'));
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: _addAnnouncement,
              child: const Text('Add Announcement'),
            ),
          ],
        ),
      ),
    );
  }

  void _addAnnouncement() {
    final userRole = context.read<AuthBloc>().state is AuthSuccess
        ? (context.read<AuthBloc>().state as AuthSuccess).role
        : null;

    final announcement = Announcements(
      title: _titleController.text,
      content: _contentController.text,
      createdAt: DateTime.now(),
      classIds: _selectedClasses.map((classModel) => classModel.id!).toList(),
      role: userRole?.toString().split('.').last,
    );

    context.read<AnnouncementBloc>().add(AddAnnouncement(announcement));
    Navigator.pop(context);
  }
}
