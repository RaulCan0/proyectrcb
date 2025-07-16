import 'package:flutter/foundation.dart';
import 'package:lensysapp/evaluacion/services/supabase_service.dart';

/// Servicio centralizado para el cálculo de progreso de dimensiones, asociados y principios.
/// Todos los métodos retornan valores normalizados [0.0-1.0].
class ProgresosService {
  final SupabaseService _supabaseService;

  /// Permite inyección para pruebas unitarias y mocks.
  ProgresosService({SupabaseService? supabaseService})
      : _supabaseService = supabaseService ?? SupabaseService();

  Future<double> progresodimension({
    required String idempresa,
    required String iddimension,
  }) async {
    try {
      final resultados = await _supabaseService.getResultadosDashboard(
        empresaId: idempresa,
        dimensionId: int.tryParse(iddimension),
      );
      if (resultados.isNotEmpty) {
        // El provider mapea 'promedio_general' a 'promedio'
        final valor = resultados.first['promedio'] ?? 0.0;
        return (valor as num).toDouble().clamp(0.0, 1.0);
      }
      return 0.0;
    } catch (e, st) {
      debugPrint('Error en progreso_dimension: $e\n$st');
      return 0.0;
    }
  }

  /// Obtiene el “avance” de un asociado en una dimensión.
  /// Retorna 1.0 si existe al menos una calificación en esa dimensión, 0.0 en caso contrario.
  Future<double> progresoasociado({
    required String idevaluacion,
    required String idasociado,
    required String iddimension,
  }) async {
    try {
      final calificaciones =
          await _supabaseService.getCalificacionesPorAsociado(idasociado);
      final filtradas = calificaciones.where(
        (c) => c.idDimension.toString() == iddimension,
      );
      return filtradas.isNotEmpty ? 1.0 : 0.0;
    } catch (e, st) {
      debugPrint('Error en progreso_asociado: $e\n$st');
      return 0.0;
    }
  }

  /// Calcula el progreso de un principio a partir de comportamientos evaluados.
  /// [total_comportamientos]: Total de comportamientos posibles.
  /// [comportamientos_evaluados]: Número de comportamientos efectivamente evaluados.
  double progresoprincipio({
    required int totalcomportamientos,
    required int comportamientosEvaluados,
  }) {
    if (totalcomportamientos <= 0) return 0.0;
    return (comportamientosEvaluados / totalcomportamientos).clamp(0.0, 1.0);
  }

  /// Obtiene el progreso de todos los principios de un asociado en una dimensión.
  /// Devuelve un Map donde la clave es el nombre del principio y el valor el progreso [0.0-1.0].
  Future<Map<String, double>> progresoprincipiosdeasociado({
    required String idasociado,
    required String iddimension,
    required List<String> nombresprincipios,
    required Map<String, List<String>> comportamientosporprincipio,
  }) async {
    try {
      final calificaciones =
          await _supabaseService.getCalificacionesPorAsociado(idasociado);
      final filtradas = calificaciones.where(
        (c) => c.idDimension.toString() == iddimension,
      );

      // Inicializa conteo de comportamientos respondidos
      final respondidos = <String, Set<String>>{
        for (final p in nombresprincipios) p: {},
      };

      for (final cal in filtradas) {
        for (final p in nombresprincipios) {
          if (comportamientosporprincipio[p]?.contains(cal.comportamiento) ?? false) {
            respondidos[p]!.add(cal.comportamiento);
          }
        }
      }

      // Calcula porcentaje por principio
      final progresoPorPrincipio = <String, double>{};
      for (final p in nombresprincipios) {
        final total = comportamientosporprincipio[p]?.length ?? 0;
        final contestados = respondidos[p]?.length ?? 0;
        progresoPorPrincipio[p] = progresoprincipio(
          totalcomportamientos: total,
          comportamientosEvaluados: contestados,
        );
      }

      return progresoPorPrincipio;
    } catch (e, st) {
      debugPrint('Error en progreso_principios_de_asociado: $e\n$st');
      // En caso de falla, retorna 0.0 para todos
      return {for (final p in nombresprincipios) p: 0.0};
    }
  }
}
