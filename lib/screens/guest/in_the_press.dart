import 'package:flutter/material.dart';
import 'package:tobetoapp/screens/newspage.dart';

class InThePress extends StatefulWidget {
  const InThePress({super.key});

  @override
  State<InThePress> createState() => _InThePressState();
}

class _InThePressState extends State<InThePress> {
  @override
  Widget build(BuildContext context) {
    return const NewsPage();
  }
}
