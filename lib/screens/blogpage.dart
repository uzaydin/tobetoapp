import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tobetoapp/models/news_model.dart';
import 'package:tobetoapp/screens/blog_detail_screen.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('blog').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              News blog = News(
                id: document['id'],
                title: document['title'],
                publishedDate: document['publishedDate'],
                description: document['description'],
                imageUrl: document['imageUrl'],
              );
              return ListTile(
                title: Text(blog.title),
                subtitle: Text(blog.publishedDate.toString()),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlogDetailPage(blog: blog),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

