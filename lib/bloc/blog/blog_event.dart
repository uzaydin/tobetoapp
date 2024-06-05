abstract class BlogEvent {}

class FetchBlogsId extends BlogEvent {
  final String? blogId;

  FetchBlogsId({this.blogId});
}

class ResetDetailEvent extends BlogEvent {}

class DeleteDetailEvent extends BlogEvent {
  final String blogId;

  DeleteDetailEvent({required this.blogId});
}