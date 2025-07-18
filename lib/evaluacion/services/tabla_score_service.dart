

import 'package:lensysapp/evaluacion/models/calificacion.dart';

import '../models/empresa.dart';
import '../models/evaluacion.dart';
import 'shingo_result_service.dart';
import '../models/score_cargo.dart';

class ScoreGlobalService { 
  final ShingoResultService shingoResultService = ShingoResultService();

  /// Calcula y llena automáticamente la primera parte de ScoreGlobal.
  /// Si ya existe, actualiza sólo la parte automática.
  Future<ScoreGlobal> fillAutomatic(
    Empresa empresa,
    List<Calificacion> calificaciones,
    List<Evaluacion> evaluaciones,
  ) async {
    // Filtrar calificaciones de la empresa
    final calificacionesEmpresa = calificaciones.where((e) => e.idEmpresa == empresa.id).toList();

    // Secciones y pesos como en tu UI
    const sections = [
      {
        'label': 'Impulsores Culturales (250 pts)',
        'comps': ['EJECUTIVOS', 'GERENTES', 'MIEMBROS DE EQUIPO'],
        'puntos': [125, 75, 50],
      },
      {
        'label': 'Mejora Continua (350 pts)',
        'comps': ['EJECUTIVOS', 'GERENTES', 'MIEMBROS DE EQUIPO'],
        'puntos': [70, 105, 175],
      },
      {
        'label': 'Alineamiento Empresarial (200 pts)',
        'comps': ['EJECUTIVOS', 'GERENTES', 'MIEMBROS DE EQUIPO'],
        'puntos': [110, 60, 30],
      },
    ];

    List<ScoreCargo> scorePorCargo = [];

    // Para cada sección y cada cargo (Ejecutivo, Gerente, Miembro)
    for (var sec in sections) {
      final comps = sec['comps'] as List<String>;
      final puntos = sec['puntos'] as List<int>;
      for (int i = 0; i < comps.length; i++) {
        final cargo = comps[i];
        final detallesCargo = calificacionesEmpresa.where((d) => d.cargo == cargo).toList();
        int puntosObtenidos = detallesCargo.fold(0, (sum, d) => sum + (d.puntaje ?? 0));
        int puntosPosibles = detallesCargo.length * 5;
        double porcentaje = puntosPosibles > 0 ? (puntosObtenidos / puntosPosibles) * 100 : 0.0;
        int peso = puntos[i];
        int puntosObtenidosPonderados = ((puntosObtenidos / (puntosPosibles > 0 ? puntosPosibles : 1)) * peso).round();
        scorePorCargo.add(ScoreCargo(
          cargo: cargo,
          puntosObtenidos: puntosObtenidosPonderados,
          puntosPosibles: peso,
          porcentaje: porcentaje,
        ));
      }
    }

    final scoreGlobal = ScoreGlobal(
      empresaId: empresa.id,
      scorePorCargo: scorePorCargo,
      // Los campos de shingo se llenan después
    );
    return scoreGlobal;
  }

  /// Llenar la segunda parte (Shingo) después, cuando esté disponible:
  Future<void> fillShingoPart(ScoreGlobal scoreGlobal, Map<String, int> shingoResults) async {
    scoreGlobal.shingoResults = shingoResults;
    // Cálculo de puntos Shingo: cada slider (0-5) * 40pts
    int totalShingo = 0;
    shingoResults.forEach((key, value) {
      totalShingo += (value.clamp(0, 5)) * 40;
    });
    scoreGlobal.totalShingo = totalShingo;
    // Persistir scoreGlobal en Supabase o backend si es necesario
    // Ejemplo básico usando Supabase (ajusta según tu modelo y tabla):
    // await Supabase.instance.client.from('score_global').upsert(scoreGlobal.toMap());
    // Si no usas Supabase, implementa aquí la lógica de guardado en tu backend
  }
}

class ScoreGlobal {
  final String empresaId;
  final List<ScoreCargo> scorePorCargo;
  Map<String, int>? shingoResults;
  int totalShingo;

  ScoreGlobal({
    required this.empresaId,
    required this.scorePorCargo,
    this.shingoResults,
    this.totalShingo = 0,
  });
}