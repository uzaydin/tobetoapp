import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter/material.dart';

Future<void> sendDataToFirestore({
  required BuildContext context,
  required String nameSurname,
  required String email,
  required String message,
  required TextEditingController adSoyadController,
  required TextEditingController emailController,
  required TextEditingController mesajController,
}) async {
  try {
    await FirebaseFirestore.instance.collection("contact").add({
      "adSoyad": nameSurname,
      "email": email,
      "mesaj": message,
      "timestamp": FieldValue.serverTimestamp(),
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Mesajınız başarıyla gönderildi."),
    ));
    adSoyadController.clear();
    emailController.clear();
    mesajController.clear();
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Veri gönderme hatası: $error'),
    ));
  }
}

void submitForm({
  required GlobalKey<FormState> formKey,
  required BuildContext context,
  required TextEditingController nameSurnameController,
  required TextEditingController emailController,
  required TextEditingController messageController,
}) {
  if (formKey.currentState!.validate()) {
    formKey.currentState!.save();
    sendDataToFirestore(
      context: context,
      nameSurname: nameSurnameController.text,
      email: emailController.text,
      message: messageController.text,
      adSoyadController: nameSurnameController,
      emailController: emailController,
      mesajController: messageController,
    );
  }
}

Future<void> launchURL() async {
  const String url = "https://tobeto.com/yasal-metinler/kvkk-aydinlatma-metni";
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    throw "Web sayfasını açamadı: $url";
  }
}
