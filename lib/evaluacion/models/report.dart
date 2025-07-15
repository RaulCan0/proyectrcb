class ReportJson {
  final String nombre;
  final String benchmarkComportamiento;
  final String benchmarkPorCargo;
  final String cargo;
  final String preguntas;
  final Map<String, String> calificaciones;
  final List<String> comportamientos;

  ReportJson({
    required this.nombre,
    required this.benchmarkComportamiento,
    required this.benchmarkPorCargo,
    required this.cargo,
    required this.preguntas,
    required this.calificaciones,
    required this.comportamientos,
  });

  factory ReportJson.fromJson(Map<String, dynamic> json) {
    return ReportJson(
      nombre: json['COMPORTAMIENTO'] ?? '',
      benchmarkComportamiento: json['BENCHMARK'] ?? '',
      benchmarkPorCargo: json['BENCHMARK POR CARGO'] ?? '',
      cargo: json['CARGO'] ?? '',
      preguntas: json['GUÍA DE PREGUNTAS'] ?? '',
      calificaciones: {
      'C1': json['C1'] ?? '',
      'C2': json['C2'] ?? '',
      'C3': json['C3'] ?? '',
      'C4': json['C4'] ?? '',
      'C5': json['C5'] ?? '',
      'CARGO': json['CARGO'] ?? '',
      'BENCHMARK POR CARGO': json['BENCHMARK POR CARGO'] ?? '',
      },
      comportamientos: json['comportamientos'] != null
        ? List<String>.from(json['comportamientos'])
        : [],
    );
  }
}
 