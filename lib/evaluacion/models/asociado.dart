

class Asociado {
  final String id;
  final String nombre;
  final String cargo;
  final int antiguedad;
  final String dimensionId;
  final String empresaId;

  Asociado({
    required this.id,
    required this.nombre,
    required this.cargo,
    required this.antiguedad,
    required this.dimensionId,
    required this.empresaId,
  });

  factory Asociado.fromMap(Map<String, dynamic> map) {
    return Asociado(
      id: map['id'] as String,
      nombre: map['nombre'] as String,
      cargo: map['cargo'] as String,
      antiguedad: map['antiguedad'] is int ? map['antiguedad'] : int.parse(map['antiguedad'].toString()),
      dimensionId: map['dimension_id'] as String,
      empresaId: map['empresa_id'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'nombre': nombre,
        'cargo': cargo,
        'antiguedad': antiguedad,
        'dimension_id': dimensionId,
        'empresa_id': empresaId,
      };
}
