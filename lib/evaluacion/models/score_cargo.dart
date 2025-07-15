import 'dart:convert';
class ScoreCargo {
  // Renamed static method to avoid conflict with factory constructor
  static ScoreCargo fromMapStatic(Map<String, dynamic> map) {
    return ScoreCargo(
      cargo: map['cargo'] is int ? map['cargo'] : int.tryParse(map['cargo']?.toString() ?? '0') ?? 0,
      puntosObtenidos: map['puntos_obtenidos'] is int ? map['puntos_obtenidos'] : int.tryParse(map['puntos_obtenidos']?.toString() ?? '0') ?? 0,
      puntosPosibles: map['puntos_posibles'] is int ? map['puntos_posibles'] : int.tryParse(map['puntos_posibles']?.toString() ?? '0') ?? 0,
      porcentaje: map['porcentaje'] is double ? map['porcentaje'] : double.tryParse(map['porcentaje']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cargo': cargo,
      'puntos_obtenidos': puntosObtenidos,
      'puntos_posibles': puntosPosibles,
      'porcentaje': porcentaje,
    };
  }

  factory ScoreCargo.fromMap(Map<String, dynamic> map) {
    return ScoreCargo(
      cargo: map['cargo'] is int ? map['cargo'] : int.tryParse(map['cargo']?.toString() ?? '0') ?? 0,
      puntosObtenidos: map['puntos_obtenidos'] is int ? map['puntos_obtenidos'] : int.tryParse(map['puntos_obtenidos']?.toString() ?? '0') ?? 0,
      puntosPosibles: map['puntos_posibles'] is int ? map['puntos_posibles'] : int.tryParse(map['puntos_posibles']?.toString() ?? '0') ?? 0,
      porcentaje: map['porcentaje'] is double ? map['porcentaje'] : double.tryParse(map['porcentaje']?.toString() ?? '0') ?? 0.0,
    );
  }

  factory ScoreCargo.fromJson(String source) => ScoreCargo.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());

  final int cargo;                  // 1=Ejecutivo,2=Gerente,3=Miembro
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