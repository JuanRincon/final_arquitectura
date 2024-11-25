import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:modernlogintute/widgets/bottomscard.dart';

class CardWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final String documentId;

  const CardWidget({super.key, required this.data, required this.documentId});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          // Mostrar el nombre del publicador y la descripción
          ListTile(
            title: Text(data["publisher"] ?? "Sin nombre"),
            subtitle: Text(data["description"] ?? "Sin descripción"),
          ),

          // Verifica si el campo de la imagen existe y no es vacío
          if (data["publishimage"] != null && data["publishimage"] != "")
            CachedNetworkImage(
              imageUrl: data["publishimage"],
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          const SizedBox(height: 8),

          // Botones de "Me gusta" y "Comentar"
          BottomCard(documentId: documentId),
        ],
      ),
    );
  }
}
