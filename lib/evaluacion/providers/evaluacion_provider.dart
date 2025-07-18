import 'package:flutter/material.dart';
import '../models/evaluacion.dart';

class EvaluacionesProvider with ChangeNotifier {
  List<Evaluacion> evaluaciones = [];
  bool isLoading = false;

  Future<void> cargarEvaluaciones(String empresaId) async {
    isLoading = true;
    notifyListeners();
    // Si tienes una tabla de evaluaciones, cámbiala aquí. Si no, deja vacío.
    // evaluaciones = (response as List).map((e) => Evaluacion.fromMap(e)).toList();
    isLoading = false;
    notifyListeners();
  }
}