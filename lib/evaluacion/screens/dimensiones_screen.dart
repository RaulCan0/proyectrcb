import 'package:flutter/material.dart';
import 'package:lensysapp/custom/appcolors.dart';
import 'package:lensysapp/evaluacion/models/empresa.dart';
import 'package:lensysapp/evaluacion/screens/asociado_screen.dart';
import 'package:lensysapp/evaluacion/screens/shingo_result.dart';
import 'package:lensysapp/evaluacion/screens/tabla_score_global.dart';
import 'package:lensysapp/evaluacion/widgets/drawer_lensys.dart';

import '../services/progresos_service.dart';

class DimensionesScreen extends StatelessWidget {
  final Empresa empresa;
  final String evaluacionId;

  const DimensionesScreen({super.key, required this.empresa, required this.evaluacionId, required String empresaId});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dimensiones = [
      {
        'id': '1',
        'nombre': 'IMPULSORES CULTURALES',
        'icono': Icons.group,
        'color': AppColors.d1,},
      {
        'id': '2',
        'nombre': 'MEJORA CONTINUA',
        'icono': Icons.update,
        'color': AppColors.d2
      },
      {
        'id': '3',
        'nombre': 'ALINEAMIENTO EMPRESARIAL',
        'icono': Icons.business,
        'color': AppColors.d3,
      },
      
      {
        'id': '4',
        'nombre': 'RESULTADOS',
        'icono': Icons.show_chart,
        'color': const Color.fromARGB(255, 28, 50, 71),
        'navigate': (BuildContext context) => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ShingoResultsScreen()),
            ),
      },
      {
        'id': '5',
        'nombre': 'EVALUACION FINAL',
        'icono': Icons.score,
        'color': const Color.fromARGB(255, 5, 10, 14),
        'navigate': (BuildContext context) => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TablaScoreGlobal()),
            ),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003056),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Dimensiones - ${empresa.nombre}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
        ],
      ),
      endDrawer: const DrawerLensys(),
      body: ListView.builder(
        itemCount: dimensiones.length,
        itemBuilder: (context, index) {
          final dimension = dimensiones[index];
          if (index < 3) {
            // Solo las primeras 3 muestran progreso
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: ListTile(
                leading: Icon(dimension['icono'], color: dimension['color']),
                title: Text(dimension['nombre'], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: FutureBuilder<double>(
                  future: ProgresosService().progresoDimension(
                    empresaId: empresa.id,
                    dimensionId: dimension['id'],
                  ),
                  builder: (context, snapshot) {
                    final progreso = (snapshot.data ?? 0.0).clamp(0.0, 1.0);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: progreso,
                          minHeight: 8,
                          backgroundColor: Colors.grey[300],
                          color: dimension['color'],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(progreso * 100).toStringAsFixed(1)}% completado',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    );
                  },
                ),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AsociadoScreen(
                        empresa: empresa,
                        dimensionId: dimension['id'],
                        evaluacionId: evaluacionId,
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            // Las otras solo navegan
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: ListTile(
                leading: Icon(dimension['icono'], color: dimension['color']),
                title: Text(dimension['nombre'], style: const TextStyle(fontWeight: FontWeight.bold)),
                onTap: () => dimension['navigate'](context),
              ),
            );
          }
        },
      ),
    );
  }
}