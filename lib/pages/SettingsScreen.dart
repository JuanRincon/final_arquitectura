import 'package:flutter/material.dart';
import 'package:modernlogintute/pages/ProfileSettingsScreen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuraciones'),
        backgroundColor: Colors.pink,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: const Text('Ajustes de perfil'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileSettingsScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.article),
            title: const Text('Términos y condiciones'),
            onTap: () {
              // Navegar a la pantalla de términos y condiciones
            },
          ),
        ],
      ),
    );
  }
}
