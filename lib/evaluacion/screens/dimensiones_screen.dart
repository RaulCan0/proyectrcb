import 'package:flutter/material.dart';
import 'package:lensysapp/custom/appcolors.dart';
import 'package:lensysapp/evaluacion/models/empresa.dart';
import 'package:lensysapp/evaluacion/screens/asociado_screen.dart';
import 'package:lensysapp/evaluacion/screens/shingo_result.dart';
import 'package:lensysapp/evaluacion/screens/tabla_score_global.dart';
import 'package:lensysapp/evaluacion/services/evaluacion_service.dart';
import 'package:lensysapp/evaluacion/widgets/endrawer_lensys.dart';
import '../services/progresos_service.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class DimensionesScreen extends StatefulWidget {
  final Empresa empresa;
  final String evaluacionId;

  const DimensionesScreen({
    super.key,
    required this.empresa,
    required this.evaluacionId,
  });

  @override
  State<DimensionesScreen> createState() => _DimensionesScreenState();
}

class _DimensionesScreenState extends State<DimensionesScreen> with RouteAware {
  final EvaluacionService evaluacionService = EvaluacionService();

  final List<Map<String, dynamic>> dimensiones = [
    {
      'id': '1',
      'nombre': 'IMPULSORES CULTURALES',
      'icono': Icons.group,
      'color': AppColors.d1,
    },
    {
      'id': '2',
      'nombre': 'MEJORA CONTINUA',
      'icono': Icons.update,
      'color': AppColors.d2,
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
        MaterialPageRoute(builder: (_) => const ShingoResultsScreen()),
      ),
    },
    {
      'id': '5',
      'nombre': 'EVALUACIÓN FINAL',
      'icono': Icons.score,
      'color': const Color.fromARGB(255, 5, 10, 14),
      'navigate': (BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const TablaScoreGlobal()),
      ),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : const Color(0xFF003056),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Dimensiones - ${widget.empresa.nombre}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: const EndrawerLensys(),
      body: ListView.builder(
        itemCount: dimensiones.length,
        itemBuilder: (context, index) {
          final dimension = dimensiones[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: SizedBox(
              height: 110, // Altura aumentada
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
                leading: Icon(dimension['icono'], color: dimension['color'], size: 32),
                title: Text(
                  dimension['nombre'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: index < 3
                    ? FutureBuilder<double>(
                        future: ProgresosService().progresoDimension(
                          empresaId: widget.empresa.id,
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
                      )
                    : null,
                onTap: () async {
                  if (index < 3) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AsociadoScreen(
                          empresa: widget.empresa,
                          dimensionId: dimension['id'],
                          evaluacionId: widget.evaluacionId,
                        ),
                      ),
                    );
                  } else {
                    dimension['navigate'](context);
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
