// dimensiones_screen.dart

import 'package:flutter/material.dart';
import 'package:lensysapp/custom/appcolors.dart';

class DimensionesScreen extends StatelessWidget {
  const DimensionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dimensiones = const [
      {
        'id': '1',
        'nombre': 'IMPULSORES CULTURALES',
        'icono': Icons.group,
        'color': Colors.indigo,
      },
      {
        'id': '2',
        'nombre': 'MEJORA CONTINUA',
        'icono': Icons.update,
        'color': Colors.green,
      },
      {
        'id': '3',
        'nombre': 'ALINEAMIENTO EMPRESARIAL',
        'icono': Icons.business,
        'color': AppColors.d1, // Use the correct static const from AppColors
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 35, 47, 112),
        centerTitle: true,
        title: const Text('Dimensiones'),
      ),
      body: ListView.builder(
        itemCount: dimensiones.length,
        itemBuilder: (context, index) {
          final dimension = dimensiones[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(
                  dimension['icono'],
                  color: dimension['color'],
                  size: 36,
                ),
                title: Text(
                  dimension['nombre'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}
