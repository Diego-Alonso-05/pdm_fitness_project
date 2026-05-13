import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progresso'),
      ),

      body: const Center(
        child: Text(
          'Ecrã de Progresso',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}