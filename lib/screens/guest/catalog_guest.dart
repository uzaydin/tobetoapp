import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tobetoapp/screens/lessons_category_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class CatalogGuest extends StatefulWidget {
  const CatalogGuest({super.key});

  @override
  State<CatalogGuest> createState() => _CatalogGuestState();
}

class _CatalogGuestState extends State<CatalogGuest> {
  @override
  Widget build(BuildContext context) {
    return const LessonsCategoryScreen();
  }
}