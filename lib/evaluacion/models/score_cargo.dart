class ScoreCargo {
  final String cargo;                  // Cargo del evaluado
  final int puntosObtenidos;
  final int puntosPosibles;
  final double porcentaje;          // 0–100

  ScoreCargo({
    required this.cargo,
    required this.puntosObtenidos,
    required this.puntosPosibles,
    required this.porcentaje,
  });
}