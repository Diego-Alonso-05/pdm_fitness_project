import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness App'),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              'Ecrã Inicial',
              style: TextStyle(fontSize: 24),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                context.go('/routines');
              },
              child: const Text('Rotinas'),
            ),

            ElevatedButton(
              onPressed: () {
                context.go('/progress');
              },
              child: const Text('Progresso'),
            ),

            ElevatedButton(
              onPressed: () {
                context.go('/history');
              },
              child: const Text('Histórico'),
            ),

          ],
        ),
      ),
    );
  }
}