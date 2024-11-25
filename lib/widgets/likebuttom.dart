import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  final String documentId;

  const LikeButton({super.key, required this.documentId});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _stateLike = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        setState(() {
          _stateLike = !_stateLike;
        });
      },
      child: Text(
        "Me gusta",
        style: TextStyle(
          color: _stateLike ? Colors.blue : Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
