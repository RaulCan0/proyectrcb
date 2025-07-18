
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/calificacion.dart';

class CalificacionesProvider with ChangeNotifier {
  final _client = Supabase.instance.client;
  List<Calificacion> calificaciones = [];
  bool isLoading = false;

  Future<void> cargarCalificacionesPorAsociado(String asociadoId) async {
    isLoading = true;
    notifyListeners();
    final response = await _client.from('calificaciones').select().eq('id_asociado', asociadoId);
    calificaciones = (response as List).map((e) => Calificacion.fromMap(e)).toList();
    isLoading = false;
    notifyListeners();
  }

  Future<void> cargarCalificacionesPorEmpresa(String empresaId) async {
    isLoading = true;
    notifyListeners();
    final response = await _client.from('calificaciones').select().eq('id_empresa', empresaId);
    calificaciones = (response as List).map((e) => Calificacion.fromMap(e)).toList();
    isLoading = false;
    notifyListeners();
  }
}