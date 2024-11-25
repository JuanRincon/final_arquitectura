import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl =
      'http://10.0.2.2:5000/api'; // Cambia según tu configuración

  // Obtener publicaciones
  Future<List<dynamic>> getPublications() async {
    final response = await http.get(Uri.parse('$baseUrl/publications'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Error al cargar las publicaciones');
    }
  }

  // Agregar publicación
  Future<void> addPublication(Map<String, dynamic> publication) async {
    final response = await http.post(
      Uri.parse('$baseUrl/publications'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(publication),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al agregar la publicación');
    }
  }

  // Eliminar publicación
  Future<void> deletePublication(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/publications/$id'));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar la publicación');
    }
  }

  // Actualizar publicación
  Future<void> updatePublication(
      String id, Map<String, dynamic> publication) async {
    final response = await http.put(
      Uri.parse('$baseUrl/publications/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(publication),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar la publicación');
    }
  }
}
