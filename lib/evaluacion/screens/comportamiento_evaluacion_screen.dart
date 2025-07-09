// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lensysapp/custom/appcolors.dart';

class ComportamientoEvaluacionScreen extends StatelessWidget {
  const ComportamientoEvaluacionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text('Evaluación de Comportamiento', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.info_outline, size: 18),
                  label: const Text('Benchmark Nivel', style: TextStyle(fontSize: 12)),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.help_outline, size: 18),
                  label: const Text('Guía', style: TextStyle(fontSize: 12)),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.settings, size: 18),
                  label: const Text('Sistemas', style: TextStyle(fontSize: 12)),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Subir o Tomar Foto'),
            ),
            const SizedBox(height: 20),
            const Text('Calificación:', style: TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: 0,
              min: 1,
              max: 5,
              divisions: 4,
              label: '0',
              onChanged: (v) {},
            ),
            const Text('Desliza para calificar:', style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('Sin descripción disponible'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.remove_red_eye),
              label: const Text('Ver lentes de madurez'),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(
                child: TextField(
                  maxLines: 2,
                  enabled: true,
                  decoration: const InputDecoration(hintText: 'Observaciones...', border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(icon: const Icon(Icons.camera_alt, size: 28), onPressed: () {}),
            ]),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text('Guardar Evaluación', style: TextStyle(color: Colors.white)),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
