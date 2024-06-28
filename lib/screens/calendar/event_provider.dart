import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventProvider with ChangeNotifier {
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

  void dispose() {
    educationController.dispose();
    educatorController.dispose();
    educationFocusNode.dispose();
    educatorFocusNode.dispose();
    super.dispose();
  }

  Future<void> addEvent(BuildContext context) async {
    isLoading = true;
    notifyListeners();
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

      resetForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Etkinlik eklenirken bir hata oluştu: $e')),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void resetForm() {
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
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      date = selectedDate;
      notifyListeners();
    }
  }

  Future<void> selectStartTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      startTime = selectedTime;
      notifyListeners();
    }
  }

  Future<void> selectEndTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      endTime = selectedTime;
      notifyListeners();
    }
  }
}
