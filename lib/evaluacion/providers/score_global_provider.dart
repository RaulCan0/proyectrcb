import 'package:flutter/material.dart';
import 'package:lensysapp/evaluacion/models/score_cargo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/empresa.dart';
import '../services/tabla_score_service.dart';

class ScoreGlobalProvider with ChangeNotifier {
  final _client = Supabase.instance.client;

  ScoreGlobal? _scoreGlobal;
  ScoreGlobal? get scoreGlobal => _scoreGlobal;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Stream<ScoreGlobal?>? _scoreStream;
  Stream<ScoreGlobal?>? get scoreStream => _scoreStream;

  void listenScore(Empresa empresa) {
    _isLoading = true;
    notifyListeners();
    _scoreStream = _client
        .from('calificacion')
        .stream(primaryKey: ['id'])
        .eq('empresa_id', empresa.id)
        .map((event) {
      // --- Lógica de cálculo ---
      const pesos = {
        'Impulsores Culturales': [125, 75, 50],
        'Mejora Continua': [70, 105, 175],
        'Alineamiento Empresarial': [110, 60, 30],
      };
      final Map<int, List<Map<String, dynamic>>> porCargo = {1: [], 2: [], 3: []};
      for (final entry in event) {
        final cargo = entry['cargo'];
        if (porCargo.containsKey(cargo)) {
          porCargo[cargo]!.add(entry);
        }
      }
      List<ScoreCargo> scores = [];
      for (final dimension in pesos.keys) {
        final peso = pesos[dimension]!;
        for (int cargo = 1; cargo <= 3; cargo++) {
          final califs = porCargo[cargo]!
              .where((c) => c['dimension'] == dimension)
              .toList();
          final puntosObtenidos =
              califs.fold<int>(0, (sum, e) => sum + (e['puntaje'] ?? 0) as int);
          final puntosPosibles = califs.length * 5;
          final porcentaje = puntosPosibles > 0
              ? (puntosObtenidos / puntosPosibles) * 100
              : 0.0;
          final ponderado = ((porcentaje / 100) * peso[cargo - 1]).round();
          scores.add(ScoreCargo(
            cargo: cargo,
            puntosObtenidos: ponderado,
            puntosPosibles: peso[cargo - 1],
            porcentaje: porcentaje,
          ));
        }
      }
      return ScoreGlobal(empresaId: empresa.id, scorePorCargo: scores);
    });
    _scoreStream!.listen((score) {
      _scoreGlobal = score;
      _isLoading = false;
      notifyListeners();
    });
  }
}