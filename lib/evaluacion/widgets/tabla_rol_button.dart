import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lensysapp/perfil/text_size_provider.dart';

class TablaRolButton extends StatelessWidget {
  const TablaRolButton({super.key});

  Widget _buildLentesDataTable(BuildContext context) {
    final textSize = context.watch<TextSizeProvider>().fontSize;
    final double scaleFactor = (textSize / 15.0).clamp(0.9, 1.0);

    DataCell wrapText(String text) => DataCell(
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 280 * scaleFactor),
            child: Text(text,
                softWrap: true,
                maxLines: 7,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13 * scaleFactor)),
          ),
        );

    return Semantics(
      label: 'Tabla de niveles de madurez por rol',
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 10.0 * scaleFactor,
            dataRowMinHeight: 50 * scaleFactor,
            dataRowMaxHeight: 160 * scaleFactor,
            headingRowHeight: 38 * scaleFactor,
            headingTextStyle: TextStyle(
              fontSize: 12 * scaleFactor,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF003056),
            ),
            dataTextStyle: TextStyle(
              fontSize: 12 * scaleFactor,
              color: Colors.black87,
            ),
            columns: const [
              DataColumn(label: Text('Lentes / Rol')),
              DataColumn(label: Text('Nivel 1\n0–20%', textAlign: TextAlign.center)),
              DataColumn(label: Text('Nivel 2\n21–40%', textAlign: TextAlign.center)),
              DataColumn(label: Text('Nivel 3\n41–60%', textAlign: TextAlign.center)),
              DataColumn(label: Text('Nivel 4\n61–80%', textAlign: TextAlign.center)),
              DataColumn(label: Text('Nivel 5\n81–100%', textAlign: TextAlign.center)),
            ],
            rows: [
              DataRow(cells: [
                const DataCell(Text('Ejecutivos')),
                wrapText('Los ejecutivos se centran principalmente en la lucha contra incendios y en gran parte están ausentes de los esfuerzos de mejora.'),
                wrapText('Los ejecutivos son conscientes de las iniciativas de otros para mejorar, pero en gran parte no están involucrados.'),
                wrapText('Los ejecutivos establecen la dirección para la mejora y respaldan los esfuerzos de los demás.'),
                wrapText('Los ejecutivos participan en los esfuerzos de mejora y respaldan el alineamiento de los principios de excelencia operacional con los sistemas.'),
                wrapText('Los ejecutivos se centran en garantizar que los principios de excelencia operativa se arraiguen profundamente en la cultura y se evalúen regularmente para mejorar.'),
              ]),
              DataRow(cells: [
                const DataCell(Text('Gerentes')),
                wrapText('Los gerentes están orientados a obtener resultados "a toda costa".'),
                wrapText('Los gerentes generalmente buscan especialistas para crear mejoras a través de la orientación del proyecto.'),
                wrapText('Los gerentes participan en el desarrollo de sistemas y ayudan a otros a usar herramientas de manera efectiva.'),
                wrapText('Los gerentes se enfocan en conductas de manejo a través del diseño de sistemas.'),
                wrapText('Los gerentes están "principalmente enfocados" en la mejora continua de los sistemas para impulsar un comportamiento más alineado con los principios de excelencia operativa.'),
              ]),
              DataRow(cells: [
                const DataCell(Text('Miembros del equipo')),
                wrapText('Los miembros del equipo se enfocan en hacer su trabajo y son tratados en gran medida como un gasto.'),
                wrapText('A veces se solicita a los asociados que participen en un equipo de mejora usualmente dirigido por alguien externo a su equipo de trabajo natural.'),
                wrapText('Están capacitados y participan en proyectos de mejora.'),
                wrapText('Están involucrados todos los días en el uso de herramientas para la mejora continua en sus propias áreas de responsabilidad.'),
                wrapText('Entienden los principios "el por qué" detrás de las herramientas y son líderes para mejorar sus propios sistemas y ayudar a otros.'),
              ]),
              DataRow(cells: [
                const DataCell(Text('Frecuencia')),
                wrapText('Infrecuente • Raro'),
                wrapText('Basado en eventos • Irregular'),
                wrapText('Frecuente • Común'),
                wrapText('Consistente • Predominante'),
                wrapText('Constante • Uniforme'),
              ]),
              DataRow(cells: [
                const DataCell(Text('Duración')),
                wrapText('Iniciado • Subdesarrollado'),
                wrapText('Experimental • Formativo'),
                wrapText('Repetible • Previsible'),
                wrapText('Establecido • Estable'),
                wrapText('Culturalmente Arraigado • Maduro'),
              ]),
              DataRow(cells: [
                const DataCell(Text('Intensidad')),
                wrapText('Apático • Indiferente'),
                wrapText('Aparente • Compromiso Individual'),
                wrapText('Moderado • Compromiso Local'),
                wrapText('Persistente • Amplio Compromiso'),
                wrapText('Tenaz • Compromiso Total'),
              ]),
              DataRow(cells: [
                const DataCell(Text('Alcance')),
                wrapText('Aislado • Punto de Solución'),
                wrapText('Silos • Flujo de Valor Interno'),
                wrapText('Predominantemente Operaciones • Flujo de Valor Funcional'),
                wrapText('Múltiples Procesos de Negocios • Flujo de Valor Integrado'),
                wrapText('En Toda la Empresa • Flujo de Valor Extendido'),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarLentesRolDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 80, vertical: 80),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.90,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: ScrollConfiguration(
            behavior: MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad
              },
            ),
            child: SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildLentesDataTable(context),
              ),
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _mostrarLentesRolDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF003056),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Tabla de niveles de madurez por rol'),
        ),
        const SizedBox(height: 12),
       
      ],
    );
  }
}