import 'dart:convert';

class Calificacion {
  final String id;
  final String idAsociado;
  final String idEmpresa;
  final int idDimension;
  final String comportamiento;
  final int puntaje;
  final DateTime fechaEvaluacion;
  final String? observaciones;
  final List<String> sistemas;
  final String? evidenciaUrl;

  Calificacion({
    required this.id,
    required this.idAsociado,
    required this.idEmpresa,
    required this.idDimension,
    required this.comportamiento,
    required this.puntaje,
    required this.fechaEvaluacion,
    this.observaciones,
    required this.sistemas,
    this.evidenciaUrl,
  });

  String get evaluacionId => id;

  factory Calificacion.fromMap(Map<String, dynamic> map) {
    List<String> sistemasDesdeMapa = [];
    if (map['sistemas'] is List) {
      sistemasDesdeMapa = List<String>.from(map['sistemas']);
    } else if (map['sistemas'] is String && (map['sistemas'] as String).isNotEmpty) {
      try {
        sistemasDesdeMapa = List<String>.from(jsonDecode(map['sistemas']));
      } catch (_) {
        sistemasDesdeMapa = [];
      }
    }

    return Calificacion(
      id: map['id']?.toString() ?? '',
      idAsociado: map['id_asociado']?.toString() ?? '',
      idEmpresa: map['id_empresa']?.toString() ?? '',
      idDimension: map['id_dimension'] is int ? map['id_dimension'] : int.tryParse(map['id_dimension']?.toString() ?? '0') ?? 0,
      comportamiento: map['comportamiento']?.toString() ?? '',
      puntaje: map['puntaje'] is int ? map['puntaje'] : int.tryParse(map['puntaje']?.toString() ?? '0') ?? 0,
      fechaEvaluacion: map['fecha_evaluacion'] != null ? DateTime.parse(map['fecha_evaluacion'].toString()) : DateTime.now(),
      observaciones: map['observaciones']?.toString(),
      sistemas: sistemasDesdeMapa,
      evidenciaUrl: map['evidencia_url']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_asociado': idAsociado,
      'id_empresa': idEmpresa,
      'id_dimension': idDimension,
      'comportamiento': comportamiento,
      'puntaje': puntaje,
      'fecha_evaluacion': fechaEvaluacion.toIso8601String(),
      'observaciones': observaciones,
      'sistemas': sistemas,
      'evidencia_url': evidenciaUrl,
    };
  }

  factory Calificacion.fromJson(String source) {
    return Calificacion.fromMap(json.decode(source) as Map<String, dynamic>);
  }

  String toJson() {
    return json.encode(toMap());
  }
}
