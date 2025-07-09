import 'package:flutter/material.dart';

class TablasPrincipiosWidget extends StatelessWidget {
  final List<Map<String, dynamic>> dimensiones;

  const TablasPrincipiosWidget({super.key, required this.dimensiones});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Principio')),
          DataColumn(label: Text('Comportamiento')),
          DataColumn(label: Text('Ejecutivos')),
          DataColumn(label: Text('Sistemas Ejecutivos')),
          DataColumn(label: Text('Observaciones Ejecutivos')),
          DataColumn(label: Text('Gerentes')),
          DataColumn(label: Text('Sistemas Gerentes')),
          DataColumn(label: Text('Observaciones Gerentes')),
          DataColumn(label: Text('Miembro de equipo')),
          DataColumn(label: Text('Sistemas miembro de equipo')),
          DataColumn(label: Text('Observaciones miembro de equipo')),
        ],
        rows: _generarFilas(),
      ),
    );
  }

  List<DataRow> _generarFilas() {
    final List<DataRow> rows = [];

    for (var dimension in dimensiones) {
      final principios = dimension['principios'] as List<dynamic>;

      for (var principio in principios) {
        final nombrePrincipio = principio['nombre'];
        final comportamientos = principio['comportamientos'] as List<dynamic>;

        for (var comportamiento in comportamientos) {
          rows.add(DataRow(cells: [
            DataCell(Text(nombrePrincipio)),
            DataCell(Text(comportamiento)),
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text('')),
          ]));
        }
      }
    }

    return rows;
  }
}
