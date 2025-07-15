import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/empresa.dart';

class EmpresaProvider extends ChangeNotifier {
  final _svc = SupabaseService();
  List<Empresa> empresas = [];
  bool cargando = false;

  Future<void> cargarEmpresas() async {
    cargando = true; notifyListeners();
    empresas = await _svc.getEmpresas();
    cargando = false; notifyListeners();
  }
}