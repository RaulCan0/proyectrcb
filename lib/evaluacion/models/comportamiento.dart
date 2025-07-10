class Comportamiento {
  String nombre;
  final double promedioEjecutivo;
  final double promedioGerente;
  final double promedioMiembro;

  Comportamiento({
    required this.nombre,
    required this.promedioEjecutivo,
    required this.promedioGerente,
    required this.promedioMiembro, required List<String> sistemasasociados, required String cargo, required String principioId, required String id,
  });
}
