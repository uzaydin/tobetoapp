import 'package:tobetoapp/models/news_model.dart';

abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoaded extends NewsState {
  final List<News> newsList;
  NewsLoaded(this.newsList);
}

class NewsLoading extends NewsState {}

class NewsError extends NewsState {}
