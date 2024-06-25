import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/calendar_bloc/calendar.state.dart';
import 'package:tobetoapp/bloc/calendar_bloc/calendar_event.dart';
import 'package:tobetoapp/models/event_model.dart';
import 'package:tobetoapp/services/event_service.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final EventService eventService;
  List<Event> _allEvents = [];

  String _searchQuery = "";
  String _selectedEducator = "";
  List<String> _selectedStatuses = [];
  List<String> _educationSuggestions = [];

  CalendarBloc(this.eventService) : super(EventInitial()) {
    on<FetchEvents>(_onFetchEvents);
    on<UpdateFilters>(_onUpdateFilters);
    on<SearchEducations>(_onSearchEducations);
  }

  void _onFetchEvents(FetchEvents event, Emitter<CalendarState> emit) async {
    emit(EventLoading());

    await emit.forEach<List<Event>>(
      eventService.streamEvents(),
      onData: (events) {
        _allEvents = events;
        final groupedEvents = _groupAndFilterEvents();
        return EventLoaded(groupedEvents);
      },
      onError: (error, stackTrace) => EventError(error.toString()),
    );
  }

  void _onUpdateFilters(UpdateFilters event, Emitter<CalendarState> emit) {
    _searchQuery = event.searchQuery;
    _selectedEducator = event.selectedEducator;
    _selectedStatuses = event.selectedStatuses;

    final groupedEvents = _groupAndFilterEvents();
    emit(EventLoaded(groupedEvents));
  }

  void _onSearchEducations(
      SearchEducations event, Emitter<CalendarState> emit) {
    _educationSuggestions = _allEvents
        .where((e) =>
            e.education.toLowerCase().contains(event.query.toLowerCase()))
        .map((e) => e.education)
        .toSet()
        .toList();
    emit(EventEducationSearchLoaded(_educationSuggestions));
  }

  Map<DateTime, List<Event>> _groupAndFilterEvents() {
    var filteredEvents = _allEvents.where((event) {
      final matchesSearchQuery =
          event.education.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesEducator =
          _selectedEducator.isEmpty || event.educator == _selectedEducator;
      final matchesStatus = _selectedStatuses.isEmpty ||
          _selectedStatuses.any((status) {
            final now = DateTime.now();
            final eventStart = DateTime(event.date.year, event.date.month,
                event.date.day, event.startTime.hour, event.startTime.minute);
            final eventEnd = DateTime(event.date.year, event.date.month,
                event.date.day, event.endTime.hour, event.endTime.minute);
            if (status == 'Bitmiş Dersler') return eventEnd.isBefore(now);
            if (status == 'Devam Eden Dersler') {
              return eventStart.isBefore(now) && eventEnd.isAfter(now);
            }
            if (status == 'Başlamamış Dersler') return eventStart.isAfter(now);
            if (status == 'Satın Alınmış Dersler') {
              return event.price != null && event.price! > 0.0;
            }
            return false;
          });

      return matchesSearchQuery && matchesEducator && matchesStatus;
    }).toList();

    var groupedEvents = groupBy(filteredEvents, (Event event) {
      return DateTime(event.date.year, event.date.month, event.date.day);
    });

    var sportedKeys = groupedEvents.keys.toList()
      ..sort((a, b) => a.compareTo(b));
    var sortedMap = {for (var key in sportedKeys) key: groupedEvents[key]!};
    return sortedMap;
  }
}
