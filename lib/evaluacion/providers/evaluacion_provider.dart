import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/evaluacion.dart';

class EvaluacionesProvider with ChangeNotifier {
  final _client = Supabase.instance.client;
  List<Evaluacion> evaluaciones = [];
  bool isLoading = false;

 Future<void> cargarEvaluaciones(String empresaId) async {
  isLoading = true;
  notifyListeners();
  try {
    final response = await _client.from('evaluacion').select().eq('empresa_id', empresaId);
    evaluaciones = (response as List).map((e) => Evaluacion.fromMap(e)).toList();
  } catch (e) {
    evaluaciones = [];
    debugPrint('Error al cargar evaluaciones: $e');
  } finally {
    isLoading = false;
    notifyListeners();
  }
}
}