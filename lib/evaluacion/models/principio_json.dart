class PrincipioJson {
  final String nombre;
  final String benchmarkComportamiento;
  final String benchmarkPorCargo;
  final String cargo;
  final String preguntas;
  final Map<String, String> calificaciones;

  PrincipioJson({
    required this.nombre,
    required this.benchmarkComportamiento,
    required this.benchmarkPorCargo,
    required this.cargo,
    required this.preguntas,
    required this.calificaciones,
  });

  factory PrincipioJson.fromJson(Map<String, dynamic> json) {
    return PrincipioJson(
      nombre: json['PRINCIPIOS'] ?? '',
      benchmarkComportamiento: json['BENCHMARK DE COMPORTAMIENTOS'] ?? '',
      benchmarkPorCargo: json['BENCHMARK POR CARGO'] ?? '',
      cargo: json['CARGO'] ?? '',
      preguntas: json['GUÍA DE PREGUNTAS'] ?? '',
      calificaciones: {
        'C1': json['C1'] ?? '',
        'C2': json['C2'] ?? '',
        'C3': json['C3'] ?? '',
        'C4': json['C4'] ?? '',
        'C5': json['C5'] ?? '',
      },
    );
  }
}
