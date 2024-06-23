import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/announcements/announcement_bloc.dart';
import 'package:tobetoapp/bloc/announcements/announcement_event.dart';
import 'package:tobetoapp/bloc/auth/auth_bloc.dart';
import 'package:tobetoapp/bloc/auth/auth_state.dart';
import 'package:tobetoapp/bloc/class/class_bloc.dart';
import 'package:tobetoapp/bloc/class/class_event.dart';
import 'package:tobetoapp/bloc/class/class_state.dart';
import 'package:tobetoapp/bloc/user/user_bloc.dart';
import 'package:tobetoapp/bloc/user/user_state.dart';
import 'package:tobetoapp/models/announcement_model.dart';
import 'package:tobetoapp/models/class_model.dart';
import 'package:tobetoapp/models/user_enum.dart';
import 'package:tobetoapp/theme/constants/constants.dart';
import 'package:tobetoapp/widgets/validation_video_controller.dart';

class AddAnnouncementPage extends StatefulWidget {
  const AddAnnouncementPage({super.key});

  @override
  _AddAnnouncementPageState createState() => _AddAnnouncementPageState();
}

class _AddAnnouncementPageState extends State<AddAnnouncementPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<ClassModel> _selectedClasses = [];

  @override
  void initState() {
    super.initState();
    context
        .read<ClassBloc>()
        .add(LoadClasses()); // Dinamik sınıf yükleme için ClassBloc kullanımı
  }

  @override
  Widget build(BuildContext context) {
    // AppConstants'ı başlat
    AppConstants.init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Announcement'),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppConstants.paddingMedium),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.br10),
                    ),
                  ),
                  validator: (value) =>
                      validation(value, "Please enter a title."),
                ),
                SizedBox(height: AppConstants.sizedBoxHeightMedium),
                TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.br10),
                    ),
                  ),
                  validator: (value) =>
                      validation(value, "Please enter content."),
                ),
                SizedBox(height: AppConstants.sizedBoxHeightLarge),
                BlocBuilder<ClassBloc, ClassState>(
                  builder: (context, state) {
                    if (state is ClassLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ClassesLoaded) {
                      final userState = context.read<UserBloc>().state;
                      if (userState is UserLoaded) {
                        final user = userState.user;
                        final userClassIds = user.classIds ?? [];
                        final userRole = user.role;

                        final classesToDisplay = userRole == UserRole.admin
                            ? state.classes
                            : state.classes
                                .where((classModel) =>
                                    userClassIds.contains(classModel.id))
                                .toList();

                        return DropdownSearch<ClassModel>.multiSelection(
                          items: classesToDisplay,
                          itemAsString: (ClassModel u) => u.name ?? '',
                          onChanged: (List<ClassModel> data) {
                            setState(() {
                              _selectedClasses.clear();
                              _selectedClasses.addAll(data);
                            });
                          },
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: "Select Classes",
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(AppConstants.br10),
                              ),
                            ),
                          ),
                          clearButtonProps: ClearButtonProps(
                            isVisible: true,
                          ),
                          selectedItems: _selectedClasses,
                        );
                      } else {
                        return const Center(
                            child: Text('User data not loaded.'));
                      }
                    } else if (state is ClassOperationFailure) {
                      return Center(
                          child:
                              Text('Failed to load classes: ${state.error}'));
                    } else {
                      return const Center(child: Text('No classes available.'));
                    }
                  },
                ),
                SizedBox(height: AppConstants.sizedBoxHeightLarge),
                ElevatedButton(
                  onPressed: _addAnnouncement,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingLarge,
                      vertical: AppConstants.sizedBoxHeightMedium,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.br10),
                    ),
                  ),
                  child: const Text('Add Announcement'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addAnnouncement() {
    if (_formKey.currentState!.validate() && _selectedClasses.isNotEmpty) {
      final announcement = Announcements(
        title: _titleController.text,
        content: _contentController.text,
        createdAt: DateTime.now(),
        classIds: _selectedClasses.map((classModel) => classModel.id!).toList(),
      );

      context.read<AnnouncementBloc>().add(AddAnnouncement(announcement));
      Navigator.pop(context);
    } else {
      if (_selectedClasses.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one class')),
        );
      }
    }
  }

  String? validation(String? value, String message) {
    if (value == null || value.isEmpty) {
      return message;
    }
    return null;
  }
}
