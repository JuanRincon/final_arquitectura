import 'package:flutter/material.dart';
import 'activity.dart';

class ActivityListScreen extends StatelessWidget {
  final List<Activity> activities;

  ActivityListScreen({Key? key, required this.activities}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Actividades')),
        body: Center(child: Text("No hay actividades disponibles")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Actividades')),
      body: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          return ListTile(
            title: Text(activity.description),
            subtitle: Text(activity.status ?? 'Pendiente'),
          );
        },
      ),
    );
  }
}
