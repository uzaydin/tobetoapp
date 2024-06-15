import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_event.dart';
import 'package:tobetoapp/bloc/profile/profile_state.dart';
import 'package:tobetoapp/models/userModel.dart';
import 'package:tobetoapp/widgets/user/form_fields.dart';

class EditProjectsAwardsPage extends StatefulWidget {
  final UserModel user;

  EditProjectsAwardsPage({required this.user});

  @override
  _EditProjectsAwardsPageState createState() => _EditProjectsAwardsPageState();
}

class _EditProjectsAwardsPageState extends State<EditProjectsAwardsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _projectAwardNameController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _projectAwardNameController = TextEditingController();
    _dateController = TextEditingController();
  }

  void _clearFields() {
    _projectAwardNameController.clear();
    _dateController.clear();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final projectAward = ProjectAwards(
        projectName: _projectAwardNameController.text,
        projectDate: DateTime.parse(_dateController.text),
      );
      final updatedUser = widget.user.copyWith(
        projectsAwards: [...widget.user.projectsAwards ?? [], projectAward],
      );
      context.read<ProfileBloc>().add(UpdateUserProfile(updatedUser));
      _clearFields();
    }
  }

  void _deleteProjectAward(String projectAwardId) {
    final updatedUser = widget.user.copyWith(
      projectsAwards: widget.user.projectsAwards
          ?.where((p) => p.id != projectAwardId)
          .toList(),
    );
    context.read<ProfileBloc>().add(UpdateUserProfile(updatedUser));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projeler ve Ödüller Düzenle'),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Projeler ve ödüller başarıyla güncellendi')),
            );
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Hata: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Expanded(
                      child: ListView(
                        children: [
                          FormFields.buildTextField(
                            controller: _projectAwardNameController,
                            label: 'Proje veya Ödül Adı',
                            isRequired: true,
                          ),
                          SizedBox(height: 16),
                          FormFields.buildDateField(
                            controller: _dateController,
                            label: 'Tarih',
                            context: context,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _submitForm,
                            child: Text('Kaydet'),
                          ),
                          SizedBox(height: 16),
                          Text('Eklenen Projeler ve Ödüller',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          ...state.user.projectsAwards
                                  ?.map((projectAward) => ListTile(
                                        title: Text(
                                            projectAward.projectName ?? ''),
                                        subtitle: Text(projectAward.projectDate
                                                ?.toIso8601String()
                                                .split('T')
                                                .first ??
                                            ''),
                                        trailing: IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            _deleteProjectAward(
                                                projectAward.id);
                                          },
                                        ),
                                      ))
                                  .toList() ??
                              [],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
