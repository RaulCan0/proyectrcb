// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:lensysapp/custom/appcolors.dart';
import 'package:lensysapp/evaluacion/providers/score_dashboard_provider.dart';
import 'package:lensysapp/evaluacion/widgets/endrawer_lensys.dart';
import 'package:lensysapp/perfil/theme_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/grouped_bar_chart.dart';
import '../widgets/horizontal_bar_systems_chart.dart';
import '../widgets/multiring.dart';
import '../widgets/scatter_bubble_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key,  required String evaluacionId, required String empresaId, });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final Map<String, Color> ringColors = {
    'Impulsores': Colors.blue,
    'Mejora': Colors.green,
    'Alineamiento': Colors.orange,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ScoreDashboardProvider>(context, listen: false);
      // Ajusta empresaId según tu lógica de sesión
      final empresaId = '';
      provider.cargarDashboard(context, empresaId);
    });
  }


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    final dashboard = context.watch<ScoreDashboardProvider>();
    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkMode ? Colors.black : AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Gráficos de la evaluación',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Ajusta empresaId según tu lógica de sesión
              final empresaId = '';
              dashboard.cargarDashboard(context, empresaId);
            },
            tooltip: 'Refrescar datos',
          ),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: const EndrawerLensys(),
      body: dashboard.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // RING
                  Text('Resumen por Dimensión', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  MultiRingChart(
                    dataPoints: dashboard.dimensionTotals,
                    dataColors: ringColors,
                    totalPoints: 5.0,
                  ),
                  const SizedBox(height: 32),
                  // SCATTER
                  Text('Promedios por Principio', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 300,
                    child: ScatterBubbleChart(
                      // Debes adaptar principleAverages a la estructura de ScatterData si es necesario
                      data: [],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // GROUPED
                  Text('Promedios por Comportamiento', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 300,
                    child: GroupedBarChart(
                      data: dashboard.behaviorAveragesByCargo.map((k, v) => MapEntry(k, [v[1] ?? 0, v[2] ?? 0, v[3] ?? 0])),
                      minY: 0,
                      maxY: 5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // SYSTEMS
                  Text('Promedios por Sistema', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 400,
                    child: HorizontalBarSystemsChart(
                      data: {}, // Adapta si tienes systemsData en el provider
                      minY: 0,
                      maxY: 5,
                      sistemasOrdenados: const [],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}