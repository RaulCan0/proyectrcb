import 'package:flutter/material.dart';

class TablaRolButton extends StatelessWidget {
  const TablaRolButton({super.key});

  void _mostrarTablaDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.95,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildDataTable(),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  static Widget _buildDataTable() {
    // Puedes ajustar los textos y columnas según tu necesidad
    return DataTable(
      columnSpacing: 16,
      headingRowHeight: 40,
      dataRowMinHeight: 50,
      columns: const [
        DataColumn(label: Text('Lentes / Rol')),
        DataColumn(label: Text('Cargo 1\n0–20%')),
        DataColumn(label: Text('Cargo 2\n21–40%')),
        DataColumn(label: Text('Cargo 3\n41–60%')),
        DataColumn(label: Text('Cargo 4\n61–80%')),
        DataColumn(label: Text('Cargo 5\n81–100%')),
      ],
      rows: const [
        DataRow(cells: [
          DataCell(Text('Ejecutivos')),
          DataCell(Text('Los ejecutivos se centran principalmente en la lucha contra incendios y en gran parte están ausentes de los esfuerzos de mejora.')),
          DataCell(Text('Los ejecutivos son conscientes de las iniciativas de otros para mejorar, pero en gran parte no están involucrados.')),
          DataCell(Text('Los ejecutivos establecen la dirección para la mejora y respaldan los esfuerzos de los demás.')),
          DataCell(Text('Los ejecutivos participan en los esfuerzos de mejora y respaldan el alineamiento de los principios de excelencia operacional con los sistemas.')),
          DataCell(Text('Los ejecutivos se centran en garantizar que los principios de excelencia operativa se arraiguen profundamente en la cultura y se evalúen regularmente para mejorar.')),
        ]),
        DataRow(cells: [
          DataCell(Text('Gerentes')),
          DataCell(Text('Los gerentes están orientados a obtener resultados "a toda costa".')),
          DataCell(Text('Los gerentes generalmente buscan especialistas para crear mejoras a través de la orientación del proyecto.')),
          DataCell(Text('Los gerentes participan en el desarrollo de sistemas y ayudan a otros a usar herramientas de manera efectiva.')),
          DataCell(Text('Los gerentes se enfocan en conductas de manejo a través del diseño de sistemas.')),
          DataCell(Text('Los gerentes están principalmente enfocados en la mejora continua de los sistemas para impulsar un comportamiento más alineado con los principios de excelencia operativa.')),
        ]),
        DataRow(cells: [
          DataCell(Text('Miembros del equipo')),
          DataCell(Text('Los miembros del equipo se enfocan en hacer su trabajo y son tratados en gran medida como un gasto.')),
          DataCell(Text('A veces se solicita a los asociados que participen en un equipo de mejora usualmente dirigido por alguien externo a su equipo de trabajo natural.')),
          DataCell(Text('Están capacitados y participan en proyectos de mejora.')),
          DataCell(Text('Están involucrados todos los días en el uso de herramientas para la mejora continua en sus propias áreas de responsabilidad.')),
          DataCell(Text('Entienden los principios "el por qué" detrás de las herramientas y son líderes para mejorar sus propios sistemas y ayudar a otros.')),
        ]),
        DataRow(cells: [
          DataCell(Text('Frecuencia')),
          DataCell(Text('Infrecuente • Raro')),
          DataCell(Text('Basado en eventos • Irregular')),
          DataCell(Text('Frecuente • Común')),
          DataCell(Text('Consistente • Predominante')),
          DataCell(Text('Constante • Uniforme')),
        ]),
        DataRow(cells: [
          DataCell(Text('Duración')),
          DataCell(Text('Iniciado • Subdesarrollado')),
          DataCell(Text('Experimental • Formativo')),
          DataCell(Text('Repetible • Previsible')),
          DataCell(Text('Establecido • Estable')),
          DataCell(Text('Culturalmente Arraigado • Maduro')),
        ]),
        DataRow(cells: [
          DataCell(Text('Intensidad')),
          DataCell(Text('Apático • Indiferente')),
          DataCell(Text('Aparente • Compromiso Individual')),
          DataCell(Text('Moderado • Compromiso Local')),
          DataCell(Text('Persistente • Amplio Compromiso')),
          DataCell(Text('Tenaz • Compromiso Total')),
        ]),
        DataRow(cells: [
          DataCell(Text('Alcance')),
          DataCell(Text('Aislado • Punto de Solución')),
          DataCell(Text('Silos • Flujo de Valor Interno')),
          DataCell(Text('Predominantemente Operaciones • Flujo de Valor Funcional')),
          DataCell(Text('Múltiples Procesos de Negocios • Flujo de Valor Integrado')),
          DataCell(Text('En Toda la Empresa • Flujo de Valor Extendido')),
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _mostrarTablaDialog(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF003056),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text('Tabla de cargos de madurez por rol'),
    );
  }
}