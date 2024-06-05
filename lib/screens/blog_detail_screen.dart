import 'package:flutter/material.dart';
import 'package:tobetoapp/models/news_model.dart';

class BlogDetailPage extends StatelessWidget {
  final News blog;

  const BlogDetailPage({super.key, required this.blog});

  @override
 Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text(blog.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              blog.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Yayınlanma Tarihi: ${blog.publishedDate}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              blog.description,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
  ),
  );
 }
}
