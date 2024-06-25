import 'package:flutter/material.dart';
import 'package:tobetoapp/screens/blogpage.dart';

class Blog extends StatefulWidget {
  const Blog({super.key});

  @override
  State<Blog> createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  @override
  Widget build(BuildContext context) {
    return const BlogPage();
  }
}
