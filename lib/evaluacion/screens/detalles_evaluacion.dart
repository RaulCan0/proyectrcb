import 'package:flutter/material.dart';

class DetallesEvaluacionScreen extends StatelessWidget {
  const DetallesEvaluacionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de Evaluación'),
        backgroundColor: Color.fromARGB(255, 35, 47, 112),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.dashboard),
                label: const Text('Ver Dashboard'),
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.file_download),
                label: const Text('Generar Prereporte'),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}