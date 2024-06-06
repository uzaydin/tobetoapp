import 'package:tobetoapp/models/blog_model.dart';

abstract class BlogState {}

class BlogInitial extends BlogState {}

class BlogLoaded extends BlogState {
  final List<Blog> blogList;
  BlogLoaded(this.blogList);
}

class BlogLoading extends BlogState {}

class BlogError extends BlogState {}
