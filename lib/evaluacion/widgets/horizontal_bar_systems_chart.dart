import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HorizontalBarSystemsChart extends StatelessWidget {
  final Map<String, Map<String, double>> data;
  final double minY;
  final double maxY;
  final List<String> sistemasOrdenados;

  const HorizontalBarSystemsChart({
    super.key,
    required this.data,
    required this.minY,
    required this.maxY,
    required this.sistemasOrdenados,
  });

  @override
  Widget build(BuildContext context) {
    final chartData = sistemasOrdenados.map((s) {
      final levels = data[s] ?? {'E': 0.0, 'G': 0.0, 'M': 0.0};
      return _SystemData(
        s,
        levels['E'] ?? 0.0,
        levels['G'] ?? 0.0,
        levels['M'] ?? 0.0,
      );
    }).toList();

    if (chartData.isEmpty) {
      return const Center(child: Text('No hay datos'));
    }

    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(scrollbars: true),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          height: 60.0 * chartData.length + 80, // Ajusta la altura según la cantidad de sistemas
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
              minY: minY,
              barTouchData: BarTouchData(enabled: true),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text(value.toInt().toString()),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              barGroups: List.generate(chartData.length, (i) {
                final d = chartData[i];
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: d.e,
                      color: Colors.orange,
                      width: 12,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    BarChartRodData(
                      toY: d.g,
                      color: Colors.green,
                      width: 12,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    BarChartRodData(
                      toY: d.m,
                      color: Colors.blue,
                      width: 12,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                  showingTooltipIndicators: [0, 1, 2],
                );
              }),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: false),
              groupsSpace: 24,
            ),
          ),
        ),
      ),
    );
  }
}

class _SystemData {
  final String sistema;
  final double e, g, m;
  _SystemData(this.sistema, this.e, this.g, this.m);
}
