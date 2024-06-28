import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tobetoapp/bloc/profile/profile_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_event.dart';
import 'package:tobetoapp/bloc/profile/profile_state.dart';
import 'package:tobetoapp/models/user_model.dart';
import 'package:tobetoapp/models/user_enum.dart';
import 'package:tobetoapp/screens/profile/formscreens/form_helpers.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';

class EditPersonalInfoPage extends StatefulWidget {
  const EditPersonalInfoPage({super.key});

  @override
  _EditPersonalInfoPageState createState() => _EditPersonalInfoPageState();
}

class _EditPersonalInfoPageState extends State<EditPersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _tcNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _githubController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  Gender? _selectedGender;
  MilitaryStatus? _selectedMilitaryStatus;
  DisabilityStatus? _selectedDisabilityStatus;
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    final userBloc = context.read<ProfileBloc>();
    userBloc.add(FetchUserDetails());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kişisel Bilgilerim'),
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            _populateUserDetails(state.user);
            _currentUser = state.user;
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return _buildContent();
          },
        ),
      ),
    );
  }

  void _populateUserDetails(UserModel user) {
    setState(() {
      _firstNameController.text = user.firstName ?? '';
      _lastNameController.text = user.lastName ?? '';
      _phoneNumberController.text = user.phoneNumber ?? '';
      _birthDateController.text = user.birthDate != null
          ? DateFormat('dd/MM/yyyy').format(user.birthDate!)
          : '';
      _tcNoController.text = user.tcNo ?? '';
      _emailController.text = user.email ?? '';
      _githubController.text = user.github ?? '';
      _countryController.text = user.country ?? '';
      _cityController.text = user.city ?? '';
      _districtController.text = user.district ?? '';
      _streetController.text = user.street ?? '';
      _aboutController.text = user.about ?? '';
      _selectedGender = user.gender;
      _selectedMilitaryStatus = user.militaryStatus;
      _selectedDisabilityStatus = user.disabilityStatus;
    });
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        children: <Widget>[
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: AppConstants.profileImageSize,
                  backgroundImage: _currentUser?.profilePhotoUrl != null
                      ? NetworkImage(_currentUser!.profilePhotoUrl!)
                      : const AssetImage('assets/images/profile_photo.png')
                          as ImageProvider,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.black),
                    onPressed: _pickImage,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppConstants.sizedBoxHeightMedium),
          _buildForm(),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: <Widget>[
          buildTextFormField(_firstNameController, 'Adınız', Icons.person),
          buildTextFormField(
              _lastNameController, 'Soyadınız', Icons.person_outline),
          buildTextFormField(
              _phoneNumberController, 'Telefon Numaranız', Icons.phone,
              keyboardType: TextInputType.phone),
          buildDateFormField(
              _birthDateController, 'Doğum Tarihiniz', Icons.calendar_today),
          buildTextFormField(_tcNoController, 'TC Kimlik No', Icons.credit_card,
              keyboardType: TextInputType.number),
          buildTextFormField(_emailController, 'E-posta', Icons.email,
              keyboardType: TextInputType.emailAddress),
          buildDropdown<Gender>(
              'Cinsiyet',
              _selectedGender,
              Gender.values,
              (value) => setState(() => _selectedGender = value),
              (value) => value.name,
              Icons.wc),
          buildDropdown<MilitaryStatus>(
              'Askerlik Durumu',
              _selectedMilitaryStatus,
              MilitaryStatus.values,
              (value) => setState(() => _selectedMilitaryStatus = value),
              (value) => value.name,
              Icons.military_tech),
          buildDropdown<DisabilityStatus>(
              'Engellilik Durumu',
              _selectedDisabilityStatus,
              DisabilityStatus.values,
              (value) => setState(() => _selectedDisabilityStatus = value),
              (value) => value.name,
              Icons.accessible),
          buildTextFormField(_githubController, 'Github Adresi', Icons.code,
              keyboardType: TextInputType.url),
          buildTextFormField(_countryController, 'Ülke', Icons.public),
          buildTextFormField(_cityController, 'İl', Icons.location_city),
          buildTextFormField(_districtController, 'İlçe', Icons.location_on),
          buildTextFormField(
              _streetController, 'Mahalle/Sokak', Icons.streetview,
              isOptional: true),
          buildTextFormField(_aboutController, 'Hakkımda', Icons.info,
              isOptional: true, keyboardType: TextInputType.multiline),
          SizedBox(height: AppConstants.sizedBoxHeightMedium),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.br10),
                ),
                padding:
                    EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
              ),
              child: const Text('Güncelle'),
            ),
          ),
        ],
      ),
    );
  }

  void _pickImage() {
    context.read<ProfileBloc>().add(PickImage());
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      final userBloc = context.read<ProfileBloc>();
      final updatedUser = _currentUser!.copyWith(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phoneNumber: _phoneNumberController.text,
        birthDate: DateFormat('dd/MM/yyyy').parse(_birthDateController.text),
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
      userBloc.add(UpdateUserProfile(updatedUser));
    }
  }
}
