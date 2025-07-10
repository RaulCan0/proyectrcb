import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:lensysapp/evaluacion/widgets/drawer_lensys.dart';
import 'tablas_principios_widget.dart';

class TablasDimensionScreen extends StatefulWidget {
  const TablasDimensionScreen({super.key});

  @override
  State<TablasDimensionScreen> createState() => _TablasDimensionScreenState();
}

class _TablasDimensionScreenState extends State<TablasDimensionScreen> {
  final List<String> dimensiones = ['IMPULSORES CULTURALES', 'MEJORA CONTINUA', 'ALINEAMIENTO EMPRESARIAL'];
  bool mostrarPromedio = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<List<Map<String, dynamic>>> datosPorDimension = [[], [], []];

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    final String jsonString = await rootBundle.loadString('assets/estructura_base.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    final List dimensionesJson = jsonData['dimensiones'];
    setState(() {
      for (int i = 0; i < dimensiones.length; i++) {
        datosPorDimension[i] = [
          for (var p in dimensionesJson[i]['principios'])
            {
              'principios': [
                {
                  'nombre': p['nombre'],
                  'comportamientos': [
                    for (var c in (p['comportamientos'] ?? []))
                      c is String ? c : c['nombre'] ?? ''
                  ]
                }
              ]
            }
        ];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: dimensiones.length,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 35, 47, 112),
          leading: const BackButton(color: Colors.white),
          title: const Text('Resultados', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            ),
          ],
        ),
        endDrawer: const DrawerLensys(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (mostrarPromedio)
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Ver detalles y avance'),
                    ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: List.generate(dimensiones.length, (i) {
                  return TablasPrincipiosWidget(dimensiones: datosPorDimension[i]);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
