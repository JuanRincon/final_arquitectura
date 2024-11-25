import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final String image;

  const ImageCard({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: image.isNotEmpty
          ? Image.network(
              image,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error,
                    color: Colors.red); // Mostrar un ícono de error
              },
            )
          : const SizedBox.shrink(),
    );
  }
}
