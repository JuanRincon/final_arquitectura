import 'package:flutter/material.dart';

class Guardar extends StatefulWidget {
  const Guardar({super.key});

  @override
  State<Guardar> createState() => _GuardarState();
}

class _GuardarState extends State<Guardar> {
  bool _statelike = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          setState(() {
            _statelike = !_statelike;
          });
        },
        child: Text(
          "Guardar",
          style: TextStyle(
              color: _statelike ? Colors.amber : Colors.grey,
              fontSize: 17,
              fontWeight: FontWeight.bold),
        ));
  }
}
