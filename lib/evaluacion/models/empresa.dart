
import 'dart:convert';

class Empresa {
  static Empresa fromMap(Map<String, dynamic> map) {
    List<String> asociados = [];
    if (map['empleados_asociados'] is List) {
      asociados = List<String>.from(map['empleados_asociados']);
    } else if (map['empleados_asociados'] is String && map['empleados_asociados'].isNotEmpty) {
      try {
        asociados = List<String>.from(jsonDecode(map['empleados_asociados']));
      } catch (_) {
        asociados = [];
      }
    }
    return Empresa(
      id: map['id']?.toString() ?? '',
      evaluacionid: map['evaluacionid']?.toString() ?? '',
      nombre: map['nombre']?.toString() ?? '',
      tamano: map['tamano']?.toString() ?? '',
      empleadosTotal: map['empleados_total'] is int ? map['empleados_total'] : int.tryParse(map['empleados_total']?.toString() ?? '0') ?? 0,
      empleadosAsociados: asociados,
      unidades: map['unidades']?.toString() ?? '',
      areas: map['areas'] is int ? map['areas'] : int.tryParse(map['areas']?.toString() ?? '0') ?? 0,
      sector: map['sector']?.toString() ?? '',
      createdAt: DateTime.parse(map['created_at']?.toString() ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'evaluacionid': evaluacionid,
      'nombre': nombre,
      'tamano': tamano,
      'empleados_total': empleadosTotal,
      'empleados_asociados': jsonEncode(empleadosAsociados),
      'unidades': unidades,
      'areas': areas,
      'sector': sector,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Empresa.fromJsonFactory(String source) => Empresa.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
  final String id;
  final String evaluacionid;
  final String nombre;
  final String tamano;
  final int empleadosTotal;
  final List<String> empleadosAsociados;
  final String unidades;
  final int areas;
  final String sector;
  final DateTime createdAt;

  Empresa({
    required this.id,
    required this.evaluacionid,
    required this.nombre,
    required this.tamano,
    required this.empleadosTotal,
    required this.empleadosAsociados,
    required this.unidades,
    required this.areas,
    required this.sector,
    required this.createdAt,
  });

  // Mapeador: convierte un Map en una instancia de Empresa (alternativo)
  static Empresa fromMapAlt(Map<String, dynamic> map) {
    List<String> asociados = [];
    if (map['empleados_asociados'] is List) {
      asociados = List<String>.from(map['empleados_asociados']);
    } else if (map['empleados_asociados'] is String && map['empleados_asociados'].isNotEmpty) {
      try {
        asociados = List<String>.from(jsonDecode(map['empleados_asociados']));
      } catch (_) {
        asociados = [];
      }
    }
    return Empresa(
      id: map['id']?.toString() ?? '',
      evaluacionid: map['id_evaluacion']?.toString() ?? '',
      nombre: map['nombre']?.toString() ?? '',
      tamano: map['tamano']?.toString() ?? '',
      empleadosTotal: map['empleados_total'] is int ? map['empleados_total'] : int.tryParse(map['empleados_total']?.toString() ?? '0') ?? 0,
      empleadosAsociados: asociados,
      unidades: map['unidades']?.toString() ?? '',
      areas: map['areas'] is int ? map['areas'] : int.tryParse(map['areas']?.toString() ?? '0') ?? 0,
      sector: map['sector']?.toString() ?? '',
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at'].toString()) : DateTime.now(),
    );
  }

  // Mapeador: convierte una instancia de Empresa en Map (alternativo)
  Map<String, dynamic> toMapAlt() {
    return {
      'id': id,
      'id_evaluacion': evaluacionid,
      'nombre': nombre,
      'tamano': tamano,
      'empleados_total': empleadosTotal,
      'empleados_asociados': jsonEncode(empleadosAsociados),
      'unidades': unidades,
      'areas': areas,
      'sector': sector,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Mapeador: convierte un String JSON en una instancia de Empresa
  static Empresa fromJson(String source) => fromMap(json.decode(source) as Map<String, dynamic>);

  // Mapeador: convierte una instancia de Empresa en String JSON (alternativo)
  String toJsonAlt() => json.encode(toMapAlt());
}