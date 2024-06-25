import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';

import 'package:tobetoapp/utils/theme/constants/constants.dart';
import 'package:tobetoapp/utils/theme/light/light_theme.dart';
import 'package:tobetoapp/widgets/common_app_bar.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  String education = '';
  String educator = '';
  DateTime? date;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? price;
  bool isLoading = false;

  final educationController = TextEditingController();
  final educatorController = TextEditingController();
  final educationFocusNode = FocusNode();
  final educatorFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    educationFocusNode.addListener(() {
      if (educationFocusNode.hasFocus) {
        educationController.text = '';
      }
    });

    educatorFocusNode.addListener(() {
      if (educatorFocusNode.hasFocus) {
        educatorController.text = '';
      }
    });
  }

  @override
  void dispose() {
    educationController.dispose();
    educatorController.dispose();
    educationFocusNode.dispose();
    educatorFocusNode.dispose();
    super.dispose();
  }

  void _addEvent() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        DateTime startDateTime = DateTime(date!.year, date!.month, date!.day,
            startTime!.hour, startTime!.minute);
        DateTime endDateTime = DateTime(
            date!.year, date!.month, date!.day, endTime!.hour, endTime!.minute);

        await FirebaseFirestore.instance.collection('events').add({
          'education': education,
          'educator': educator,
          'date': Timestamp.fromDate(date!),
          'startTime': Timestamp.fromDate(startDateTime),
          'endTime': Timestamp.fromDate(endDateTime),
          'price':
              price != null && price!.isNotEmpty ? double.parse(price!) : null,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Etkinlik başarıyla eklendi!')),
        );

        setState(() {
          _formKey.currentState!.reset();
          education = '';
          educator = '';
          date = null;
          startTime = null;
          endTime = null;
          price = null;

          educationController.clear();
          educatorController.clear();
          educationFocusNode.unfocus();
          educatorFocusNode.unfocus();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Etkinlik eklenirken bir hata oluştu: $e')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _selectDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      setState(() {
        date = selectedDate;
      });
    }
  }

  Future<void> _selectStartTime() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      setState(() {
        startTime = selectedTime;
      });
    }
  }

  Future<void> _selectEndTime() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      setState(() {
        endTime = selectedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      body: Padding(
        padding: EdgeInsets.all(AppConstants.paddingMedium),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Center(
              child: Column(children: [
                OutlineGradientButton(
                  padding: EdgeInsets.all(AppConstants.paddingLarge),
                  strokeWidth: 3,
                  radius: Radius.circular(AppConstants.br16),
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.tobetoMoru,
                      Colors.white30,
                      AppColors.tobetoMoru,
                      Colors.white30
                    ],
                    stops: [0.0, 0.5, 0.5, 1.0],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Etkinlik Ekle",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: AppColors.tobetoMoru),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppConstants.sizedBoxHeightMedium),
                      TextFormField(
                        controller: educationController,
                        focusNode: educationFocusNode,
                        decoration:
                            const InputDecoration(labelText: "Eğitim Adı"),
                        onChanged: (value) {
                          setState(() {
                            education = value;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Eğitim adı gerekli';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppConstants.sizedBoxHeightSmall),
                      TextFormField(
                        controller: educatorController,
                        focusNode: educatorFocusNode,
                        decoration:
                            const InputDecoration(labelText: "Eğitmen Adı"),
                        onChanged: (value) {
                          setState(() {
                            educator = value;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Eğitmen adı gerekli";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppConstants.sizedBoxHeightSmall),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: "Ücret (isteğe bağlı)"),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            price = value;
                          });
                        },
                      ),
                      SizedBox(height: AppConstants.sizedBoxHeightSmall),
                      ElevatedButton(
                        onPressed: _selectDate,
                        child: Text(date == null
                            ? "Tarih Seç"
                            : date!.toLocal().toString().split(' ')[0]),
                      ),
                      SizedBox(height: AppConstants.sizedBoxHeightSmall),
                      ElevatedButton(
                        onPressed: _selectStartTime,
                        child: Text(startTime == null
                            ? 'Başlangıç Saati Seç'
                            : startTime!.format(context)),
                      ),
                      SizedBox(height: AppConstants.sizedBoxHeightSmall),
                      ElevatedButton(
                        onPressed: _selectEndTime,
                        child: Text(endTime == null
                            ? 'Bitiş Saati Seç'
                            : endTime!.format(context)),
                      ),
                      SizedBox(height: AppConstants.sizedBoxHeightSmall),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          fixedSize: const Size(double.infinity, 50),
                        ),
                        onPressed: _addEvent,
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                "Etkinlik Ekle",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
