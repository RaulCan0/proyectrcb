import 'dart:convert';

class SistemaAsociado {
  final String id;
  final String nombre;

  SistemaAsociado({
    required this.id,
    required this.nombre,
  });

  // Named constructor for creating an instance from a map
  factory SistemaAsociado.fromMap(Map<String, dynamic> map) {
    return SistemaAsociado(
      id: map['id']?.toString() ?? '',
      nombre: map['nombre']?.toString() ?? '',
    );
  }

  // Convert instance to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }

  // Named constructor for creating an instance from JSON string
  factory SistemaAsociado.fromJson(String source) =>
      SistemaAsociado.fromMap(json.decode(source));

  // Convert instance to JSON string
  String toJson() => json.encode(toMap());

  // Optional: copyWith method for immutability
  SistemaAsociado copyWith({
    String? id,
    String? nombre,
  }) {
    return SistemaAsociado(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SistemaAsociado &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nombre == other.nombre;

  @override
  int get hashCode => id.hashCode ^ nombre.hashCode;

  @override
  String toString() {
    return 'SistemaAsociado{id: $id, nombre: $nombre}';
  }
}
