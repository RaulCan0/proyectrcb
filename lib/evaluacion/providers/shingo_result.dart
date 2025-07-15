import 'dart:io';

class ShingoResultModel {
  Map<String, String> campos;
  File? imagenGrafico;
  int calificacion;

  ShingoResultModel({
    required this.campos,
    required this.imagenGrafico,
    required this.calificacion,
  });
}
// Este archivo ya no es un Provider, solo modelo/servicio.
