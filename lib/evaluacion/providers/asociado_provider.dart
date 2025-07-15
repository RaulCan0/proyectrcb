import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/asociado.dart';

class AsociadoProvider extends ChangeNotifier {
  final _svc = SupabaseService();
  List<Asociado> asociados = [];
  bool cargando = false;

  Future<void> cargarAsociadosPorEmpresa(String empresaId) async {
    cargando = true; notifyListeners();
    asociados = await _svc.getAsociadosPorEmpresa(empresaId);
    cargando = false; notifyListeners();
  }
}