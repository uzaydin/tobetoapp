abstract class UserEvent {}

class FetchUser extends UserEvent {
  final String userId;

  FetchUser(this.userId);
}