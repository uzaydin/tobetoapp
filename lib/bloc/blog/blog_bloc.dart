import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/blog/blog_event.dart';
import 'package:tobetoapp/bloc/blog/blog_state.dart';
import 'package:tobetoapp/repository/blog_repository.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final BlogRepository _blogRepository;

  BlogBloc(
    this._blogRepository,
  ) : super(BlogInitial()) {
    on<FetchBlogsId>(_onFetchBlogId);
  }

  void _onFetchBlogId(FetchBlogsId event, Emitter<BlogState> emit) async {
    emit(BlogLoading());

    try {
      final blogList = await _blogRepository.fetchBlogs(); 
      emit(BlogLoaded(blogList)); 
    } catch (e) {
      emit(BlogError());
    }
  }
}

