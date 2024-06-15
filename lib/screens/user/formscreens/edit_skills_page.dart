import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_event.dart';
import 'package:tobetoapp/bloc/profile/profile_state.dart';
import 'package:tobetoapp/models/userModel.dart';
import 'package:tobetoapp/models/user_enum.dart';

class EditSkillsPage extends StatefulWidget {
  final UserModel user;

  EditSkillsPage({required this.user});

  @override
  _EditSkillsPageState createState() => _EditSkillsPageState();
}

class _EditSkillsPageState extends State<EditSkillsPage> {
  final _formKey = GlobalKey<FormState>();
  late List<UserSkill> _currentSkills;

  @override
  void initState() {
    super.initState();
    _currentSkills = List<UserSkill>.from(widget.user.skills ?? []);
  }

  void _addSkill(UserSkill skill) {
    setState(() {
      _currentSkills.add(skill);
    });
    final updatedUser = widget.user.copyWith(skills: _currentSkills);
    context.read<ProfileBloc>().add(UpdateUserProfile(updatedUser));
  }

  void _removeSkill(String skillId) {
    setState(() {
      _currentSkills = _currentSkills.where((s) => s.id != skillId).toList();
    });
    final updatedUser = widget.user.copyWith(skills: _currentSkills);
    context.read<ProfileBloc>().add(UpdateUserProfile(updatedUser));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yetkinliklerim Düzenle'),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            setState(() {
              _currentSkills = List<UserSkill>.from(state.user.skills ?? []);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Yetkinlikler başarıyla güncellendi')),
            );
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Hata: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoaded || state is ProfileInitial) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Expanded(
                      child: ListView(
                        children: [
                          Text('Yetkinliklerim',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: _currentSkills.map((skill) {
                              return Chip(
                                label: Text(skill.skill?.name ?? ''),
                                deleteIcon:
                                    Icon(Icons.remove, color: Colors.red),
                                onDeleted: () => _removeSkill(skill.id),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 16),
                          Text('Yetkinlikler',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: Skill.values
                                .where((skill) => !_currentSkills.any(
                                    (selectedSkill) =>
                                        selectedSkill.skill == skill))
                                .map((skill) {
                              return Chip(
                                label: Text(skill.name),
                                deleteIcon:
                                    Icon(Icons.add, color: Colors.green),
                                onDeleted: () => _addSkill(UserSkill(
                                    id: UniqueKey().toString(), skill: skill)),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ProfileLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProfileError) {
            return Center(child: Text('An error occurred: ${state.message}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
