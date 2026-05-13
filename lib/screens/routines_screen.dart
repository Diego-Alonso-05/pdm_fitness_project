import 'package:flutter/material.dart';

class RoutinesScreen extends StatelessWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rotinas'),
      ),

      body: const Center(
        child: Text(
          'Ecrã de Rotinas',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}