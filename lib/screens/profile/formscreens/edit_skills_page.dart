import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_event.dart';
import 'package:tobetoapp/bloc/profile/profile_state.dart';
import 'package:tobetoapp/models/user_model.dart';
import 'package:tobetoapp/models/user_enum.dart';

class EditSkillsPage extends StatefulWidget {
  const EditSkillsPage({super.key});

  @override
  _EditSkillsPageState createState() => _EditSkillsPageState();
}

class _EditSkillsPageState extends State<EditSkillsPage> {
  List<UserSkill> _currentSkills = [];
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    final userBloc = context.read<ProfileBloc>();
    userBloc.add(FetchUserDetails());
  }

  void _addSkill(UserSkill skill) {
    setState(() {
      _currentSkills.add(skill);
    });
    if (_currentUser != null) {
      final updatedUser = _currentUser!.copyWith(skills: _currentSkills);
      context.read<ProfileBloc>().add(UpdateUserProfile(updatedUser));
    }
  }

  void _removeSkill(String skillId) {
    setState(() {
      _currentSkills = _currentSkills.where((s) => s.id != skillId).toList();
    });
    if (_currentUser != null) {
      final updatedUser = _currentUser!.copyWith(skills: _currentSkills);
      context.read<ProfileBloc>().add(UpdateUserProfile(updatedUser));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yetkinliklerim Düzenle'),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            setState(() {
              _currentUser = state.user;
              _currentSkills = List<UserSkill>.from(state.user.skills ?? []);
            });
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        const Text(
                          'Yetkinliklerim',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: _currentSkills.map((skill) {
                            return Chip(
                              label: Text(skill.skill?.name ?? ''),
                              backgroundColor: Colors.blue.shade100,
                              deleteIcon:
                                  const Icon(Icons.remove, color: Colors.red),
                              onDeleted: () => _removeSkill(skill.id),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Yetkinlikler',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
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
                              backgroundColor: Colors.green.shade100,
                              deleteIcon:
                                  const Icon(Icons.add, color: Colors.green),
                              onDeleted: () => _addSkill(UserSkill(
                                  id: UniqueKey().toString(), skill: skill)),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileError) {
            return Center(child: Text('An error occurred: ${state.message}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
