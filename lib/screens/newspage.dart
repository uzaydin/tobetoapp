import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/news/news_bloc.dart';
import 'package:tobetoapp/bloc/news/news_event.dart';
import 'package:tobetoapp/bloc/news/news_state.dart';
import 'package:tobetoapp/models/news_model.dart';
import 'package:tobetoapp/screens/news_detail_screen.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late NewsBloc _newsBloc;

  @override
  void initState() {
    super.initState();
    _newsBloc = BlocProvider.of<NewsBloc>(context);
    _newsBloc.add(FetchNewsId());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basında Biz'),
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is NewsLoaded) {
            return _buildNewsList(state.newsList);
          } else if (state is NewsError) {
            return const Center(
              child: Text('Haberler yüklenirken bir hata oluştu.'),
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

  Widget _buildNewsList(List<News> newsList) {
    return ListView.builder(
      itemCount: newsList.length,
      itemBuilder: (context, index) {
        News news = newsList[index];
        return ListTile(
          leading: Image.network(
            news.imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          title: Text(news.title),
          subtitle: Text(news.publishedDate.toString()),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsDetailPage(news: news),
              ),
            );
          },
        );
      },
    );
  }
}

