// lib/evaluacion/services/progresos_service.dart
import 'package:lensysapp/evaluacion/services/supabase_service.dart';

/// Servicio centralizado para el cálculo de progresos de dimensiones, asociados y principios.
/// Todos los métodos retornan valores normalizados entre 0.0 y 1.0.
class ProgresosService {
  final SupabaseService _supabaseService;

  /// Mapa de totales de comportamientos por dimensión.
  static const Map<String, int> _mapaTotalesDimension = {
    '1': 6,
    '2': 14,
    '3': 8,
  };

  /// Constructor con inyección para pruebas unitarias.
  ProgresosService({SupabaseService? supabaseService})
      : _supabaseService = supabaseService ?? SupabaseService();

  /// Obtiene el progreso de una dimensión para una empresa.
  Future<double> progresoDimension({
    required String empresaId,
    required String dimensionId,
  }) async {
    try {
      final response = await _supabaseService.client
          .from('calificaciones')
          .select('comportamiento')
          .eq('id_empresa', empresaId)
          .eq('id_dimension', int.tryParse(dimensionId) ?? -1)
          .then((res) => res);

      final total = (response as List).length;
      final totalDimension = _mapaTotalesDimension[dimensionId] ?? 1;
      return (total / totalDimension).clamp(0.0, 1.0);
    } catch (_) {
      return 0.0;
    }
  }

  /// Obtiene el progreso de un asociado en una dimensión específica.
  Future<double> progresoAsociado({
    required String evaluacionId,
    required String asociadoId,
    required String dimensionId,
  }) async {
    if (evaluacionId.isEmpty || asociadoId.isEmpty || dimensionId.isEmpty) {
      return 0.0;
    }
    try {
      final response = await _supabaseService.client
          .from('calificaciones')
          .select('comportamiento')
          .eq('id_asociado', asociadoId)
          .eq('id_empresa', evaluacionId)
          .eq('id_dimension', int.tryParse(dimensionId) ?? -1)
          .then((res) => res);

      final total = (response as List).length;
      final totalDimension = _mapaTotalesDimension[dimensionId] ?? 1;
      return (total / totalDimension).clamp(0.0, 1.0);
    } catch (_) {
      return 0.0;
    }
  }

  /// Progreso global de la dimensión (comportamientos únicos evaluados).
  Future<double> progresoDimensionGlobal({
    required String empresaId,
    required String dimensionId,
  }) async {
    try {
      final response = await _supabaseService.client
          .from('calificaciones')
          .select('comportamiento')
          .eq('id_empresa', empresaId)
          .eq('id_dimension', int.tryParse(dimensionId) ?? -1)
          .then((res) => res);

      final evaluados = (response as List)
          .map((e) => e['comportamiento'].toString())
          .toSet()
          .length;
      final totalDimension = _mapaTotalesDimension[dimensionId] ?? 1;
      return (evaluados / totalDimension).clamp(0.0, 1.0);
    } catch (_) {
      return 0.0;
    }
  }

  /// Calcula el progreso de un principio dado números de comportamientos evaluados.
  double progresoPrincipio({
    required int comportamientosEvaluados,
    required int totalComportamientos,
  }) {
    if (totalComportamientos == 0) return 0.0;
    return (comportamientosEvaluados / totalComportamientos).clamp(0.0, 1.0);
  }

  /// Calcula el progreso por principio de un asociado en una dimensión.
  Future<Map<String, double>> progresoPrincipiosDeAsociado({
    required String asociadoId,
    required String dimensionId,
    required List<String> nombresPrincipios,
    required Map<String, List<String>> comportamientosPorPrincipio,
  }) async {
    try {
      final calificaciones = await _supabaseService.getCalificacionesPorAsociado(asociadoId);
      final filtradas = calificaciones
          .where((c) => c.idDimension.toString() == dimensionId)
          .toList();

      final respondidos = <String, Set<String>>{
        for (final p in nombresPrincipios) p: <String>{}
      };

      for (final cal in filtradas) {
        for (final p in nombresPrincipios) {
          if (comportamientosPorPrincipio[p]?.contains(cal.comportamiento) == true) {
            respondidos[p]?.add(cal.comportamiento);
          }
        }
      }

      return {
        for (final p in nombresPrincipios)
          p: progresoPrincipio(
            comportamientosEvaluados: respondidos[p]?.length ?? 0,
            totalComportamientos: comportamientosPorPrincipio[p]?.length ?? 0,
          )
      };
    } catch (_) {
      return {for (final p in nombresPrincipios) p: 0.0};
    }
  }
}