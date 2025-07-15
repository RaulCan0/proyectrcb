import 'dart:convert';

/// Modelo Asociado: compatible con Supabase y serialización completa
class Asociado {
  final String id;
  final String nombre;
  final String cargo;
  final String empresa;
  final List<String> empleadosAsociados;
  final Map<String, double> progresoDimensiones;
  final Map<String, dynamic> comportamientosEvaluados;
  final int antiguedad;

  Asociado({
    required this.id,
    required this.nombre,
    required this.cargo,
    required this.empresa,
    required this.empleadosAsociados,
    required this.progresoDimensiones,
    required this.comportamientosEvaluados,
    required this.antiguedad,
  });

  /// Convierte un Map en una instancia de Asociado
  static Asociado fromMap(Map<String, dynamic> map) {
    return Asociado(
      id: map['id']?.toString() ?? '',
      nombre: map['nombre']?.toString() ?? '',
      cargo: map['cargo']?.toString() ?? '',
      empresa: map['empresa_id']?.toString() ?? '',
      empleadosAsociados: map['empleados_asociados'] is String
          ? List<String>.from(jsonDecode(map['empleados_asociados']))
          : List<String>.from(map['empleados_asociados'] ?? []),
      progresoDimensiones: map['progreso_dimensiones'] is String
          ? Map<String, double>.from(jsonDecode(map['progreso_dimensiones']))
          : Map<String, double>.from(map['progreso_dimensiones'] ?? {}),
      comportamientosEvaluados: map['comportamientos_evaluados'] is String
          ? Map<String, dynamic>.from(jsonDecode(map['comportamientos_evaluados']))
          : Map<String, dynamic>.from(map['comportamientos_evaluados'] ?? {}),
      antiguedad: map['antiguedad'] is int ? map['antiguedad'] : int.tryParse(map['antiguedad']?.toString() ?? '0') ?? 0,
    );
  }

  /// Convierte una instancia de Asociado en Map compatible con Supabase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'cargo': cargo,
      'empresa_id': empresa,
      'empleados_asociados': jsonEncode(empleadosAsociados),
      'progreso_dimensiones': jsonEncode(progresoDimensiones),
      'comportamientos_evaluados': jsonEncode(comportamientosEvaluados),
      'antiguedad': antiguedad,
    };
  }

  /// Convierte un String JSON en una instancia de Asociado
  factory Asociado.fromJson(String source) => Asociado.fromMap(json.decode(source));

  /// Convierte una instancia de Asociado en String JSON
  String toJson() => json.encode(toMap());

  /// Limpia el progreso del asociado
  void limpiarProgreso() {
    progresoDimensiones.clear();
    comportamientosEvaluados.clear();
  }
}
