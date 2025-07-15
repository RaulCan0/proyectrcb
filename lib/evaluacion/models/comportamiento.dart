class Comportamiento {
  static Comportamiento fromMap(Map<String, dynamic> map) {
    return Comportamiento(
      id: map['id']?.toString() ?? '',
      nombre: map['nombre']?.toString() ?? '',
      promedioEjecutivo: map['promedioEjecutivo'] is double
          ? map['promedioEjecutivo']
          : double.tryParse(map['promedioEjecutivo']?.toString() ?? '0') ?? 0.0,
      promedioGerente: map['promedioGerente'] is double
          ? map['promedioGerente']
          : double.tryParse(map['promedioGerente']?.toString() ?? '0') ?? 0.0,
      promedioMiembro: map['promedioMiembro'] is double
          ? map['promedioMiembro']
          : double.tryParse(map['promedioMiembro']?.toString() ?? '0') ?? 0.0,
      sistemas: (map['sistemas'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      nivel: map['nivel'],
      principioId: map['principioId']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'promedioEjecutivo': promedioEjecutivo,
      'promedioGerente': promedioGerente,
      'promedioMiembro': promedioMiembro,
      'sistemas': sistemas,
      'nivel': nivel,
      'principioId': principioId,
    };
  }

  final String id;
  String nombre;
  final double promedioEjecutivo;
  final double promedioGerente;
  final double promedioMiembro;
  final List<String> sistemas;
  final dynamic nivel;
  final String principioId;

  Comportamiento({
    required this.id,
    required this.nombre,
    required this.promedioEjecutivo,
    required this.promedioGerente,
    required this.promedioMiembro,
    required this.sistemas,
    required this.nivel,
    required this.principioId,
  });
}
