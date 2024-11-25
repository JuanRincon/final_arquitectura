import 'package:flutter/material.dart';

class DescriptionCard extends StatelessWidget {
  final String description;

  const DescriptionCard({Key? key, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(description),
    );
  }
}
