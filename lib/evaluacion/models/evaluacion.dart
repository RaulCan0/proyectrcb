import 'dart:convert';
class Evaluacion {
  static Evaluacion fromMapSafe(Map<String, dynamic> map) {
    return Evaluacion(
      id: map['id']?.toString() ?? '',
      empresaId: map['empresa_id']?.toString() ?? '',
      fecha: DateTime.parse(map['fecha']?.toString() ?? DateTime.now().toIso8601String()),
      asociadoId: map['asociado_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMapFull() {
    return {
      'id': id,
      'empresa_id': empresaId,
      'fecha': fecha.toIso8601String(),
      'asociado_id': asociadoId,
    };
  }

  factory Evaluacion.fromJson(String source) => Evaluacion.fromMapSafe(json.decode(source));
  String toJson() => json.encode(toMapFull());
  final String id;
  final String empresaId;
  final DateTime fecha;
  final String asociadoId;

  Evaluacion({
    required this.id,
    required this.empresaId,
    required this.fecha,
    required this.asociadoId,
  });

  factory Evaluacion.fromMap(Map<String, dynamic> map) {
    return Evaluacion(

      id: map['id'],
      empresaId: map['empresa_id'],
      fecha: DateTime.parse(map['fecha']),
      asociadoId: map['asociado_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'empresa_id': empresaId,
      'fecha': fecha.toIso8601String(),
    };
  }

  // Getter para dimension (simulación, ajustar según tu modelo real)
  String get dimension => 'dimension';
  // Getter para puntaje (simulación, ajustar según tu modelo real)
  double get puntaje => 0.0;
  // Getter para principio (simulación, ajustar según tu modelo real)
  String get principio => 'principio';
}
