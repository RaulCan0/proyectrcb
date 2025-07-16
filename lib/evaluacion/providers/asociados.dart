import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/asociado.dart';

class AsociadosProvider with ChangeNotifier {
  final _client = Supabase.instance.client;
  List<Asociado> asociados = [];
  bool isLoading = false;

  final Map<String, Map<String, dynamic>> _progresos = {};

  Future<void> cargarAsociados(String empresaId) async {
    isLoading = true;
    notifyListeners();
    final response = await _client.from('asociados').select().eq('id_empresa', empresaId);
    asociados = (response as List).map((e) => Asociado.fromMap(e)).toList();
    isLoading = false;
    notifyListeners();
  }
void actualizarProgreso({
  required String idAsociado,
  required String idDimension,
  required int totalComportamientos,
  required int comportamientosEvaluados,
}) {
  final key = '${idAsociado}_$idDimension';

  final double porcentaje = totalComportamientos == 0
      ? 0.0
      : comportamientosEvaluados / totalComportamientos;

  _progresos[key] = {
    'id_asociado': idAsociado,
    'id_dimension': idDimension,
    'total_comportamientos': totalComportamientos,
    'comportamientos_evaluados': comportamientosEvaluados,
    'porcentaje': porcentaje,
  };

  notifyListeners(); // Por si necesitas notificar en el UI
}
}