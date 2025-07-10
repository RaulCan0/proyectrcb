import 'dart:convert';

class Empresa {
  final String id;
  final String nombre;
  final String tamano;
  final int empleadosTotal;
  final List<dynamic> empleadosAsociados;
  final String unidades;
  final int areas;
  final String sector;
  final DateTime? createdAt;

  Empresa({
    required this.id,
    required this.nombre,
    required this.tamano,
    required this.empleadosTotal,
    required this.empleadosAsociados,
    required this.unidades,
    required this.areas,
    required this.sector,
    this.createdAt,
  });

  factory Empresa.fromMap(Map<String, dynamic> map) {
    return Empresa(
      id: map['id'] as String,
      nombre: map['nombre'] as String,
      tamano: map['tamano'] as String,
      empleadosTotal: map['empleados_total'] as int,
      empleadosAsociados: map['empleados_asociados'] is String
          ? jsonDecode(map['empleados_asociados'])
          : (map['empleados_asociados'] ?? []),
      unidades: map['unidades'] as String,
      areas: map['areas'] as int,
      sector: map['sector'] as String,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
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
        'created_at': createdAt?.toIso8601String(),
      };
}
