import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_event.dart';
import 'package:tobetoapp/bloc/profile/profile_state.dart';
import 'package:tobetoapp/models/userModel.dart';
import 'package:tobetoapp/models/user_enum.dart';
import 'package:tobetoapp/widgets/user/form_fields.dart';

class EditSocialMediaPage extends StatefulWidget {
  final UserModel user;

  EditSocialMediaPage({required this.user});

  @override
  _EditSocialMediaPageState createState() => _EditSocialMediaPageState();
}

class _EditSocialMediaPageState extends State<EditSocialMediaPage> {
  final _formKey = GlobalKey<FormState>();
  SocialMediaPlatform? _selectedPlatform;
  late TextEditingController _linkController;

  @override
  void initState() {
    super.initState();
    _linkController = TextEditingController();
  }

  void _clearFields() {
    _linkController.clear();
    _selectedPlatform = null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final socialMedia = SocialMedia(
        platform: _selectedPlatform,
        link: _linkController.text,
      );
      final updatedUser = widget.user.copyWith(
        socialMedia: [...widget.user.socialMedia ?? [], socialMedia],
      );
      context.read<ProfileBloc>().add(UpdateUserProfile(updatedUser));
      _clearFields();
    }
  }

  void _deleteSocialMedia(String socialMediaId) {
    final updatedUser = widget.user.copyWith(
      socialMedia: widget.user.socialMedia
          ?.where((sm) => sm.id != socialMediaId)
          .toList(),
    );
    context.read<ProfileBloc>().add(UpdateUserProfile(updatedUser));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medya Hesaplarım Düzenle'),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Medya hesapları başarıyla güncellendi')),
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
                          FormFields.buildDropdownField<SocialMediaPlatform>(
                            value: _selectedPlatform,
                            label: 'Hesap Seç',
                            items: SocialMediaPlatform.values,
                            onChanged: (value) {
                              setState(() {
                                _selectedPlatform = value;
                              });
                            },
                            itemLabel: (item) => item.name,
                            isRequired: true,
                          ),
                          SizedBox(height: 16),
                          FormFields.buildTextField(
                            controller: _linkController,
                            label: 'Link',
                            isRequired: true,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _submitForm,
                            child: Text('Kaydet'),
                          ),
                          SizedBox(height: 16),
                          Text('Eklenen Medya Hesapları',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          ...state.user.socialMedia
                                  ?.map((socialMedia) => ListTile(
                                        title: Text(
                                            socialMedia.platform?.name ?? ''),
                                        subtitle: Text(socialMedia.link ?? ''),
                                        trailing: IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            _deleteSocialMedia(socialMedia.id);
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
