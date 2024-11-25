import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modernlogintute/pages/SettingsScreen.dart';
import 'package:modernlogintute/pages/newtask_screen.dart';
import 'package:modernlogintute/pages/calendar_screen.dart';
import 'package:modernlogintute/pages/profile_screen.dart';
import 'activities_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _paginaActual = 0;
  final GlobalKey<ActivitiesScreenState> _activitiesScreenKey =
      GlobalKey<ActivitiesScreenState>();

  late List<Widget> _paginas;

  @override
  void initState() {
    super.initState();
    _paginas = [
      CalendarScreen(),
      ActivitiesScreen(key: _activitiesScreenKey),
      ProfileScreen(),
    ];
  }

  void _onFloatingActionButtonPressed() async {
    if (_paginaActual == 0) {
      // Solo en la pantalla principal
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewTaskScreen(
            selectedDate: DateTime.now(),
            subjects: _activitiesScreenKey.currentState?.subjects ?? [],
          ),
        ),
      );
      if (result == true) {
        _activitiesScreenKey.currentState?.loadActivities();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ManaWork'),
        leading: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsScreen(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: IndexedStack(
        index: _paginaActual,
        children: _paginas,
      ),
      floatingActionButton: _paginaActual == 0
          ? FloatingActionButton(
              mini: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              heroTag: 'home_fab',
              onPressed: _onFloatingActionButtonPressed,
              child: const Icon(Icons.add_task),
              backgroundColor: Colors.pink,
              foregroundColor: Colors.white,
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaActual,
        onTap: (index) {
          setState(() {
            _paginaActual = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Actividades'),
          BottomNavigationBarItem(
              icon: Icon(Icons.article), label: 'Publicaciones'),
        ],
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        selectedItemColor: Colors.pink,
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
      ),
    );
  }
}
