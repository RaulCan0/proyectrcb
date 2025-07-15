import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/error_handler_service.dart';
import '../services/score_dashboard_service.dart';

/// Provider centralizado para dashboard de score y gráficos.
class ScoreDashboardProvider with ChangeNotifier {
  final _client = Supabase.instance.client;

  // Estado observable para todos los gráficos
  Map<String, double> dimensionTotals = {};
  Map<String, double> principleAverages = {};
  Map<String, Map<int, double>> behaviorAveragesByCargo = {};
  Map<int, double> globalScoreByCargo = {};

  bool isLoading = false;
  String? error;

  /// Carga y calcula todos los datos necesarios para el dashboard.
  Future<void> cargarDashboard(BuildContext context, String empresaId) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      // Obtiene datos crudos desde Supabase
      final evaluaciones = await ScoreDashboardService.obtenerEvaluaciones(_client, empresaId);
      final calificaciones = await ScoreDashboardService.obtenerCalificaciones(_client, empresaId);

      // Calcula totales y promedios usando el servicio
      dimensionTotals = ScoreDashboardService.calcularTotalesPorDimension(evaluaciones);
      principleAverages = ScoreDashboardService.calcularPromediosPorPrincipio(evaluaciones);
      behaviorAveragesByCargo = ScoreDashboardService.calcularPromediosPorComportamientoPorCargo(calificaciones);
      globalScoreByCargo = ScoreDashboardService.calcularScoreGlobalPorCargo(calificaciones);
    } catch (e) {
      error = 'Error al cargar dashboard: $e';
      // ignore: use_build_context_synchronously
      ErrorHandlerService.showSnackBar(context, error!);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
