class Activity {
  final String id;
  String subject;
  String description;
  bool isCompleted;
  String? comment;
  DateTime? date;
  String status;

  Activity({
    required this.id,
    required this.subject,
    required this.description,
    this.isCompleted = false,
    this.comment,
    this.date,
    this.status = 'Pendiente',
  });

  // Constructor que crea una actividad a partir de un mapa (que es lo que recibirás de la API Flask)
  factory Activity.fromMap(Map<String, dynamic> data) {
    DateTime? activityDate;
    // MongoDB almacena las fechas como DateTime, por lo que no se necesita convertir
    if (data['date'] != null) {
      activityDate = DateTime.parse(data['date']);
    }

    return Activity(
      id: data['id'] ?? '', // MongoDB generalmente devuelve un ID como string
      subject: data['subject'] ?? '',
      description: data['description'] ?? '',
      isCompleted: data['status'] == 'Completada',
      date: activityDate,
      status: data['status'] ?? 'Pendiente',
    );
  }

  // Método para convertir la actividad en un mapa para enviar a la API Flask
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'description': description,
      'status': isCompleted ? 'Completada' : 'Pendiente',
      'comment': comment,
      'date':
          date?.toIso8601String(), // MongoDB acepta DateTime como string ISO
    };
  }
}
