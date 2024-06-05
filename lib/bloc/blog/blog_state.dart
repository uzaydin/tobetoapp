import 'package:tobetoapp/models/news_model.dart';

abstract class BlogState {}

class BlogInitial extends BlogState {}

class BlogLoaded extends BlogState {
  final List<News> blogList;
  BlogLoaded(this.blogList);
}

class BlogLoading extends BlogState {}

class BlogError extends BlogState {}
