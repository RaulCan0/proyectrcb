import 'package:flutter/material.dart';

class TablaScoreGlobal extends StatelessWidget {
  const TablaScoreGlobal({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo para la UI
    const sections = [
      {
        'label': 'Impulsores Culturales (250 pts)',
        'comps': ['EJECUTIVOS', 'GERENTES', 'MIEMBROS DE EQUIPO'],
        'compsText': ['EJECUTIVOS 50%', 'GERENTES 30%', 'MIEMBROS DE EQUIPO 20%'],
        'puntos': ['125', '75', '50'],
      },
      {
        'label': 'Mejora Continua (350 pts)',
        'comps': ['EJECUTIVOS', 'GERENTES', 'MIEMBROS DE EQUIPO'],
        'compsText': ['EJECUTIVOS 20%', 'GERENTES 30%', 'MIEMBROS DE EQUIPO 50%'],
        'puntos': ['70', '105', '175'],
      },
      {
        'label': 'Alineamiento Empresarial (200 pts)',
        'comps': ['EJECUTIVOS', 'GERENTES', 'MIEMBROS DE EQUIPO'],
        'compsText': ['EJECUTIVOS 55%', 'GERENTES 30%', 'MIEMBROS DE EQUIPO 15%'],
        'puntos': ['110', '60', '30'],
      },
    ];

    final rows = <DataRow>[];
    for (var sec in sections) {
      final label = sec['label'] as String;
      final comps = sec['comps'] as List<String>;
      final puntos = (sec['puntos'] as List<String>);
      rows.add(DataRow(
        color: WidgetStateProperty.all(const Color(0xFF003056)),
        cells: [
          DataCell(Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
          DataCell(Text(comps[0], style: const TextStyle(color: Colors.white))),
          DataCell(Text(comps[1], style: const TextStyle(color: Colors.white))),
          DataCell(Text(comps[2], style: const TextStyle(color: Colors.white))),
        ],
      ));
      rows.add(DataRow(
        color: WidgetStateProperty.all(Colors.grey.shade200),
        cells: [
          const DataCell(Text('Puntos posibles', style: TextStyle(color: Color(0xFF003056)))),
          DataCell(Text(puntos[0], style: const TextStyle(color: Color(0xFF003056)))),
          DataCell(Text(puntos[1], style: const TextStyle(color: Color(0xFF003056)))),
          DataCell(Text(puntos[2], style: const TextStyle(color: Color(0xFF003056)))),
        ],
      ));
      rows.add(DataRow(
        color: WidgetStateProperty.all(Colors.grey.shade200),
        cells: [
          const DataCell(Text('% Obtenido', style: TextStyle(color: Color(0xFF003056)))),
          const DataCell(Text('80%', style: TextStyle(color: Color(0xFF003056)))),
          const DataCell(Text('75%', style: TextStyle(color: Color(0xFF003056)))),
          const DataCell(Text('90%', style: TextStyle(color: Color(0xFF003056)))),
        ],
      ));
      rows.add(DataRow(
        color: WidgetStateProperty.all(Colors.grey.shade200),
        cells: [
          const DataCell(Text('Puntos obtenidos', style: TextStyle(color: Color(0xFF003056)))),
          const DataCell(Text('100', style: TextStyle(color: Color(0xFF003056)))),
          const DataCell(Text('60', style: TextStyle(color: Color(0xFF003056)))),
          const DataCell(Text('45', style: TextStyle(color: Color(0xFF003056)))),
        ],
      ));
    }

    const auxLabels = [
      'seguridad/medio ambiente/moral',
      'satisfacción del cliente',
      'calidad',
      'costo/productividad',
      'entregas',
    ];
    final auxRows = auxLabels.map((label) {
      return DataRow(
        color: WidgetStateProperty.all(Colors.grey.shade200),
        cells: [
          DataCell(Text(label, style: const TextStyle(color: Color(0xFF003056)))),
          const DataCell(Text('5', style: TextStyle(color: Color(0xFF003056)))),
          const DataCell(Text('Obtenido', style: TextStyle(color: Color(0xFF003056)))),
        ],
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003056),
        title: const Center(
          child: Text('Resumen Global', style: TextStyle(color: Colors.white)),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DataTable(
                // Ocultar completamente la fila de encabezado
                headingRowHeight: 0,
                showBottomBorder: false,
                columnSpacing: 36,
                border: TableBorder.all(color: const Color(0xFF003056)),
                columns: const [
                  DataColumn(label: SizedBox.shrink()),
                  DataColumn(label: SizedBox.shrink()),
                  DataColumn(label: SizedBox.shrink()),
                  DataColumn(label: SizedBox.shrink()),
                ],
                rows: rows,
              ),
              const SizedBox(width: 24),
              DataTable(
                headingRowColor: WidgetStateProperty.all(const Color(0xFF003056)),
                headingTextStyle: const TextStyle(color: Colors.white),
                columnSpacing: 24,
                border: TableBorder.all(color: const Color(0xFF003056)),
                columns: const [
                  DataColumn(label: Text('Resultado', style: TextStyle(color: Colors.white))),
                  DataColumn(label: Text('Valor', style: TextStyle(color: Colors.white))),
                  DataColumn(label: Text('Obtenido', style: TextStyle(color: Colors.white))),
                ],
                rows: auxRows,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
