import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class NewPublishForm extends StatefulWidget {
  final String? documentId;

  const NewPublishForm({Key? key, this.documentId}) : super(key: key);

  @override
  _NewPublishFormState createState() => _NewPublishFormState();
}

class _NewPublishFormState extends State<NewPublishForm> {
  final _formKey = GlobalKey<FormState>();
  String publisher = '';
  String description = '';
  String publishimage = '';
  bool isLoading = false;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.documentId != null) {
      loadPublishData(widget.documentId!);
    }
  }

  void loadPublishData(String documentId) async {
    setState(() {
      isLoading = true;
    });

    try {
      final doc = await FirebaseFirestore.instance
          .collection('Publication')
          .doc(documentId)
          .get();
      if (doc.exists) {
        setState(() {
          publisher = doc['publisher'] ?? '';
          description = doc['description'] ?? '';
          publishimage = doc['publishimage'] ?? '';
        });
      }
    } catch (e) {
      print("Error al cargar los datos: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });

        publishimage = await uploadImage(imageFile!) ?? '';
        setState(() {});
      }
    } catch (e) {
      print("Error al seleccionar la imagen: $e");
    }
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef =
          FirebaseStorage.instance.ref().child("images/$fileName");
      await storageRef.putFile(imageFile);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print("Error al subir la imagen: $e");
      return null;
    }
  }

  Future<void> savePublish() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      isLoading = true;
    });

    try {
      if (imageFile != null) {
        publishimage = await uploadImage(imageFile!) ?? publishimage;
      }
      final timestamp = Timestamp.now();
      final publishData = {
        'publisher': publisher,
        'description': description,
        'publishimage': publishimage,
        'Date': timestamp,
      };

      if (widget.documentId != null) {
        await FirebaseFirestore.instance
            .collection('Publication')
            .doc(widget.documentId)
            .update(publishData);
      } else {
        await FirebaseFirestore.instance
            .collection('Publication')
            .add(publishData);
      }

      Navigator.pop(context, true);
    } catch (e) {
      print("Error al guardar la publicación: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.documentId != null
            ? 'Editar Publicación'
            : 'Nueva Publicación'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      initialValue: publisher,
                      decoration: const InputDecoration(
                          labelText: 'Nombre', prefixIcon: Icon(Icons.person)),
                      onSaved: (value) => publisher = value ?? '',
                      validator: (value) => value == null || value.isEmpty
                          ? 'Por favor ingrese un nombre'
                          : null,
                    ),
                    TextFormField(
                      initialValue: description,
                      decoration: const InputDecoration(
                          labelText: 'Descripción',
                          prefixIcon: Icon(Icons.text_fields)),
                      onSaved: (value) => description = value ?? '',
                    ),
                    TextFormField(
                      initialValue: publishimage,
                      decoration: const InputDecoration(
                          labelText: 'URL de la Imagen',
                          prefixIcon: Icon(Icons.image)),
                      onSaved: (value) => publishimage = value ?? '',
                      enabled: false,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: pickImage,
                      child: const Text("Seleccionar Imagen"),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: savePublish,
                      child: Text(
                          widget.documentId != null ? 'Actualizar' : 'Guardar'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
