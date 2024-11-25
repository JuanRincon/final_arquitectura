import 'package:flutter/material.dart';
import 'package:modernlogintute/widgets/likebuttom.dart';

class BottomCard extends StatelessWidget {
  final String documentId;

  const BottomCard({Key? key, required this.documentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        LikeButton(documentId: documentId),
        IconButton(
          icon: const Icon(Icons.comment),
          onPressed: () {},
        ),
      ],
    );
  }
}
