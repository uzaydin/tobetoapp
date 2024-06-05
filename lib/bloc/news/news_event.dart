abstract class NewsEvent {}

class FetchNewsId extends NewsEvent {
  final String? newsId;

  FetchNewsId({this.newsId});
}

class ResetDetailEvent extends NewsEvent {}

class DeleteDetailEvent extends NewsEvent {
  final String newsId;

  DeleteDetailEvent({required this.newsId});
}
