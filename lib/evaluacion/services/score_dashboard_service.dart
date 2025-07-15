import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/evaluacion.dart';
import '../models/calificacion.dart';

/// Servicio para obtener y calcular datos del dashboard de score.
class ScoreDashboardService {
  /// Obtiene todas las evaluaciones de una empresa desde Supabase.
  static Future<List<Evaluacion>> obtenerEvaluaciones(SupabaseClient client, String empresaId) async {
    final response = await client.from('detalles_evaluacion').select().eq('empresa_id', empresaId);
    return (response as List).map((e) => Evaluacion.fromMap(e)).toList();
  }

  /// Obtiene todas las calificaciones de una empresa desde Supabase.
  static Future<List<Calificacion>> obtenerCalificaciones(SupabaseClient client, String empresaId) async {
    final response = await client.from('calificaciones').select().eq('id_empresa', empresaId);
    return (response as List).map((e) => Calificacion.fromMap(e)).toList();
  }

  /// Calcula el total acumulado por dimensión para el gráfico multiring.
  static Map<String, double> calcularTotalesPorDimension(List<Evaluacion> evaluaciones) {
    final Map<String, double> totales = {};
    for (final eval in evaluaciones) {
      totales[eval.dimension] = (totales[eval.dimension] ?? 0) + eval.puntaje;
    }
    return totales;
  }

  /// Calcula el promedio por principio para el gráfico scatterBubble.
  static Map<String, double> calcularPromediosPorPrincipio(List<Evaluacion> evaluaciones) {
    final Map<String, List<double>> agrupados = {};
    for (final eval in evaluaciones) {
      agrupados.putIfAbsent(eval.principio, () => []).add(eval.puntaje);
    }
    return agrupados.map((k, v) => MapEntry(k, v.isNotEmpty ? v.reduce((a, b) => a + b) / v.length : 0));
  }

  /// Calcula el promedio por comportamiento y cargo para el gráfico de barras agrupadas.
  static Map<String, Map<int, double>> calcularPromediosPorComportamientoPorCargo(List<Calificacion> calificaciones) {
    // No existe el campo 'cargo' en Calificacion, así que debes agrupar por otro campo, por ejemplo 'comportamiento' o por un campo adicional si lo tienes en el modelo.
    // Si el cargo viene en el modelo Evaluacion, deberías usar Evaluacion en vez de Calificacion para este cálculo.
    // Aquí se agrupa solo por comportamiento, eliminando la agrupación por cargo.
    final Map<String, List<double>> agrupados = {};
    for (final calif in calificaciones) {
      agrupados.putIfAbsent(calif.comportamiento, () => []).add(calif.puntaje.toDouble());
    }
    final Map<String, Map<int, double>> promedios = {};
    agrupados.forEach((comportamiento, lista) {
      promedios[comportamiento] = {0: lista.isNotEmpty ? lista.reduce((a, b) => a + b) / lista.length : 0};
    });
    return promedios;
  }

  /// Calcula el score global promedio por cargo para el gráfico de barras horizontal.
  static Map<int, double> calcularScoreGlobalPorCargo(List<Calificacion> calificaciones) {
    // No existe el campo 'cargo' en Calificacion, así que agrupamos todos los puntajes juntos.
    final List<double> puntajes = calificaciones.map((c) => c.puntaje.toDouble()).toList();
    final double promedio = puntajes.isNotEmpty ? puntajes.reduce((a, b) => a + b) / puntajes.length : 0.0;
    return {0: promedio};
  }
}
