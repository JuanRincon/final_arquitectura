import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  CalendarScreenState createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? selectedDay;
  Map<DateTime, List<Map<String, dynamic>>> _tasksByDate = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  DateTime? _safeToDate(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      print('Error al parsear la fecha: $e');
      return null;
    }
  }

  // Función para cargar las tareas desde la API Flask
  Future<void> _loadTasks() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    final response =
        await http.get(Uri.parse('http://localhost:5000/api/publications'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final tasksByDate = <DateTime, List<Map<String, dynamic>>>{};

      for (var task in data) {
        final date = _safeToDate(task['date']);

        if (date != null) {
          final normalizedDate = DateTime(date.year, date.month, date.day);
          final taskData = {
            'subject': task['subject'] ?? 'Sin materia',
            'description': task['description'] ?? 'Sin descripción',
            'status': task['status'] ?? 'Pendiente',
          };

          tasksByDate[normalizedDate] = (tasksByDate[normalizedDate] ?? [])
            ..add(taskData);
        } else {
          print('Tarea sin fecha válida.');
        }
      }

      setState(() {
        _tasksByDate = tasksByDate;
        isLoading = false;
      });
    } else {
      print('Error al cargar las tareas: ${response.statusCode}');
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _getTasksForDay(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return _tasksByDate[normalizedDate] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendario de Actividades')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            selectedDayPredicate: (day) => isSameDay(selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                this.selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: (day) {
              return _getTasksForDay(day);
            },
            calendarBuilders: CalendarBuilders(
              todayBuilder: (context, day, focusedDay) {
                return _buildDayCell(context, day, focusedDay, isToday: true);
              },
              selectedBuilder: (context, day, focusedDay) {
                return _buildDayCell(context, day, focusedDay, isToday: false);
              },
              defaultBuilder: (context, day, focusedDay) {
                return _buildDayCell(context, day, focusedDay, isToday: false);
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount:
                        _getTasksForDay(selectedDay ?? _focusedDay).length,
                    itemBuilder: (context, index) {
                      final task =
                          _getTasksForDay(selectedDay ?? _focusedDay)[index];
                      return ExpansionTile(
                        title: Text(task['subject'] ?? 'Sin materia'),
                        children: [
                          ListTile(
                            title:
                                Text(task['description'] ?? 'Sin descripción'),
                            subtitle: Text(
                              'Estado: ${task['status'] ?? 'Pendiente'}',
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCell(BuildContext context, DateTime day, DateTime focusedDay,
      {required bool isToday}) {
    final events = _getTasksForDay(day);
    bool isSelected = isSameDay(day, selectedDay);

    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.grey
            : isToday
                ? Colors.transparent
                : Colors.transparent,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Text(
                  '${day.day}',
                  style: TextStyle(
                    color: isToday ? Colors.black : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (isToday)
              Positioned(
                top: 4,
                left: 4,
                right: 4,
                bottom: 4,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.purpleAccent.withOpacity(0.2),
                      border: Border.all(
                        color: Colors.purpleAccent,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
