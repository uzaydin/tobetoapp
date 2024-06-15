import 'package:tobetoapp/bloc/profile/profile_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_event.dart';
import 'package:tobetoapp/bloc/profile/profile_state.dart';
import 'package:tobetoapp/models/userModel.dart';
import 'package:tobetoapp/widgets/user/form_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditCommunitiesPage extends StatefulWidget {
  final UserModel user;

  EditCommunitiesPage({required this.user});

  @override
  _EditCommunitiesPageState createState() => _EditCommunitiesPageState();
}

class _EditCommunitiesPageState extends State<EditCommunitiesPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _communityNameController;
  late TextEditingController _positionController;

  @override
  void initState() {
    super.initState();
    _communityNameController = TextEditingController();
    _positionController = TextEditingController();
  }

  void _clearFields() {
    _communityNameController.clear();
    _positionController.clear();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final community = Community(
        communityName: _communityNameController.text,
        position: _positionController.text,
      );
      final updatedUser = widget.user.copyWith(
        communities: [...widget.user.communities ?? [], community],
      );
      context.read<ProfileBloc>().add(UpdateUserProfile(updatedUser));
      _clearFields();
    }
  }

  void _deleteCommunity(String communityId) {
    final updatedUser = widget.user.copyWith(
      communities:
          widget.user.communities?.where((c) => c.id != communityId).toList(),
    );
    context.read<ProfileBloc>().add(UpdateUserProfile(updatedUser));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Üye Topluluklar Düzenle'),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Topluluklar başarıyla güncellendi')),
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
                            controller: _communityNameController,
                            label: 'Kulüp veya Topluluk Adı',
                            isRequired: true,
                          ),
                          SizedBox(height: 16),
                          FormFields.buildTextField(
                            controller: _positionController,
                            label: 'Ünvan veya Görev',
                            isRequired: true,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _submitForm,
                            child: Text('Kaydet'),
                          ),
                          SizedBox(height: 16),
                          Text('Eklenen Topluluklar',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          ...state.user.communities
                                  ?.map((community) => ListTile(
                                        title:
                                            Text(community.communityName ?? ''),
                                        subtitle:
                                            Text(community.position ?? ''),
                                        trailing: IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            _deleteCommunity(community.id);
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
