import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/repository/lessons/lesson_live_repository.dart';
import 'live_session_event.dart';
import 'live_session_state.dart';

class LiveSessionBloc extends Bloc<LiveSessionEvent, LiveSessionState> {
  final LessonLiveRepository lessonLiveRepository;

  LiveSessionBloc(this.lessonLiveRepository) : super(LiveSessionLoading()) {
    on<FetchLiveSessions>(_onFetchLiveSessions);
  }

  Future<void> _onFetchLiveSessions(
      FetchLiveSessions event, Emitter<LiveSessionState> emit) async {
    emit(LiveSessionLoading());
    try {
      final liveSessions =
          await lessonLiveRepository.fetchLiveSessions(event.sessionIds);
      emit(LiveSessionLoaded(liveSessions));
    } catch (e) {
      emit(LiveSessionFailure(e.toString()));
    }
  }
}
