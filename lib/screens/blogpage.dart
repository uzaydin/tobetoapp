import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/blog/blog_bloc.dart';
import 'package:tobetoapp/bloc/blog/blog_event.dart';
import 'package:tobetoapp/bloc/blog/blog_state.dart';
import 'package:tobetoapp/models/blog_model.dart';
import 'package:tobetoapp/screens/blog_detail_page.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
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
        return Card(
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlogDetailPage(blog: blog),
                ),
              );
            },
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
                  child: Image.network(
                    blog.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        blog.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.headlineMedium?.color,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        blog.publishedDate.toString(),
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headlineLarge?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
