import 'package:lensysapp/evaluacion/screens/tablas_screen.dart';
import '../models/empresa.dart';
import '../models/evaluacion.dart';
import '../models/score_cargo.dart';
import 'shingo_result_service.dart';

class ScoreGlobalService {
  final ShingoResultService shingoResultService = ShingoResultService();

  /// Calcula y llena automáticamente la primera parte de ScoreGlobal usando la estructura local de TablasDimensionScreen.tablaDatos.
  Future<ScoreGlobal> fillAutomatic(
    Empresa empresa,
    List<Evaluacion> evaluaciones,
  ) async {
    // Obtener todos los datos de la empresa desde tablaDatos
    final tablaDatos = TablasDimensionScreen.tablaDatos;
    List<Map<String, dynamic>> detallesEmpresa = [];
    for (var dimension in tablaDatos.values) {
      for (var lista in dimension.values) {
        detallesEmpresa.addAll(lista.where((d) => d['empresa_id'] == empresa.id));
      }
    }

    // Secciones y pesos como en tu UI
    const sections = [
      {
        'label': 'Impulsores Culturales (250 pts)',
        'cargos': ['EJECUTIVOS', 'GERENTES', 'MIEMBROS DE EQUIPO'],
        'puntos': [125, 75, 50],
      },
      {
        'label': 'Mejora Continua (350 pts)',
        'cargos': ['EJECUTIVOS', 'GERENTES', 'MIEMBROS DE EQUIPO'],
        'puntos': [70, 105, 175],
      },
      {
        'label': 'Alineamiento Empresarial (200 pts)',
        'coargos': ['EJECUTIVOS', 'GERENTES', 'MIEMBROS DE EQUIPO'],
        'puntos': [110, 60, 30],
      },
    ];

    List<ScoreCargo> scorePorCargo = [];

    // Para cada sección y cada nivel (1=Ejecutivo, 2=Gerente, 3=Miembro)
    for (var sec in sections) {
      // ignore: unused_local_variable
      final comps = sec['comps'] as List<String>;
      final puntos = sec['puntos'] as List<int>;
      for (int cargo = 1; cargo <= 3; cargo++) {
        // Filtrar detalles de este nivel
        final detallesCargo = detallesEmpresa.where((d) => d['cargo'] == cargo).toList();
        int puntosObtenidos = detallesCargo.fold(0, (sum, d) => sum + ((d['valor'] ?? 0) as int));
        int puntosPosibles = detallesCargo.length * 5;
        double porcentaje = puntosPosibles > 0 ? (puntosObtenidos / puntosPosibles) * 100 : 0.0;
        int peso = puntos[cargo - 1];
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
    int totalShingo = 0;
    shingoResults.forEach((key, value) {
      totalShingo += (value.clamp(0, 5)) * 40;
    });
    scoreGlobal.totalShingo = totalShingo;
    // Si necesitas persistir, implementa aquí la lógica de guardado
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