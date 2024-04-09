import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:pmsn_06/services/firestore_alquiler_service.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final DateTime alquilerDate;
  final String idCliente;
  final DateTime devolucionDate;
  final String total;

  Event(this.alquilerDate, this.idCliente, this.devolucionDate, this.total);
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _focusedDay;
  final DateTime _firstDay = DateTime.utc(2010, 10, 16);
  final DateTime _lastDay = DateTime.utc(2030, 10, 16);

  final List<Event> _futureEvents = [];
  final List<Event> _pastEvents = [];
  final List<Event> _currentDayEvents = [];

  final FirestoreAlquilerService _firestoreAlquilerService = FirestoreAlquilerService();

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _loadEvents();
  }

  void _loadEvents() async {
    final List<Map<String, dynamic>> alquilerList = await _firestoreAlquilerService.getAlquiler();
    alquilerList.forEach((alquiler) {
      DateTime fechaAlquiler = DateTime.parse(alquiler['fechaAlquiler']);
      DateTime fechaDevolucion = DateTime.parse(alquiler['fechaDevolucion']);
      String total = alquiler['total'].toString();
      DateTime now = DateTime.now();
      if (isSameDay(fechaAlquiler, now)) {
        _currentDayEvents.add(Event(fechaAlquiler, alquiler['idCliente'], fechaDevolucion, total));
      } else if (fechaAlquiler.isAfter(now)) {
        _futureEvents.add(Event(fechaAlquiler, alquiler['idCliente'], fechaDevolucion, total));
      } else {
        _pastEvents.add(Event(fechaAlquiler, alquiler['idCliente'], fechaDevolucion, total));
      }
    });
    setState(() {}); // Actualiza la interfaz con los nuevos eventos
  }

  bool _isDateInPast(DateTime date) {
    final today = DateTime.now();
    return date.isBefore(today);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calendar")),
      body: calendar(),
    );
  }

  Widget calendar() {
    return Column(
      children: [
        const Text("123"),
        TableCalendar(
          locale: "en_US",
          rowHeight: 80,
          focusedDay: _focusedDay,
          firstDay: _firstDay,
          lastDay: _lastDay,
          calendarFormat: CalendarFormat.month,
          eventLoader: _getEventsForDay,
          onDaySelected: _onDaySelected,
          onPageChanged: _onPageChanged,
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              final List<Widget> markers = [];
              if (events.isNotEmpty) {
                final isCurrentDay = isSameDay(date, DateTime.now());
                final isFutureEvent = !_isDateInPast(date);
                markers.add(
                  Positioned(
                    bottom: 10,
                    child: Row(
                      children: [
                        if (isCurrentDay)
                          const Icon(
                            Icons.circle,
                            color: Colors.orange, // Cambiar el color a naranja
                            size: 10,
                          ),
                        for (int i = 0; i < events.length; i++)
                          Icon(
                            Icons.circle,
                            color: isFutureEvent ? Colors.green : Colors.red,
                            size: 10,
                          ),
                      ],
                    ),
                  ),
                );
              }
              return Stack(
                children: markers,
              );
            },
          ),
        ),
      ],
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
    final List<Event> futureEvents = _futureEvents.where((event) => isSameDay(event.alquilerDate, day)).toList();
    final List<Event> pastEvents = _pastEvents.where((event) => isSameDay(event.alquilerDate, day)).toList();
    final List<Event> currentDayEvents = _currentDayEvents.where((event) => isSameDay(event.alquilerDate, day)).toList();
    return [...currentDayEvents, ...futureEvents, ...pastEvents];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });

    _showEventsModal(selectedDay);
  }

  void _onPageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });
  }

  void _showEventsModal(DateTime selectedDay) {
    List<Event> events = _getEventsForDay(selectedDay);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                    'Eventos para el día ${selectedDay.day}/${selectedDay.month}/${selectedDay.year}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      Event event = events[index];
                      return Card(
                        child: ListTile(
                          title: Text('ID Cliente: ${event.idCliente}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Fecha Alquiler: ${DateFormat.yMMMd().format(event.alquilerDate)}'), // Formatear la fecha sin la hora
                              Text('Fecha Devolución: ${DateFormat.yMMMd().format(event.devolucionDate)}'), // Formatear la fecha sin la hora
                              Text('Total: ${event.total}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}