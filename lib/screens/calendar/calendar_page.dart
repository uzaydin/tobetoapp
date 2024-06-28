import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:tobetoapp/models/event_model.dart';
import 'package:tobetoapp/screens/calendar/filter/events_page.dart';
import 'package:tobetoapp/services/event_service.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final EventService _eventService = EventService();
  CalendarView _calendarView = CalendarView.month;
  Event? _selectedEvent;
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const CalendarViewPage(),
    const EventsPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: "Takvim"),
          BottomNavigationBarItem(
              icon: Icon(Icons.filter_alt_rounded), label: "Filtrele"),
        ],
      ),
    );
  }
}

class CalendarViewPage extends StatefulWidget {
  const CalendarViewPage({super.key});

  @override
  _CalendarViewPageState createState() => _CalendarViewPageState();
}

class _CalendarViewPageState extends State<CalendarViewPage> {
  final EventService _eventService = EventService();
  CalendarView _calendarView = CalendarView.month;
  Event? _selectedEvent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Eğitim ve Etkinlik Takvimi',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.view_week),
            onPressed: () {
              setState(() {
                _calendarView = CalendarView.week;
              });
            },
          ),
          IconButton(
              icon: const Icon(Icons.view_module),
              onPressed: () {
                setState(() {
                  _calendarView = CalendarView.month;
                });
              }),
        ],
      ),
      body: StreamBuilder<List<Event>>(
        stream: _eventService.streamEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Görüntülenecek etkinlik yok.'));
          }

          List<Event> events = snapshot.data!;
          return SfCalendar(
            view: _calendarView,
            firstDayOfWeek: 1,
            dataSource: EventDataSource(events),
            headerStyle: CalendarHeaderStyle(
                textStyle: (Theme.of(context).textTheme.titleMedium),
                textAlign: TextAlign.center),
            monthViewSettings: const MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
              appointmentDisplayCount: 2,
            ),
            appointmentBuilder: (context, calendarAppointmentDetails) {
              final Event event = calendarAppointmentDetails.appointments.first;
              final Color eventColor = getEventColor(event);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedEvent = event;
                  });
                  _showEventDetails(context, event);
                },
                child: Container(
                  width: calendarAppointmentDetails.bounds.width,
                  height: calendarAppointmentDetails.bounds.height,
                  color: eventColor,
                  child: Center(
                    child: Text(
                      event.education,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

Color getEventColor(Event event) {
  final DateTime now = DateTime.now();
  if (event.date.isBefore(now)) {
    return Colors.red;
  } else if (event.date.isAfter(now)) {
    return Colors.blue;
  } else {
    return Colors.green;
  }
}

void _showEventDetails(BuildContext context, Event event) {
  final Color borderColor = getEventColor(event);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor, width: 3),
          borderRadius: BorderRadius.circular(AppConstants.br10),
        ),
        child: Container(
          width: AppConstants.screenWidth * 0.8,
          height: AppConstants.screenHeight * 0.4,
          padding: EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                event.education,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: AppConstants.sizedBoxHeightMedium),
              Text('Eğitmen: ${event.educator}'),
              SizedBox(height: AppConstants.sizedBoxHeightSmall),
              Text(
                  'Tarih: ${event.date.day.toString().padLeft(2, '0')}-${event.date.month.toString().padLeft(2, '0')}-${event.date.year}'),
              SizedBox(height: AppConstants.sizedBoxHeightSmall),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(FontAwesomeIcons.hourglassStart, size: 20),
                  SizedBox(width: AppConstants.sizedBoxWidthSmall),
                  Text(
                      'Başlangıç Saati: ${event.startTime.hour.toString().padLeft(2, '0')}:${event.startTime.minute.toString().padLeft(2, '0')}'),
                ],
              ),
              SizedBox(height: AppConstants.sizedBoxHeightSmall),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(FontAwesomeIcons.hourglassEnd, size: 18),
                  SizedBox(width: AppConstants.sizedBoxWidthSmall),
                  Text(
                      'Bitiş Saati: ${event.endTime.hour.toString().padLeft(2, '0')}:${event.endTime.minute.toString().padLeft(2, '0')}'),
                ],
              ),
              if (event.price != null) ...[
                SizedBox(height: AppConstants.sizedBoxHeightSmall),
                Text('Fiyat: ${event.price}'),
              ],
            ],
          ),
        ),
      );
    },
  );
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].endTime;
  }

  @override
  String getSubject(int index) {
    return appointments![index].education;
  }

  @override
  bool isAllDay(int index) {
    return false;
  }
}
