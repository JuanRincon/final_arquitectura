import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

/*Future<List> getPublish() async {
  List publish = [];

  CollectionReference collectionReferencePublish = db.collection('Publication');

  QuerySnapshot queryPublish = await collectionReferencePublish.get();

  queryPublish.docs.forEach((documento) {
    publish.add(documento.data());
  });

  return publish;
}
*/

Future<List<Map<String, dynamic>>> getPublish() async {
  List<Map<String, dynamic>> publish = [];

  try {
    CollectionReference collectionReferencePublish =
        db.collection('Publication');

    // Ordena por el campo 'Date' en orden descendente
    QuerySnapshot queryPublish = await collectionReferencePublish
        .orderBy('Date', descending: true)
        .get();

    for (var documento in queryPublish.docs) {
      Map<String, dynamic> data = documento.data() as Map<String, dynamic>;
      data['id'] = documento.id; // Agrega el documentId a los datos
      publish.add(data);
    }
  } catch (e) {
    print("Error al obtener los documentos: $e");
  }

  return publish;
}

// Función para agregar una nueva publicación
Future<void> addPublish(Map<String, dynamic> newPublish) async {
  try {
    CollectionReference collectionReferencePublish =
        db.collection('Publication');
    await collectionReferencePublish
        .add(newPublish); // Añadir el nuevo documento a la colección
  } catch (e) {
    print("Error al agregar publicación: $e");
  }
}

Future<void> updatePublish(
    String documentId, Map<String, dynamic> updatedPublish) async {
  try {
    CollectionReference collectionReferencePublish =
        db.collection('Publication');
    await collectionReferencePublish.doc(documentId).update(updatedPublish);
    print("Se guardo correctamente:$documentId");
  } catch (e) {
    print("Error al actualizar la publicación: $e");
  }
}

// Obtener una publicación específica por su documentId
Future<DocumentSnapshot> getPublishById(String documentId) {
  return db.collection('Publication').doc(documentId).get();
}
