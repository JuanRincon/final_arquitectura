import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modernlogintute/widgets/card.dart';

class ListCard extends StatelessWidget {
  const ListCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Publication')
          .orderBy('Date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error al cargar los datos"));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No hay publicaciones disponibles"));
        }

        List<QueryDocumentSnapshot> publish = snapshot.data!.docs;

        return ListView.builder(
          itemCount: publish.length,
          itemBuilder: (context, index) {
            final documentData = publish[index].data() as Map<String, dynamic>;
            final documentId = publish[index].id;

            return CardWidget(
              data: documentData,
              documentId: documentId,
            );
          },
        );
      },
    );
  }
}
