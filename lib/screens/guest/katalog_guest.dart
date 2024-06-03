import 'package:flutter/material.dart';
import 'package:tobetoapp/screens/lessons_category_screen.dart';

class Katalog extends StatefulWidget {
  const Katalog({super.key});

  @override
  State<Katalog> createState() => _KatalogState();
}

class _KatalogState extends State<Katalog> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LessonsCategoryScreen(),
    );
  }
}
