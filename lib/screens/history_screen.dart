import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
      ),

      body: const Center(
        child: Text(
          'Ecrã de Histórico',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}