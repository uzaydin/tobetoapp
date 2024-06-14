import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_event.dart';
import 'package:tobetoapp/bloc/profile/profile_state.dart';
import 'package:tobetoapp/models/userModel.dart';
import 'package:tobetoapp/models/user_enum.dart';
import 'package:tobetoapp/widgets/user/form_fields.dart';

class EditEducationPage extends StatefulWidget {
  final UserModel user;

  EditEducationPage({required this.user});

  @override
  _EditEducationPageState createState() => _EditEducationPageState();
}

class _EditEducationPageState extends State<EditEducationPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _degreeController;
  late TextEditingController _universityController;
  late TextEditingController _departmentController;
  late TextEditingController _startDateController;
  late TextEditingController _graduationDateController;
  bool _isStillStudying = false;

  @override
  void initState() {
    super.initState();
    _degreeController = TextEditingController();
    _universityController = TextEditingController();
    _departmentController = TextEditingController();
    _startDateController = TextEditingController();
    _graduationDateController = TextEditingController();
  }

  void _clearFields() {
    _degreeController.clear();
    _universityController.clear();
    _departmentController.clear();
    _startDateController.clear();
    _graduationDateController.clear();
    setState(() {
      _isStillStudying = false;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final education = Education(
        degree: EducationStatusExtension.fromName(_degreeController.text),
        university: _universityController.text,
        department: _departmentController.text,
        startDate: DateTime.parse(_startDateController.text),
        graduationYear:
            !_isStillStudying && _graduationDateController.text.isNotEmpty
                ? DateTime.parse(_graduationDateController.text)
                : null,
      );
      final updatedUser = widget.user.copyWith(
        education: [...widget.user.education ?? [], education],
      );
      context.read<ProfileBloc>().add(UpdateUserProfile(updatedUser));
      _clearFields();
    }
  }

  void _deleteEducation(String educationId) {
    final updatedUser = widget.user.copyWith(
      education:
          widget.user.education?.where((e) => e.id != educationId).toList(),
    );
    context.read<ProfileBloc>().add(UpdateUserProfile(updatedUser));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eğitim Hayatım Düzenle'),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Eğitimler başarıyla güncellendi')),
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
                          FormFields.buildDropdownField<EducationStatus>(
                            value: _degreeController.text.isNotEmpty
                                ? EducationStatusExtension.fromName(
                                    _degreeController.text)
                                : null,
                            label: 'Eğitim Durumu',
                            items: EducationStatus.values,
                            onChanged: (value) {
                              setState(() {
                                _degreeController.text = value!.name;
                              });
                            },
                            itemLabel: (item) => item.name,
                            isRequired: true,
                          ),
                          SizedBox(height: 16),
                          FormFields.buildTextField(
                            controller: _universityController,
                            label: 'Üniversite',
                            isRequired: true,
                          ),
                          SizedBox(height: 16),
                          FormFields.buildTextField(
                            controller: _departmentController,
                            label: 'Bölüm',
                            isRequired: true,
                          ),
                          SizedBox(height: 16),
                          FormFields.buildDateField(
                            controller: _startDateController,
                            label: 'Başlangıç Yılı',
                            isRequired: true,
                            context: context,
                          ),
                          SizedBox(height: 16),
                          FormFields.buildDateField(
                            controller: _graduationDateController,
                            label: 'Mezuniyet Yılı',
                            context: context,
                            isRequired: !_isStillStudying,
                            enabled: !_isStillStudying,
                          ),
                          SizedBox(height: 16),
                          CheckboxListTile(
                            title: Text('Devam Ediyorum'),
                            value: _isStillStudying,
                            onChanged: (bool? value) {
                              setState(() {
                                _isStillStudying = value ?? false;
                                if (_isStillStudying) {
                                  _graduationDateController.clear();
                                }
                              });
                            },
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _submitForm,
                            child: Text('Kaydet'),
                          ),
                          SizedBox(height: 16),
                          Text('Eklenen Eğitimler',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          ...state.user.education
                                  ?.map((education) => ListTile(
                                        title: Text(education.university ?? ''),
                                        subtitle:
                                            Text(education.department ?? ''),
                                        trailing: IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            _deleteEducation(education.id);
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
