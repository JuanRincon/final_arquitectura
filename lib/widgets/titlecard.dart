import 'package:flutter/material.dart';

class TitleCard extends StatelessWidget {
  final String name;
  final String documentId;

  const TitleCard({Key? key, required this.name, required this.documentId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
