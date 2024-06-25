import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_event.dart';
import 'package:tobetoapp/bloc/profile/profile_state.dart';
import 'package:tobetoapp/models/userModel.dart';
import 'package:tobetoapp/widgets/user/form_fields.dart';

class EditCertificatesPage extends StatefulWidget {
  final UserModel user;

  const EditCertificatesPage({super.key, required this.user});

  @override
  _EditCertificatesPageState createState() => _EditCertificatesPageState();
}

class _EditCertificatesPageState extends State<EditCertificatesPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _certificateNameController;
  late TextEditingController _dateController;
  File? _selectedFile;
  String? _fileExtension;

  @override
  void initState() {
    super.initState();
    _certificateNameController = TextEditingController();
    _dateController = TextEditingController();
  }

  void _clearFields() {
    _certificateNameController.clear();
    _dateController.clear();
    setState(() {
      _selectedFile = null;
      _fileExtension = null;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sertifika yüklemek zorunludur')),
        );
        return;
      }
      final certificate = Certificate(
        name: _certificateNameController.text,
        date: DateTime.parse(_dateController.text),
        fileUrl: '',
        fileType: _fileExtension!,
      );
      context
          .read<ProfileBloc>()
          .add(AddCertificate(certificate, _selectedFile!));
      _clearFields();
    }
  }

  void _viewCertificate(String url) {
    context.read<ProfileBloc>().add(ViewCertificate(url));
  }

  void _deleteCertificate(String certificateId, String fileUrl) {
    context.read<ProfileBloc>().add(RemoveCertificate(certificateId, fileUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sertifikalarım Düzenle'),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sertifikalar başarıyla güncellendi')),
            );
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Hata: ${state.message}')),
            );
          } else if (state is CertificatePicked) {
            setState(() {
              _selectedFile = state.file;
              _fileExtension = state.extension;
            });
          }
        },
        builder: (context, state) {
          if (state is ProfileLoaded || state is CertificatePicked) {
            final user = state is ProfileLoaded
                ? state.user
                : (state as CertificatePicked).user;
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
                            controller: _certificateNameController,
                            label: 'Sertifika Adı',
                            isRequired: true,
                          ),
                          const SizedBox(height: 16),
                          FormFields.buildDateField(
                            controller: _dateController,
                            label: 'Alınan Tarih',
                            isRequired: true,
                            context: context,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.upload_file),
                            label: Text(_selectedFile != null
                                ? 'Dosya Seçildi'
                                : 'Dosya Yükle'),
                            onPressed: () {
                              context
                                  .read<ProfileBloc>()
                                  .add(PickCertificate());
                            },
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _submitForm,
                            child: const Text('Kaydet'),
                          ),
                          const SizedBox(height: 16),
                          const Text('Eklenen Sertifikalar',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          ...user.certificates
                                  ?.map((certificate) => ListTile(
                                        title: Text(certificate.name),
                                        subtitle: Text(certificate.date
                                            .toIso8601String()
                                            .split('T')
                                            .first),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.visibility,
                                                  color: Colors.blue),
                                              onPressed: () {
                                                _viewCertificate(
                                                    certificate.fileUrl);
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () {
                                                _deleteCertificate(
                                                    certificate.id,
                                                    certificate.fileUrl);
                                              },
                                            ),
                                          ],
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
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
