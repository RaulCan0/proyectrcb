import 'dart:convert';

class Empresa {
  final String id;
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
    required this.nombre,
    required this.tamano,
    required this.empleadosTotal,
    required this.empleadosAsociados,
    required this.unidades,
    required this.areas,
    required this.sector,
    required this.createdAt,
  });

  factory Empresa.fromMap(Map<String, dynamic> map) {
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

  Map<String, dynamic> toMap() => {
        'id': id,
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
