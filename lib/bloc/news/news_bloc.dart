import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/news/news_event.dart';
import 'package:tobetoapp/bloc/news/news_state.dart';
import 'package:tobetoapp/repository/news_repository.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository _newsRepository;

  NewsBloc(
    this._newsRepository,
   ) : super(NewsInitial()) {
    on<FetchNewsId>(_onFetchNewsId);
  }

void _onFetchNewsId(FetchNewsId event, Emitter<NewsState> emit) async {
  emit(NewsLoading());

  try {
    final newsList = await _newsRepository.fetchNews(); 
    emit(NewsLoaded(newsList)); 
  } catch (e) {
    emit(NewsError());
  }
}
}

