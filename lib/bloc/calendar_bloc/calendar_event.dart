import 'package:equatable/equatable.dart';

abstract class CalendarEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchEvents extends CalendarEvent {}

class UpdateFilters extends CalendarEvent {
  final String searchQuery;
  final String selectedEducator;
  final List<String> selectedStatuses;

  UpdateFilters(this.searchQuery, this.selectedEducator, this.selectedStatuses,
      {List<String>? combinedTrainings});

  @override
  List<Object?> get props => [searchQuery, selectedEducator, selectedStatuses];
}

class SearchEducations extends CalendarEvent {
  final String query;

  SearchEducations(this.query);

  @override
  List<Object?> get props => [query];
}
