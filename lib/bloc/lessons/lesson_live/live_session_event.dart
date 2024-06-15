abstract class LiveSessionEvent {
  const LiveSessionEvent();
}

class FetchLiveSessions extends LiveSessionEvent {
  final List<String> sessionIds;

  const FetchLiveSessions(this.sessionIds);
}
