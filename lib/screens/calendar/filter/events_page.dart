import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tobetoapp/bloc/auth/auth_drawer/drawer_manager.dart';
import 'package:tobetoapp/bloc/calendar_bloc/calendar.state.dart';
import 'package:tobetoapp/bloc/calendar_bloc/calendar_bloc.dart';

import 'package:tobetoapp/bloc/calendar_bloc/calendar_event.dart';
import 'package:tobetoapp/models/event_model.dart';
import 'package:tobetoapp/screens/calendar/filter/checkboxes.dart';
import 'package:tobetoapp/screens/calendar/filter/educator_dropdown.dart';
import 'package:tobetoapp/screens/calendar/filter/search_field.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';
import 'package:tobetoapp/utils/theme/light/light_theme.dart';
import 'package:tobetoapp/widgets/common_app_bar.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _selectedEducators = [];
  List<String> _selectedStatuses = [];
  List<String> _educators = [];
  Map<String, List<String>> _educatorTrainings = {};

  @override
  void initState() {
    super.initState();
    _fetchEducators();
  }

  Future<void> _fetchEducators() async {
    try {
      QuerySnapshot educatorSnapshot =
          await FirebaseFirestore.instance.collection('educators').get();
      List<String> educators = [];
      Map<String, List<String>> educatorTrainings = {};

      for (var doc in educatorSnapshot.docs) {
        String educatorName = doc['name'];
        educators.add(educatorName);

        QuerySnapshot trainingSnapshot = await FirebaseFirestore.instance
            .collection('educators')
            .doc(doc.id)
            .collection('trainings')
            .get();

        List<String> trainings = trainingSnapshot.docs
            .map((trainingDoc) => trainingDoc['title'] as String)
            .toList();
        educatorTrainings[educatorName] = trainings;
      }

      setState(() {
        _educators = educators;
        _educatorTrainings = educatorTrainings;
      });
    } catch (e) {
      '$e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      drawer: DrawerManager(),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
              left: AppConstants.paddingSmall,
              right: AppConstants.paddingSmall),
          child: Padding(
            padding: EdgeInsets.all(AppConstants.paddingMedium),
            child: Center(
              child: Column(
                children: [
                  OutlineGradientButton(
                    padding: EdgeInsets.all(AppConstants.paddingMedium),
                    strokeWidth: 3,
                    radius: Radius.circular(AppConstants.br16),
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.tobetoMoru,
                        Colors.white30,
                        AppColors.tobetoMoru,
                        Colors.white30
                      ],
                      stops: [0.0, 0.5, 0.5, 1.0],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SearchField(
                          searchController: _searchController,
                          onSearch: _updateFilters,
                        ),
                        SizedBox(height: AppConstants.sizedBoxHeightMedium),
                        EducatorDropdown(
                          educators: _educators,
                          selectedEducators: _selectedEducators,
                          onChanged: (selectedEducators) {
                            setState(() {
                              _selectedEducators = selectedEducators;
                            });
                            _updateFilters();
                          },
                        ),
                        SizedBox(height: AppConstants.sizedBoxHeightMedium),
                        StatusCheckboxes(
                          selectedStatuses: _selectedStatuses,
                          onChanged: (status, selected) {
                            setState(() {
                              selected!
                                  ? _selectedStatuses.add(status)
                                  : _selectedStatuses.remove(status);
                            });
                            _updateFilters();
                          },
                        ),
                        SizedBox(height: AppConstants.sizedBoxHeightMedium),
                        BlocBuilder<CalendarBloc, CalendarState>(
                          builder: (context, state) {
                            if (state is EventLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (state is EventLoaded) {
                              final groupedEvents = state.groupedEvents;
                              if (groupedEvents.isEmpty) {
                                return const Center(
                                    child: Text('Mevcut etkinlik yok.'));
                              }

                              return ListView(
                                shrinkWrap: true,
                                children: groupedEvents.entries.map((entry) {
                                  final date = entry.key;
                                  final eventsForDate = entry.value;
                                  return ExpansionTile(
                                    title: Text(
                                        '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}'),
                                    children: eventsForDate.map((event) {
                                      final now = DateTime.now();
                                      final eventStart = DateTime(
                                          date.year,
                                          date.month,
                                          date.day,
                                          event.startTime.hour,
                                          event.startTime.minute);
                                      final eventEnd = DateTime(
                                          date.year,
                                          date.month,
                                          date.day,
                                          event.endTime.hour,
                                          event.endTime.minute);

                                      Color tileColor;
                                      if (eventEnd.isBefore(now)) {
                                        tileColor = Colors.red;
                                      } else if (eventStart.isAfter(now)) {
                                        tileColor = Colors.blue;
                                      } else {
                                        tileColor = Colors.orange;
                                      }
                                      return Container(
                                        color: tileColor,
                                        child: ListTile(
                                          title: Text(event.education),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  'Eğitmen: ${event.educator}'),
                                              Text(
                                                  'Saat: ${event.startTime.hour.toString().padLeft(2, '0')}:${event.startTime.minute.toString().padLeft(2, '0')} - ${event.endTime.hour.toString().padLeft(2, '0')}:${event.endTime.minute.toString().padLeft(2, '0')}'),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                }).toList(),
                              );
                            } else if (state is EventError) {
                              return Center(
                                  child: Text('Hata: ${state.message}'));
                            }
                            return const Center(
                                child: Text('Bilinmeyen durum'));
                          },
                        ),
                        SizedBox(height: AppConstants.sizedBoxHeightXXLarge),
                        SizedBox(height: AppConstants.sizedBoxHeightLarge),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateFilters() {
    List<String> filteredEducators = [];
    if (_selectedEducators.isNotEmpty) {
      for (String educator in _selectedEducators) {
        if (_educatorTrainings.containsKey(educator) &&
            _educatorTrainings[educator]!.isNotEmpty) {
          filteredEducators.add(educator);
        }
      }
    } else {
      filteredEducators.addAll(_educators.where((educator) =>
          _educatorTrainings.containsKey(educator) &&
          _educatorTrainings[educator]!.isNotEmpty));
    }

    context.read<CalendarBloc>().add(
          UpdateFilters(
            _searchController.text,
            _selectedEducators.isEmpty ? '' : _selectedEducators.join(', '),
            List<String>.from(_selectedStatuses),
          ),
        );
  }
}
