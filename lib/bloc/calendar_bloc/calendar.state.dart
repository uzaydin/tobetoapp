import 'package:equatable/equatable.dart';
import 'package:tobetoapp/models/event_model.dart';

abstract class CalendarState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventInitial extends CalendarState {}

class EventLoading extends CalendarState {}

class EventLoaded extends CalendarState {
  final Map<DateTime, List<Event>> groupedEvents;

  EventLoaded(this.groupedEvents);

  @override
  List<Object?> get props => [groupedEvents];
}

class EventError extends CalendarState {
  final String message;

  EventError(this.message);

  @override
  List<Object?> get props => [message];
}

class EventEducationSearchLoaded extends CalendarState {
  final List<String> suggestions;

  EventEducationSearchLoaded(this.suggestions);

  @override
  List<Object?> get props => [suggestions];
}
