import 'package:flutter/material.dart';
import 'package:lensysapp/evaluacion/models/calificacion.dart';
import 'package:lensysapp/evaluacion/services/supabase_service.dart';
import '../screens/tablas_screen.dart';

class DatosProvider with ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();

  Future<void> guardarCalificacion(Calificacion calificacion, {bool actualizar = false}) async {
    if (actualizar) {
      await _supabaseService.updateCalificacionFull(calificacion);
    } else {
      await _supabaseService.addCalificacion(calificacion, id: calificacion.id, idAsociado: calificacion.idAsociado);
    }
    notifyListeners();
  }

  Future<void> actualizarDatoTabla({
    required String evaluacionId,
    required String dimension,
    required String principio,
    required String comportamiento,
    required String cargo,
    required int valor,
    required List<String> sistemas,
    required String dimensionId,
    required String asociadoId,
    required String observaciones,
  }) async {
    await TablasDimensionScreen.actualizarDato(
      evaluacionId,
      dimension: dimension,
      principio: principio,
      comportamiento: comportamiento,
      cargo: cargo,
      valor: valor,
      sistemas: sistemas,
      dimensionId: dimensionId,
      asociadoId: asociadoId,
      observaciones: observaciones,
    );
    notifyListeners();
  }
}