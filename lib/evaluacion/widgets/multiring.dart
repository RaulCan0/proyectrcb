import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MultiRingChart extends StatelessWidget {
  /// Puntos obtenidos por categoría.
  final Map<String, double> dataPoints;
  /// Colores para cada categoría (misma clave que en [dataPoints]).
  final Map<String, Color> dataColors;
  /// Total de puntos posibles (p. ej. 800).
  final double totalPoints;
  /// Si true, usa radios y tamaños mayores.
  final bool isDetail;

  const MultiRingChart({
    super.key,
    required this.dataPoints,
    required this.dataColors,
    this.totalPoints = 800,
    this.isDetail = false,
  });

  @override
  Widget build(BuildContext context) {
    final entries = dataPoints.entries.toList();
    final int n = entries.length;
    // Tamaño del widget que lo contiene
    final double chartSize = isDetail ? 500 : 400;
    // Radio máximo exterior
    final double maxRadius = isDetail ? 160 : 120;
    // Grosor de cada anillo
    final double ringWidth = maxRadius / n;

    return SizedBox(
      width: chartSize,
      height: chartSize,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(n, (idx) {
          final entry = entries[idx];
          final filled = entry.value;
          final empty = (totalPoints - filled).clamp(0, totalPoints);
          final double outerRadius = maxRadius - idx * ringWidth;

          return PieChart(
            PieChartData(
              startDegreeOffset: -90,
              sectionsSpace: 0,
              centerSpaceRadius: outerRadius - ringWidth,
              sections: [
                // Porción “llenada”
                PieChartSectionData(
                  value: filled,
                  color: dataColors[entry.key] ?? Colors.blue,
                  radius: outerRadius,
                  showTitle: false,
                ),
                // Porción “vacía”
                PieChartSectionData(
                  value: empty.toDouble(),
                  color: Colors.grey.shade200,
                  showTitle: false,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
