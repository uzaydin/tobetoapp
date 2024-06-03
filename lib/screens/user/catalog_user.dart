import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tobetoapp/screens/lessons_category_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class CatalogUser extends StatefulWidget {
  const CatalogUser({super.key});

  @override
  State<CatalogUser> createState() => _CatalogUserState();
}

class _CatalogUserState extends State<CatalogUser> {
  @override
  Widget build(BuildContext context) {
    return const LessonsCategoryScreen();
  }
}
