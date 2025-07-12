import 'package:flutter_test/flutter_test.dart';
import 'package:lensysapp/evaluacion/models/evaluacion.dart';
import 'package:lensysapp/evaluacion/models/empresa.dart';
import 'package:lensysapp/evaluacion/models/asociado.dart';

// ignore: unused_element
dynamic _parseEmpleadosAsociados(dynamic value) {
  if (value is String) {
    return List<String>.from((value.isNotEmpty ? (value.startsWith('[') ? (value.length > 2 ? value.substring(1, value.length - 1).split(',').map((e) => e.replaceAll('"', '').trim()).toList() : []) : [value]) : []));
  }
  if (value is List) return value;
  return [];
}

void main() {
  group('Evaluacion model', () {
    test('fromMap y toMap funcionan correctamente', () {
      final map = {
        'id': 'e1',
        'empresa_id': 'emp1',
        'asociado_id': 'a1',
        'fecha': '2024-05-01T12:00:00.000',
      };
      final evaluacion = Evaluacion.fromMap(map);
      expect(evaluacion.id, 'e1');
      expect(evaluacion.empresaId, 'emp1');
      expect(evaluacion.asociadoId, 'a1');
      expect(evaluacion.fecha, DateTime.parse('2024-05-01T12:00:00.000'));

      final toMap = evaluacion.toMap();
      expect(toMap['id'], 'e1');
      expect(toMap['empresa_id'], 'emp1');
      expect(toMap['asociado_id'], 'a1');
      expect(toMap['fecha'], '2024-05-01T12:00:00.000');
    });
  });

  group('Empresa model', () {
    test('fromMap y toMap funcionan correctamente', () {
      final map = {
        'id': 'emp1',
        'nombre': 'Empresa S.A.',
        'tamano': 'Grande',
        'empleados_total': 100,
        'empleados_asociados': '["a1", "a2"]',
        'unidades': 'Unidad 1',
        'areas': 3,
        'sector': 'Industrial',
        'created_at': '2024-05-01T12:00:00.000',
      };

      final empresa = Empresa.fromMap(map);
      expect(empresa.id, 'emp1');
      expect(empresa.nombre, 'Empresa S.A.');
      expect(empresa.tamano, 'Grande');
      expect(empresa.empleadosTotal, 100);
      expect(empresa.empleadosAsociados, ['a1', 'a2']);
      expect(empresa.unidades, 'Unidad 1');
      expect(empresa.areas, 3);
      expect(empresa.sector, 'Industrial');
      expect(empresa.createdAt, DateTime.parse('2024-05-01T12:00:00.000'));

      final toMap = empresa.toMap();
      expect(toMap['id'], 'emp1');
      expect(toMap['nombre'], 'Empresa S.A.');
    });
  });

  group('Asociado model', () {
    test('fromMap y toMap funcionan correctamente', () {
      final map = {
        'id': 'a1',
        'nombre': 'Juan Perez',
        'cargo': 'Gerente',
        'antiguedad': 5,
        'dimension_id': 'd1',
        'empresa_id': 'emp1',
        'empleados_asociados': [],
        'progreso_dimensiones': {},
        'comportamientos_evaluados': {},
      };

      final asociado = Asociado.fromMap(map);
      expect(asociado.id, 'a1');
      expect(asociado.nombre, 'Juan Perez');
      expect(asociado.cargo, 'Gerente');
      expect(asociado.antiguedad, 5);
      expect(asociado.empresaId, 'emp1');

      final toMap = asociado.toMap();
      expect(toMap['id'], 'a1');
      expect(toMap['nombre'], 'Juan Perez');
    });
  });
}