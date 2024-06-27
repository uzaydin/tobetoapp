import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tobetoapp/bloc/admin/admin_bloc.dart';
import 'package:tobetoapp/bloc/admin/admin_event.dart';
import 'package:tobetoapp/bloc/admin/admin_state.dart';

class CatalogEditPage extends StatefulWidget {
  final String catalogId;

  const CatalogEditPage({required this.catalogId, super.key});

  @override
  _CatalogEditPageState createState() => _CatalogEditPageState();
}

class _CatalogEditPageState extends State<CatalogEditPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _instructorController = TextEditingController();
  final _instructorInfoController = TextEditingController();
  final _categoryController = TextEditingController();
  final _certificationStatusController = TextEditingController();
  final _languageController = TextEditingController();
  final _levelController = TextEditingController();
  final _subjectController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  String? _imageUrl;
  XFile? _imageFile;
  bool _isFree = false;

  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(LoadCatalogDetails(widget.catalogId));
  }

  Future<void> _pickDate(BuildContext context, DateTime? initialDate, Function(DateTime?) onPicked) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        onPicked(picked);
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _instructorController.dispose();
    _instructorInfoController.dispose();
    _categoryController.dispose();
    _certificationStatusController.dispose();
    _languageController.dispose();
    _levelController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eğitim Detayları'),
      ),
      body: BlocConsumer<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state is CatalogImageUploaded) {
            context.read<AdminBloc>().add(LoadCatalogDetails(widget.catalogId));
          } else if (state is AdminError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Resim yüklerken bir hata meydana geldi')),
            );
          }
        },
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CatalogDetailsLoaded) {
            if (_titleController.text.isEmpty) {
              _titleController.text = state.catalog.title ?? '';
            }
            if (_contentController.text.isEmpty) {
              _contentController.text = state.catalog.content ?? '';
            }
            if (_instructorController.text.isEmpty) {
              _instructorController.text = state.catalog.instructor ?? '';
            }
            if (_instructorInfoController.text.isEmpty) {
              _instructorInfoController.text = state.catalog.instructorInfo ?? '';
            }
            if (_categoryController.text.isEmpty) {
              _categoryController.text = state.catalog.category ?? '';
            }
            if (_certificationStatusController.text.isEmpty) {
              _certificationStatusController.text = state.catalog.certificationStatus ?? '';
            }
            if (_languageController.text.isEmpty) {
              _languageController.text = state.catalog.language ?? '';
            }
            if (_levelController.text.isEmpty) {
              _levelController.text = state.catalog.level ?? '';
            }
            if (_subjectController.text.isEmpty) {
              _subjectController.text = state.catalog.subject ?? '';
            }
            _startDate ??= state.catalog.startDate;
            _endDate ??= state.catalog.endDate;
            _imageUrl ??= state.catalog.imageUrl;
            _isFree = state.catalog.isFree ?? false;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _imageFile != null
                        ? Image.file(
                            File(_imageFile!.path),
                            height: 150,
                          )
                        : _imageUrl != null
                            ? Image.network(
                                _imageUrl!,
                                height: 150,
                              )
                            : const SizedBox.shrink(),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Resim seç'),
                    ),
                    if (_imageFile != null)
                      ElevatedButton(
                        onPressed: () {
                          if (_imageFile != null) {
                            context.read<AdminBloc>().add(UploadCatalogImage(
                                  catalogId: widget.catalogId,
                                  imageFile: _imageFile!,
                                ));
                          }
                        },
                        child: const Text('Resmi yükle'),
                      ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Başlık',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        labelText: 'İçerik',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _instructorController,
                      decoration: const InputDecoration(
                        labelText: 'Eğitmen',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _instructorInfoController,
                      decoration: const InputDecoration(
                        labelText: 'Eğitmen Bilgisi',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _certificationStatusController,
                      decoration: const InputDecoration(
                        labelText: 'Sertifika Durumu',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _languageController,
                      decoration: const InputDecoration(
                        labelText: 'Dil',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _levelController,
                      decoration: const InputDecoration(
                        labelText: 'Seviye',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _subjectController,
                      decoration: const InputDecoration(
                        labelText: 'Konu',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      title: const Text('Ücretsiz Eğitim'),
                      value: _isFree,
                      onChanged: (bool value) {
                        setState(() {
                          _isFree = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      title: const Text('Başlangıç tarihi'),
                      subtitle: Text(_formatDate(_startDate)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _pickDate(context, _startDate, (date) {
                        setState(() {
                          _startDate = date;
                        });
                      }),
                    ),
                    ListTile(
                      title: const Text('Bitiş tarihi'),
                      subtitle: Text(_formatDate(_endDate)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _pickDate(context, _endDate, (date) {
                        setState(() {
                          _endDate = date;
                        });
                      }),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        final updatedCatalog = state.catalog.copyWith(
                          title: _titleController.text,
                          content: _contentController.text,
                          startDate: _startDate,
                          endDate: _endDate,
                          imageUrl: _imageUrl,
                          isFree: _isFree,
                          instructor: _instructorController.text,
                          instructorInfo: _instructorInfoController.text,
                          category: _categoryController.text,
                          certificationStatus: _certificationStatusController.text,
                          language: _languageController.text,
                          level: _levelController.text,
                          subject: _subjectController.text,
                        );
                        context.read<AdminBloc>().add(UpdateCatalog(updatedCatalog));
                        Navigator.pop(context);
                      },
                      child: const Text('Kaydet'),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is AdminError) {
            return const Center(child: Text('Yüklerken bir hata meydana geldi. Lütfen tekrar deneyiniz'));
          } else {
            return const Center(child: Text('No details found'));
          }
        },
      ),
    );
  }
}
