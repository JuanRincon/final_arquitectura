import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'activity.dart';
import 'newtask_screen.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({Key? key}) : super(key: key);

  @override
  ActivitiesScreenState createState() => ActivitiesScreenState();
}

class ActivitiesScreenState extends State<ActivitiesScreen> {
  List<Activity> activities = [];
  List<String> subjects = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadActivities();
    _loadSubjects();
  }

  // Cargar actividades desde la API Flask
  void loadActivities() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'http://10.0.2.2:5000/api/publications')); // Cambia a la URL de tu API Flask
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          activities = data.map((item) => Activity.fromMap(item)).toList();
        });
      } else {
        throw Exception('Error al cargar las actividades');
      }
    } catch (e) {
      print("Error al cargar actividades: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Crear una nueva materia
  Future<void> _createSubject(BuildContext context) async {
    final subject = await _showCreateSubjectDialog(context);
    if (subject != null) {
      setState(() {
        subjects.add(subject['name']!);
      });
    }
  }

  // Mostrar el diálogo para crear una materia
  Future<Map<String, String>?> _showCreateSubjectDialog(
      BuildContext context) async {
    String subjectName = '';
    return showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Crear Nueva Materia'),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: 'Nombre de la materia'),
            onChanged: (value) {
              subjectName = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop({
                  'name': subjectName,
                });
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  // Navegar a la pantalla para crear una nueva tarea
  void _navigateToNewTask() async {
    if (subjects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Debe crear al menos una materia primero')),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewTaskScreen(
          selectedDate: DateTime.now(),
          subjects: subjects,
        ),
      ),
    );

    if (result == true) {
      loadActivities();
      _loadSubjects();
    }
  }

  // Eliminar una actividad
  Future<void> _deleteActivity(String activityId) async {
    try {
      final response = await http.delete(
          Uri.parse('http://10.0.2.2:5000/api/publications/$activityId'));
      if (response.statusCode == 200) {
        setState(() {
          activities.removeWhere((activity) => activity.id == activityId);
        });
      } else {
        throw Exception('Error al eliminar la actividad');
      }
    } catch (e) {
      print("Error al eliminar la actividad: $e");
    }
  }

  // Función para actualizar el estado de la actividad
  void _toggleActivityCompletion(Activity activity) async {
    try {
      final updatedStatus =
          activity.status == 'Completada' ? 'Pendiente' : 'Completada';
      final activityIndex = activities.indexWhere((a) => a.id == activity.id);
      if (activityIndex != -1) {
        setState(() {
          activities[activityIndex].status = updatedStatus;
        });
      }

      final response = await http.put(
        Uri.parse('http://10.0.2.2:5000/api/publications/${activity.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'status': updatedStatus}),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al actualizar la actividad');
      }
    } catch (e) {
      print("Error al actualizar el estado de la actividad: $e");
    }
  }

  // Construir la lista de actividades
  Widget _buildActivityList() {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return Dismissible(
                key: Key(activity.id),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) async {
                  await _deleteActivity(activity.id);
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: ListTile(
                  title: Text(activity.description),
                  subtitle: Text(
                    activity.status ?? 'Pendiente',
                    style: TextStyle(
                      color: activity.status == 'Completada'
                          ? Colors.pinkAccent
                          : Colors.red,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      activity.status == 'Completada'
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: activity.status == 'Completada'
                          ? Colors.pinkAccent
                          : Colors.grey,
                    ),
                    onPressed: () => _toggleActivityCompletion(activity),
                  ),
                ),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Actividades'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(child: _buildActivityList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        heroTag: 'create_subject_fab',
        onPressed: () => _createSubject(context),
        child: Icon(Icons.book),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class _loadSubjects {}
