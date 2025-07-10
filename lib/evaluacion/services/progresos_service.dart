import 'package:lensysapp/evaluacion/services/supabase_service.dart';

/// Servicio centralizado para el cálculo de progreso de dimensiones, asociados y principios.
/// Integra la lógica directamente, sin depender de EvaluacionService.
/// Todos los métodos retornan valores normalizados [0.0-1.0].
class ProgresosService {
  final SupabaseService _supabaseService;

  /// Permite inyección para pruebas unitarias y mocks.
  ProgresosService({SupabaseService? supabaseService})
      : _supabaseService = supabaseService ?? SupabaseService();

  /// Obtiene el progreso de una dimensión para una empresa.
  /// [empresaId]: ID de la empresa.
  /// [dimensionId]: ID de la dimensión (string).
  /// Retorna progreso normalizado entre 0.0 y 1.0.
  Future<double> progresoDimension({
    required String empresaId,
    required String dimensionId,
  }) async {
    try {
      final response = await _supabaseService.obtenerProgresoDimension(empresaId, dimensionId);
      return response.clamp(0.0, 1.0);
    } catch (_) {
      return 0.0;
    }
  }

  /// Obtiene el progreso de un asociado en una dimensión específica.
  /// [evaluacionId]: ID de la evaluación o empresa (según tu modelo).
  /// [asociadoId]: ID del asociado.
  /// [dimensionId]: ID de la dimensión.
  /// Retorna progreso normalizado entre 0.0 y 1.0.
  Future<double> progresoAsociado({
    required String evaluacionId,
    required String asociadoId,
    required String dimensionId,
  }) async {
    try {
      final progreso = await _supabaseService.obtenerProgresoAsociado(
        evaluacionId: evaluacionId,
        asociadoId: asociadoId,
        dimensionId: dimensionId,
      );
      return progreso.clamp(0.0, 1.0);
    } catch (_) {
      return 0.0;
    }
  }

  /// Calcula el progreso de un principio a partir de comportamientos evaluados.
  /// [totalComportamientos]: Total de comportamientos posibles.
  /// [comportamientosEvaluados]: Número de comportamientos evaluados.
  /// Retorna progreso normalizado entre 0.0 y 1.0.
  double progresoPrincipio({
    required int totalComportamientos,
    required int comportamientosEvaluados,
  }) {
    if (totalComportamientos == 0) return 0.0;
    return (comportamientosEvaluados / totalComportamientos).clamp(0.0, 1.0);
  }

  /// Obtiene el progreso de todos los principios de un asociado en una dimensión.
  /// Devuelve un Map donde la clave es el nombre del principio y el valor el progreso [0.0-1.0].
  Future<Map<String, double>> progresoPrincipiosDeAsociado({
    required String asociadoId,
    required String dimensionId,
    required List<String> nombresPrincipios,
    required Map<String, List<String>> comportamientosPorPrincipio,
  }) async {
    try {
      final calificaciones = await _supabaseService.getCalificacionesPorAsociado(asociadoId);
      final filtradas = calificaciones.where((c) => c.idDimension.toString() == dimensionId);
      final respondidos = <String, Set<String>>{};
      for (final principio in nombresPrincipios) {
        respondidos[principio] = {};
      }
      for (final cal in filtradas) {
        for (final p in nombresPrincipios) {
          if (comportamientosPorPrincipio[p]?.contains(cal.comportamiento) ?? false) {
            respondidos[p]?.add(cal.comportamiento);
          }
        }
      }
      final progresoPorPrincipio = <String, double>{};
      for (final p in nombresPrincipios) {
        final total = comportamientosPorPrincipio[p]?.length ?? 0;
        final contestados = respondidos[p]?.length ?? 0;
        progresoPorPrincipio[p] = total == 0 ? 0.0 : (contestados / total).clamp(0.0, 1.0);
      }
      return progresoPorPrincipio;
    } catch (_) {
      return {for (final p in nombresPrincipios) p: 0.0};
    }
  }
}