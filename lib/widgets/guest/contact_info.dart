import 'package:flutter/material.dart';

//  iletişim bilgileri

Widget buildContactInfo(String title, String info) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      const SizedBox(height: 5),
      Text(
        info,
        style: const TextStyle(fontSize: 16),
      ),
      const Divider(),
    ],
  );
}

class ContactInfo {
  final String companyName;
  final String companyTitle;
  final String taxOffice;
  final String taxNo;
  final String phone;
  final String email;
  final String address;
  final String ikPhone;
  final String ikEmail;

  ContactInfo(
      {required this.companyName,
      required this.companyTitle,
      required this.taxOffice,
      required this.taxNo,
      required this.phone,
      required this.email,
      required this.address,
      required this.ikPhone,
      required this.ikEmail});
}
