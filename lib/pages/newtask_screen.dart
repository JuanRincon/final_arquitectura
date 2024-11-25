import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewTaskScreen extends StatefulWidget {
  final DateTime selectedDate;

  const NewTaskScreen(
      {Key? key, required this.selectedDate, required List subjects})
      : super(key: key);

  @override
  _NewTaskScreenState createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  String selectedSubject = '';
  String taskDescription = '';
  DateTime? selectedDate;
  bool isLoading = false;
  List<String> subjects = [];

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate;
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    setState(() {
      isLoading = true;
    });

    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('Subjects')
            .where('uid', isEqualTo: currentUser.uid) // Filtrar por UID
            .get();

        final loadedSubjects = snapshot.docs.map((doc) {
          return doc['name'] as String;
        }).toList();

        setState(() {
          subjects = loadedSubjects;
          selectedSubject = subjects.isNotEmpty ? subjects[0] : '';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("No se encontró un usuario autenticado")),
        );
      }
    } catch (e) {
      print("Error al cargar materias: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al cargar las materias")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveTask() async {
    if (selectedSubject.isNotEmpty &&
        taskDescription.isNotEmpty &&
        selectedDate != null) {
      setState(() {
        isLoading = true;
      });

      try {
        final currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser != null) {
          await FirebaseFirestore.instance.collection('Tasks').add({
            'date': Timestamp.fromDate(selectedDate!),
            'subject': selectedSubject,
            'description': taskDescription,
            'status': 'Pendiente',
            'uid': currentUser.uid,
          });

          Navigator.pop(context, true);
          loadActivities();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("No se encontró un usuario autenticado")),
          );
        }
      } catch (e) {
        print("Error al guardar la tarea: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al guardar la tarea")),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Tarea')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton<String>(
                    value: selectedSubject.isEmpty ? null : selectedSubject,
                    hint: const Text('Selecciona una Materia'),
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        selectedSubject = value!;
                      });
                    },
                    items: subjects.isNotEmpty
                        ? subjects
                            .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList()
                        : [
                            const DropdownMenuItem<String>(
                              value: '',
                              child: Text('No hay materias disponibles'),
                            )
                          ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(labelText: "Descripción"),
                    onChanged: (value) {
                      setState(() {
                        taskDescription = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Fecha de Entrega",
                      hintText: selectedDate == null
                          ? "Selecciona una fecha"
                          : "${selectedDate!.toLocal()}".split(' ')[0],
                    ),
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveTask,
                    child: const Text("Guardar Tarea"),
                  ),
                ],
              ),
      ),
    );
  }

  void loadActivities() {}
}
