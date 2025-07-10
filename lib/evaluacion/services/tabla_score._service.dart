import 'package:lensysapp/evaluacion/models/detalle_evaluacion.dart';
import 'package:lensysapp/evaluacion/models/score_level.dart';

import '../models/empresa.dart';
import '../models/evaluacion.dart';
import 'shingo_result_service.dart';

class ScoreGlobalService {
  final ShingoResultService shingoResultService = ShingoResultService();

  /// Calcula y llena automáticamente la primera parte de ScoreGlobal.
  /// Si ya existe, actualiza sólo la parte automática.
  Future<ScoreGlobal> fillAutomatic(
    Empresa empresa,
    List<DetalleEvaluacion> detalles,
    List<Evaluacion> evaluaciones,
  ) async {
    // Filtrar detalles de la empresa
    final detallesEmpresa = detalles.where((d) =>
      evaluaciones.any((e) => e.id == d.evaluacionId && e.empresaId == empresa.id)
    ).toList();

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

    List<ScoreNivel> scorePorNivel = [];

    // Para cada sección y cada nivel (1=Ejecutivo, 2=Gerente, 3=Miembro)
    for (var sec in sections) {
      // ignore: unused_local_variable
      final comps = sec['comps'] as List<String>;
      final puntos = sec['puntos'] as List<int>;
      for (int nivel = 1; nivel <= 3; nivel++) {
        // Filtrar detalles de este nivel
        final detallesNivel = detallesEmpresa.where((d) => d.nivel == nivel).toList();
        // Sumar calificaciones (asumiendo escala 1-5)
        int puntosObtenidos = detallesNivel.fold(0, (sum, d) => sum + d.calificacion);
        int puntosPosibles = detallesNivel.length * 5;
        double porcentaje = puntosPosibles > 0 ? (puntosObtenidos / puntosPosibles) * 100 : 0.0;
        // Multiplicar por el peso de la sección para este nivel
        int peso = puntos[nivel - 1];
        int puntosObtenidosPonderados = ((puntosObtenidos / (puntosPosibles > 0 ? puntosPosibles : 1)) * peso).round();
        scorePorNivel.add(ScoreNivel(
          nivel: nivel,
          puntosObtenidos: puntosObtenidosPonderados,
          puntosPosibles: peso,
          porcentaje: porcentaje,
        ));
      }
    }

    final scoreGlobal = ScoreGlobal(
      empresaId: empresa.id,
      scorePorNivel: scorePorNivel,
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
  final List<ScoreNivel> scorePorNivel;
  Map<String, int>? shingoResults;
  int totalShingo;

  ScoreGlobal({
    required this.empresaId,
    required this.scorePorNivel,
    this.shingoResults,
    this.totalShingo = 0,
  });
}