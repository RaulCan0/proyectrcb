import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/calificacion.dart';

class CalificacionProvider extends ChangeNotifier {
  final _svc = SupabaseService();
  List<Calificacion> calificaciones = [];
  bool cargando = false;

  Future<void> cargarCalificaciones(String asociadoId) async {
    cargando = true; notifyListeners();
    calificaciones = await _svc.getCalificacionesPorAsociado(asociadoId);
    cargando = false; notifyListeners();
  }
}