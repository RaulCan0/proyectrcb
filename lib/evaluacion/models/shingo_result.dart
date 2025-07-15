import 'dart:convert';
import 'dart:io';

class ShingoResultModel {
  static ShingoResultModel fromMap(Map<String, dynamic> map) {
    return ShingoResultModel(
      campos: Map<String, String>.from(map['campos'] ?? {}),
      imagenGrafico: null,
      calificacion: map['calificacion'] is int ? map['calificacion'] : int.tryParse(map['calificacion']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'campos': campos,
      'calificacion': calificacion,
    };
  }

  factory ShingoResultModel.fromJson(String source) => ShingoResultModel.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());

  Map<String, String> campos;
  File? imagenGrafico;
  int calificacion;

  ShingoResultModel({
    required this.campos,
    required this.imagenGrafico,
    required this.calificacion,
  });
}
