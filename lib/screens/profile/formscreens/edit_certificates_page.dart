import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tobetoapp/bloc/profile/profile_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_event.dart';
import 'package:tobetoapp/bloc/profile/profile_state.dart';
import 'package:tobetoapp/models/userModel.dart';
import 'package:tobetoapp/screens/profile/formscreens/form_helpers.dart';

class EditCertificatesPage extends StatefulWidget {
  const EditCertificatesPage({super.key});

  @override
  _EditCertificatesPageState createState() => _EditCertificatesPageState();
}

class _EditCertificatesPageState extends State<EditCertificatesPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _certificateNameController =
      TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  File? _selectedFile;

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
        title: const Text('Sertifikalarım'),
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            setState(() {
              _currentUser = state.user;
            });
          } else if (state is CertificatePicked) {
            setState(() {
              _selectedFile = state.file;
            });
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

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          _buildForm(),
          const SizedBox(height: 16.0),
          _buildCertificatesList(),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          buildTextFormField(_certificateNameController, 'Sertifika Adı',
              Icons.card_membership),
          buildDateFormField(
              _dateController, 'Alınan Tarih', Icons.calendar_today),
          _buildFilePicker(),
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveCertificate,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Ekle'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                labelText: _selectedFile != null
                    ? 'Sertifika Yüklendi'
                    : 'Sertifika Yükle *',
                prefixIcon: const Icon(Icons.attach_file),
              ),
              readOnly: true,
              validator: (value) {
                if (_selectedFile == null) {
                  return 'Lütfen bir sertifika yükleyin';
                }
                return null;
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.upload_file,
                color: _selectedFile != null ? Colors.green : null),
            onPressed: _pickFile,
          ),
        ],
      ),
    );
  }

  void _pickFile() {
    context.read<ProfileBloc>().add(PickCertificate());
  }

  Widget _buildCertificatesList() {
    final certificates = _currentUser?.certificates ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Eklenen Sertifikalar',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: certificates.length,
          itemBuilder: (context, index) {
            final certificate = certificates[index];
            return Card(
              color: Colors.purple[50],
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(certificate.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                // ignore: unnecessary_null_comparison
                subtitle: certificate.date != null
                    ? Text(
                        'Tarih: ${DateFormat('dd/MM/yyyy').format(certificate.date)}')
                    : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility, color: Colors.blue),
                      onPressed: () => _viewCertificate(certificate.fileUrl),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteCertificate(
                          certificate.id, certificate.fileUrl),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _saveCertificate() {
    if (_formKey.currentState?.validate() ?? false) {
      final newCertificate = Certificate(
        name: _certificateNameController.text,
        date: DateFormat('dd/MM/yyyy').parse(_dateController.text),
        fileUrl: _selectedFile!.path,
        fileType: _selectedFile!.path.split('.').last,
      );

      final userBloc = context.read<ProfileBloc>();
      userBloc.add(AddCertificate(newCertificate, _selectedFile!));
      _clearForm();
    }
  }

  void _deleteCertificate(String certificateId, String fileUrl) {
    context.read<ProfileBloc>().add(RemoveCertificate(certificateId, fileUrl));
  }

  void _viewCertificate(String url) {
    context.read<ProfileBloc>().add(ViewCertificate(url));
  }

  void _clearForm() {
    _certificateNameController.clear();
    _dateController.clear();
    setState(() {
      _selectedFile = null;
    });
  }
}
