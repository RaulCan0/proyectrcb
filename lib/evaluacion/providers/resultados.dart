import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResultadosDashboardProvider with ChangeNotifier {
  final _client = Supabase.instance.client;
  List<Map<String, dynamic>> resultados = [];
  bool isLoading = false;

  Future<void> cargarResultadosDashboard(String empresaId) async {
    isLoading = true;
    notifyListeners();
    final response = await _client.from('resultados_dashboard').select().eq('empresa_id', empresaId);
    resultados = List<Map<String, dynamic>>.from(response as List);
    isLoading = false;
    notifyListeners();
  }
}