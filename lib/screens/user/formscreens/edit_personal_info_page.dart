import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_event.dart';
import 'package:tobetoapp/bloc/profile/profile_state.dart';
import 'package:tobetoapp/models/userModel.dart';
import 'package:tobetoapp/models/user_enum.dart';
import 'package:tobetoapp/widgets/user/form_fields.dart';

class EditPersonalInfoPage extends StatefulWidget {
  final UserModel user;

  EditPersonalInfoPage({required this.user});

  @override
  _EditPersonalInfoPageState createState() => _EditPersonalInfoPageState();
}

class _EditPersonalInfoPageState extends State<EditPersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _birthDateController;
  late TextEditingController _tcNoController;
  late TextEditingController _emailController;
  Gender? _selectedGender;
  MilitaryStatus? _selectedMilitaryStatus;
  DisabilityStatus? _selectedDisabilityStatus;
  late TextEditingController _githubController;
  late TextEditingController _countryController;
  late TextEditingController _cityController;
  late TextEditingController _districtController;
  late TextEditingController _streetController;
  late TextEditingController _aboutController;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _phoneNumberController =
        TextEditingController(text: widget.user.phoneNumber);
    _birthDateController =
        TextEditingController(text: widget.user.birthDate?.toIso8601String());
    _tcNoController = TextEditingController(text: widget.user.tcNo);
    _emailController = TextEditingController(text: widget.user.email);
    _selectedGender = widget.user.gender;
    _selectedMilitaryStatus = widget.user.militaryStatus;
    _selectedDisabilityStatus = widget.user.disabilityStatus;
    _githubController = TextEditingController(text: widget.user.github);
    _countryController = TextEditingController(text: widget.user.country);
    _cityController = TextEditingController(text: widget.user.city);
    _districtController = TextEditingController(text: widget.user.district);
    _streetController = TextEditingController(text: widget.user.street);
    _aboutController = TextEditingController(text: widget.user.about);
  }

  void _pickImage() {
    context.read<ProfileBloc>().add(PickImage());
  }

  void _updateUserProfile() {
    if (_formKey.currentState!.validate()) {
      final updatedUser = widget.user.copyWith(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phoneNumber: _phoneNumberController.text,
        birthDate: _birthDateController.text.isNotEmpty
            ? DateTime.parse(_birthDateController.text)
            : null,
        tcNo: _tcNoController.text,
        email: _emailController.text,
        gender: _selectedGender,
        militaryStatus: _selectedMilitaryStatus,
        disabilityStatus: _selectedDisabilityStatus,
        github: _githubController.text,
        country: _countryController.text,
        city: _cityController.text,
        district: _districtController.text,
        street: _streetController.text,
        about: _aboutController.text,
      );
      context.read<ProfileBloc>().add(UpdateUserProfile(updatedUser));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kişisel Bilgilerim Düzenle'),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Bilgiler başarıyla güncellendi')),
            );
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Hata: ${state.message}')),
            );
          } else if (state is ProfileImageUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Profil fotoğrafı başarıyla güncellendi')),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoaded || state is ProfileImageUpdated) {
            final user = (state is ProfileLoaded)
                ? state.user
                : (state as ProfileImageUpdated).user;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Stack(
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!)
                                : NetworkImage(user.getProfilePhotoUrl())
                                    as ImageProvider,
                            child: _selectedImage == null &&
                                    user.profilePhotoUrl == null
                                ? Icon(Icons.person, size: 50)
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.camera_alt, color: Colors.black),
                            onPressed: _pickImage,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    FormFields.buildTextField(
                      controller: _firstNameController,
                      label: 'Adınız',
                      isRequired: true,
                    ),
                    SizedBox(height: 16),
                    FormFields.buildTextField(
                      controller: _lastNameController,
                      label: 'Soyadınız',
                      isRequired: true,
                    ),
                    SizedBox(height: 16),
                    FormFields.buildTextField(
                      controller: _phoneNumberController,
                      label: 'Telefon Numaranız',
                      keyboardType: TextInputType.phone,
                      isRequired: true,
                    ),
                    SizedBox(height: 16),
                    FormFields.buildDateField(
                      controller: _birthDateController,
                      label: 'Doğum Tarihiniz',
                      context: context,
                      isRequired: true,
                    ),
                    SizedBox(height: 16),
                    FormFields.buildTextField(
                      controller: _tcNoController,
                      label: 'TC Kimlik No',
                      isRequired: true,
                    ),
                    SizedBox(height: 16),
                    FormFields.buildTextField(
                      controller: _emailController,
                      label: 'E-posta',
                      keyboardType: TextInputType.emailAddress,
                      isRequired: true,
                    ),
                    SizedBox(height: 16),
                    FormFields.buildDropdownField<Gender>(
                      value: _selectedGender,
                      label: 'Cinsiyet',
                      items: Gender.values,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                      itemLabel: (item) => item.name,
                      isRequired: true,
                    ),
                    SizedBox(height: 16),
                    FormFields.buildDropdownField<MilitaryStatus>(
                      value: _selectedMilitaryStatus,
                      label: 'Askerlik Durumu',
                      items: MilitaryStatus.values,
                      onChanged: (value) {
                        setState(() {
                          _selectedMilitaryStatus = value;
                        });
                      },
                      itemLabel: (item) => item.name,
                      isRequired: true,
                    ),
                    SizedBox(height: 16),
                    FormFields.buildDropdownField<DisabilityStatus>(
                      value: _selectedDisabilityStatus,
                      label: 'Engellilik Durumu',
                      items: DisabilityStatus.values,
                      onChanged: (value) {
                        setState(() {
                          _selectedDisabilityStatus = value;
                        });
                      },
                      itemLabel: (item) => item.name,
                      isRequired: true,
                    ),
                    SizedBox(height: 16),
                    FormFields.buildTextField(
                      controller: _githubController,
                      label: 'Github Adresi',
                      isRequired: true,
                    ),
                    SizedBox(height: 16),
                    FormFields.buildTextField(
                      controller: _countryController,
                      label: 'Ülke',
                      isRequired: true,
                    ),
                    SizedBox(height: 16),
                    FormFields.buildTextField(
                      controller: _cityController,
                      label: 'İl',
                      isRequired: true,
                    ),
                    SizedBox(height: 16),
                    FormFields.buildTextField(
                      controller: _districtController,
                      label: 'İlçe',
                      isRequired: true,
                    ),
                    SizedBox(height: 16),
                    FormFields.buildTextField(
                      controller: _streetController,
                      label: 'Mahalle/Sokak',
                    ),
                    SizedBox(height: 16),
                    FormFields.buildTextField(
                      controller: _aboutController,
                      label: 'Hakkımda',
                      keyboardType: TextInputType.multiline,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _updateUserProfile,
                      child: Text('Güncelle'),
                    ),
                  ],
                ),
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
