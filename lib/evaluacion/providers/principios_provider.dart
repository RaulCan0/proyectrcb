import 'package:flutter/material.dart';
import 'package:lensysapp/evaluacion/models/calificacion.dart';
import 'package:lensysapp/evaluacion/models/principio_json.dart';
import 'package:lensysapp/evaluacion/services/json_service.dart';
import 'package:lensysapp/evaluacion/services/supabase_service.dart';

class PrincipiosProvider extends ChangeNotifier {
  Map<String, List<PrincipioJson>> principios = {};
  Map<String, Calificacion> calificaciones = {};
  Set<String> comportamientosEvaluados = {};
  bool cargando = true;

  final SupabaseService _supabaseService = SupabaseService();

  Future<void> cargarPrincipiosYCalificaciones(
    String dimensionId,
    String cargo,
    String asociadoId,
  ) async {
    cargando = true;
    notifyListeners();

    try {
      final json = await JsonService.cargarJson('t$dimensionId.json');
      if (json.isEmpty) throw Exception('JSON de principios vacío');

      final todos = json.map((e) => PrincipioJson.fromJson(e)).toList();
      // Debug: imprime todos los principios y el cargo recibido
      debugPrint('Principios cargados:');
      for (var p in todos) {
        debugPrint('Cargo en JSON: ${p.cargo}, Cargo recibido: $cargo');
      }
      // Filtro robusto: compara ignorando mayúsculas/minúsculas y espacios
      final cargoNormalizado = cargo.trim().toLowerCase();
      final filtrados = todos.where((p) {
        return p.cargo.trim().toLowerCase() == cargoNormalizado;
      }).toList();
      debugPrint('Principios filtrados: ${filtrados.length}');

      final agrupados = <String, List<PrincipioJson>>{};
      for (var p in filtrados) {
        agrupados.putIfAbsent(p.nombre.trim(), () => []).add(p);
      }
      agrupados.removeWhere((_, list) => list.isEmpty);

      final calificacionesSupabase = await _supabaseService.getCalificacionesPorAsociado(asociadoId);
      final idDim = int.tryParse(dimensionId) ?? 1;

      final evaluadosTemp = <String>[];
      final califTemp = <String, Calificacion>{};

      for (var cal in calificacionesSupabase) {
        if (cal.idDimension == idDim) {
          evaluadosTemp.add(cal.comportamiento);
          califTemp[cal.comportamiento] = cal;
        }
      }

      principios = agrupados;
      comportamientosEvaluados = evaluadosTemp.toSet();
      calificaciones = califTemp;
    } catch (e) {
      debugPrint('Error cargando datos de principios: $e');
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  void agregarCalificacion(String comportamiento, Calificacion calificacion) {
    if (!comportamientosEvaluados.contains(comportamiento)) {
      comportamientosEvaluados.add(comportamiento);
      calificaciones[comportamiento] = calificacion;
      notifyListeners();
    }
  }

  double progresoPorAsociado(String principioNombre) {
    final comportamientos = principios[principioNombre] ?? [];
    if (comportamientos.isEmpty) return 0.0;

    // Compara el nombre del comportamiento del principio con los que tienen calificación
    final evaluados = comportamientos.where((p) {
      // Si PrincipioJson tiene la propiedad comportamientos, úsala correctamente
      try {
        final List<String>? comps = (p as dynamic).comportamientos;
        if (comps != null && comps.isNotEmpty) {
          return comps.any((comp) => comportamientosEvaluados.contains(comp));
        }
      } catch (_) {}
      // Si no, usa el benchmarkComportamiento como identificador
      final nombreComp = p.benchmarkComportamiento.split(":").first.trim();
      return comportamientosEvaluados.contains(nombreComp);
    }).length;

    return evaluados / comportamientos.length;
  }
@override
  notifyListeners();
}
