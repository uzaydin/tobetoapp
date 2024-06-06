import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/blog/blog_bloc.dart';
import 'package:tobetoapp/bloc/blog/blog_event.dart';
import 'package:tobetoapp/bloc/blog/blog_state.dart';
import 'package:tobetoapp/models/blog_model.dart';
import 'package:tobetoapp/screens/blog_detail_screen.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  late BlogBloc _blogBloc;

  @override
  void initState() {
    super.initState();
    _blogBloc = BlocProvider.of<BlogBloc>(context);
    _blogBloc.add(FetchBlogsId());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog'),
      ),
      body: BlocBuilder<BlogBloc, BlogState>(
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is BlogLoaded) {
            return _buildBlogList(state.blogList);
          } else if (state is BlogError) {
            return const Center(
              child: Text('Bloglar yüklenirken bir hata oluştu.'),
            );
          } else {
            return const Center(
              child: Text('Başka bir hata oluştu.'),
            );
          }
        },
      ),
    );
  }

  Widget _buildBlogList(List<Blog> blogList) {
    return ListView.builder(
      itemCount: blogList.length,
      itemBuilder: (context, index) {
        Blog blog = blogList[index];
        return ListTile(
          leading: Image.network(
            blog.imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
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
  }
}
