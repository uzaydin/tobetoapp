import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_event.dart';
import 'package:tobetoapp/bloc/profile/profile_state.dart';
import 'package:tobetoapp/models/userModel.dart';
import 'package:tobetoapp/models/user_enum.dart';
import 'package:tobetoapp/widgets/user/form_fields.dart';

class EditLanguagesPage extends StatefulWidget {
  final UserModel user;

  EditLanguagesPage({required this.user});

  @override
  _EditLanguagesPageState createState() => _EditLanguagesPageState();
}

class _EditLanguagesPageState extends State<EditLanguagesPage> {
  final _formKey = GlobalKey<FormState>();
  Language? _selectedLanguage;
  ProficiencyLevel? _selectedProficiencyLevel;

  void _clearFields() {
    _selectedLanguage = null;
    _selectedProficiencyLevel = null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final language = Languages(
        language: _selectedLanguage,
        level: _selectedProficiencyLevel,
      );
      final updatedUser = widget.user.copyWith(
        languages: [...widget.user.languages ?? [], language],
      );
      context.read<ProfileBloc>().add(UpdateUserProfile(updatedUser));
      _clearFields();
    }
  }

  void _deleteLanguage(String languageId) {
    final updatedUser = widget.user.copyWith(
      languages:
          widget.user.languages?.where((l) => l.id != languageId).toList(),
    );
    context.read<ProfileBloc>().add(UpdateUserProfile(updatedUser));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yabancı Dillerim Düzenle'),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Diller başarıyla güncellendi')),
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
                          FormFields.buildDropdownField<Language>(
                            value: _selectedLanguage,
                            label: 'Dil Seç',
                            items: Language.values,
                            onChanged: (value) {
                              setState(() {
                                _selectedLanguage = value;
                              });
                            },
                            itemLabel: (item) => item.name,
                            isRequired: true,
                          ),
                          SizedBox(height: 16),
                          FormFields.buildDropdownField<ProficiencyLevel>(
                            value: _selectedProficiencyLevel,
                            label: 'Seviye Seç',
                            items: ProficiencyLevel.values,
                            onChanged: (value) {
                              setState(() {
                                _selectedProficiencyLevel = value;
                              });
                            },
                            itemLabel: (item) => item.name,
                            isRequired: true,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _submitForm,
                            child: Text('Kaydet'),
                          ),
                          SizedBox(height: 16),
                          Text('Eklenen Diller',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          ...state.user.languages
                                  ?.map((language) => ListTile(
                                        title:
                                            Text(language.language?.name ?? ''),
                                        subtitle:
                                            Text(language.level?.name ?? ''),
                                        trailing: IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            _deleteLanguage(language.id);
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
