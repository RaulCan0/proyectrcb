import 'dart:convert';

class Calificacion {
  final String id;
  final String idAsociado;
  final String idEmpresa;
  final int? idDimension;
  final String comportamiento;
  final int? puntaje;
  final DateTime? fechaEvaluacion;
  final String? observaciones;
  final String? sistemas;
  final String? evidenciaUrl;

  Calificacion({
    required this.id,
    required this.idAsociado,
    required this.idEmpresa,
    this.idDimension,
    required this.comportamiento,
    this.puntaje,
    this.fechaEvaluacion,
    this.observaciones,
    this.sistemas,
    this.evidenciaUrl,
  });

  factory Calificacion.fromMap(Map<String, dynamic> map) {
    return Calificacion(
      id: map['id'] as String,
      idAsociado: map['id_asociado'] as String,
      idEmpresa: map['id_empresa'] as String,
      idDimension: map['id_dimension'] != null ? int.tryParse(map['id_dimension'].toString()) : null,
      comportamiento: map['comportamiento'] as String,
      puntaje: map['puntaje'] != null ? int.tryParse(map['puntaje'].toString()) : null,
      fechaEvaluacion: map['fecha_evaluacion'] != null ? DateTime.tryParse(map['fecha_evaluacion']) : null,
      observaciones: map['observaciones'] as String?,
      sistemas: map['sistemas'] as String?,
      evidenciaUrl: map['evidencia_url'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'id_asociado': idAsociado,
        'id_empresa': idEmpresa,
        'id_dimension': idDimension,
        'comportamiento': comportamiento,
        'puntaje': puntaje,
        'fecha_evaluacion': fechaEvaluacion?.toIso8601String(),
        'observaciones': observaciones,
        'sistemas': sistemas,
        'evidencia_url': evidenciaUrl,
      };

  factory Calificacion.fromJson(String source) {
    return Calificacion.fromMap(json.decode(source) as Map<String, dynamic>);
  }

  String toJson() {
    return json.encode(toMap());
  }
}
