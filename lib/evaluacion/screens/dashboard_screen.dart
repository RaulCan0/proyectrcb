// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:lensysapp/custom/appcolors.dart';
import 'package:lensysapp/evaluacion/widgets/drawer_lensys.dart';
import 'package:lensysapp/evaluacion/services/supabase_service.dart';
import '../widgets/grouped_bar_chart.dart';
import '../widgets/horizontal_bar_systems_chart.dart';
import '../widgets/multiring.dart';
import '../widgets/scatter_bubble_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  bool _loading = true;
  Map<String, double> ringData = {};
  Map<String, Color> ringColors = {
    'Impulsores': Colors.blue,
    'Mejora': Colors.green,
    'Alineamiento': Colors.orange,
  };
  List<ScatterData> scatterData = [];
  Map<String, List<double>> groupedData = {};
  Map<String, Map<String, double>> systemsData = {};
  List<String> sistemasOrdenados = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    // Ejemplo: obtener empresaId actual (ajusta según tu lógica de sesión)
    final empresaId = _supabaseService.userId ?? '';
    // RING: promedios por dimensión
    final dimAverages = await _supabaseService.getDimensionAverages(empresaId);
    ringData = {
      for (var d in dimAverages)
        (d.nombre.isNotEmpty ? d.nombre : 'Dimensión'): d.general,
    };
    // SCATTER: ejemplo con principles
    final principles = await _supabaseService.getPrinciplesAverages(empresaId);
    scatterData = [
      for (var p in principles)
        ScatterData(
          x: p.general,
          y: (p.id).toDouble(),
          color: Colors.blue,
          seriesName: 'Principio',
          principleName: (p.nombre.isNotEmpty ? p.nombre : ''),
          radius: 12,
        ),
    ];
    // GROUPED: ejemplo con comportamientos
    final behaviors = await _supabaseService.getBehaviorAverages(empresaId);
    groupedData = {};
    for (var b in behaviors) {
      groupedData[(b.nombre.isNotEmpty ? b.nombre : '')] = [b.ejecutivo, b.gerente, b.miembro];
    }
    // SYSTEMS: ejemplo con sistemas
    final systems = await _supabaseService.getSystemAverages(empresaId);
    systemsData = {};
    sistemasOrdenados = [];
    for (var s in systems) {
      final nombreSistema = (s.nombre.isNotEmpty ? s.nombre : '');
      systemsData[nombreSistema] = {
        'E': s.ejecutivo,
        'G': s.gerente,
        'M': s.miembro,
      };
      sistemasOrdenados.add(nombreSistema);
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
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
            onPressed: _loadData,
            tooltip: 'Refrescar datos',
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
            tooltip: 'Menú',
          ),
        ],
      ),
      endDrawer: const DrawerLensys(),
      body: _loading
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
                    dataPoints: ringData,
                    dataColors: ringColors,
                    totalPoints: 5.0, // Ajusta según tu escala
                  ),
                  const SizedBox(height: 32),
                  // SCATTER
                  Text('Promedios por Principio', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 300,
                    child: ScatterBubbleChart(data: scatterData),
                  ),
                  const SizedBox(height: 32),
                  // GROUPED
                  Text('Promedios por Comportamiento', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 300,
                    child: GroupedBarChart(
                      data: groupedData,
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
                      data: systemsData,
                      minY: 0,
                      maxY: 5,
                      sistemasOrdenados: sistemasOrdenados,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}