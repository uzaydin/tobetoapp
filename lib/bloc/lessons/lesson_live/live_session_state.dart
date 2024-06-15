import 'package:tobetoapp/models/lesson_model.dart';

abstract class LiveSessionState {
  const LiveSessionState();
}

class LiveSessionLoading extends LiveSessionState {}

class LiveSessionLoaded extends LiveSessionState {
  final List<LiveSessionModel> liveSessions;

  const LiveSessionLoaded(this.liveSessions);
}

class LiveSessionFailure extends LiveSessionState {
  final String error;

  const LiveSessionFailure(this.error);
}
