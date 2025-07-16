import 'package:flutter/material.dart';
import 'package:lensysapp/evaluacion/models/empresa.dart';
import 'package:provider/provider.dart';
import 'package:lensysapp/evaluacion/providers/datos_provider.dart';
import '../widgets/drawer_lensys.dart';


extension CapitalizeExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}

class TablasDimensionScreen extends StatefulWidget {
  static Map<String, Map<String, List<Map<String, dynamic>>>> tablaDatos = {
    'Dimensión 1': {},
    'Dimensión 2': {},
    'Dimensión 3': {},
  };

  static final ValueNotifier<bool> dataChanged = ValueNotifier<bool>(false);

  final Empresa empresa;
  final String evaluacionId; // Usado como clave en tablaDatos
  final String asociadoId; // Nuevo: Hacerlo un campo de instancia si es necesario
  final String empresaId;  // Nuevo: Hacerlo un campo de instancia si es necesario
  final String dimension;  // Nuevo: Hacerlo un campo de instancia si es necesario (es el nombre interno de la dimensión)

  const TablasDimensionScreen({
    super.key,
    required this.empresa,
    required this.evaluacionId,
    required this.asociadoId, // Ahora se asigna
    required this.empresaId,  // Ahora se asigna
    required this.dimension,  // Ahora se asigna
  });


  static Future<void> actualizarDato(
    String evaluacionId, {
    required String dimension,
    required String principio,
    required String comportamiento,
    required String cargo,
    required int valor,
    required List<String> sistemas,
    required String dimensionId,
    required String asociadoId,
  }) async {
    final tablaDim = tablaDatos.putIfAbsent(dimension, () => {});
    final lista = tablaDim.putIfAbsent(evaluacionId, () => []);

    final indiceExistente = lista.indexWhere((item) =>
        item['principio'] == principio &&
        item['comportamiento'] == comportamiento &&
        item['cargo_raw'] == cargo &&
        item['dimension_id'] == dimensionId &&
        item['asociado_id'] == asociadoId);

    if (indiceExistente != -1) {
      lista[indiceExistente]['valor'] = valor;
      lista[indiceExistente]['sistemas'] = sistemas;
    } else {
      lista.add({
        'principio': principio,
        'comportamiento': comportamiento,
        'cargo': cargo.trim().capitalize(),
        'cargo_raw': cargo,
        'valor': valor,
        'sistemas': sistemas,
        'dimension_id': dimensionId,
        'asociado_id': asociadoId,
      });
    }
    dataChanged.value = !dataChanged.value;
  }

  static Future<void> limpiarDatos() async {
    tablaDatos.clear();
    dataChanged.value = false;
  }

  @override
  State<TablasDimensionScreen> createState() => _TablasDimensionScreenState();
}

class _TablasDimensionScreenState extends State<TablasDimensionScreen> with TickerProviderStateMixin {
  final Map<String, String> dimensionInterna = {
    'IMPULSORES CULTURALES': 'Dimensión 1',
    'MEJORA CONTINUA': 'Dimensión 2',
    'ALINEAMIENTO EMPRESARIAL': 'Dimensión 3',
  };

  late List<String> dimensiones;
  bool _providerListenerAdded = false;

  @override
  void initState() {
    super.initState();
    TablasDimensionScreen.dataChanged.addListener(_onDataChanged);
    dimensiones = dimensionInterna.keys.toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_providerListenerAdded) {
      Provider.of<DatosProvider>(context, listen: false).addListener(_onDataChanged);
      _providerListenerAdded = true;
    }
  }

 

  void _onDataChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: dimensiones.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF003056),
          title: const Center(
            child: Text(
              'Resultados en tiempo real',
              style: TextStyle(color: Colors.white),
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.grey.shade300,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey.shade300,
            tabs: dimensiones.map((d) => Tab(child: Text(d))).toList(),
          ),
        ),
        endDrawer: const DrawerLensys(),
        body: TabBarView(
          children: dimensiones.map((dimension) {
            final keyInterna = dimensionInterna[dimension] ?? dimension;
            final filas = TablasDimensionScreen.tablaDatos[keyInterna]?.values.expand((l) => l).toList() ?? [];

            if (filas.isEmpty) {
              return const Center(child: Text('No hay datos para mostrar para esta evaluación'));
            }

            return InteractiveViewer(
              constrained: false,
              scaleEnabled: false,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(8),
                  child: DataTable(
                    columnSpacing: 36,
                    headingRowColor: WidgetStateProperty.resolveWith(
                      (states) => Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade800
                          : const Color(0xFF003056),
                    ),
                    dataRowColor: WidgetStateProperty.all(Colors.grey.shade200),
                    border: TableBorder.all(color: const Color(0xFF003056)),
                    columns: const [
                      DataColumn(label: Text('Principio', style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text('Comportamiento', style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text('Ejecutivo', style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text('Gerente', style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text('Miembro', style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text('Ejecutivo Sistemas', style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text('Gerente Sistemas', style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text('Miembro Sistemas', style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text('Gerente de Equipo', style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text('Miembro de Equipo', style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text('Observaciones Ejecutivos', style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text('Observaciones Gerentes', style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text('Observaciones Miembros de Equipo', style: TextStyle(color: Colors.white))),
                    ],
                    rows: filas.map((fila) {
                      return DataRow(cells: [
                        DataCell(Text(fila['principio'] ?? '')),
                        DataCell(Text(fila['comportamiento'] ?? '')),
                        DataCell(Text(fila['ejecutivo']?.toString() ?? '')),
                        DataCell(Text(fila['gerente']?.toString() ?? '')),
                        DataCell(Text(fila['miembro']?.toString() ?? '')),
                        DataCell(Text(fila['ejecutivo_sistemas']?.toString() ?? '')),
                        DataCell(Text(fila['gerente_sistemas']?.toString() ?? '')),
                        DataCell(Text(fila['miembro_sistemas']?.toString() ?? '')),
                        DataCell(Text(fila['gerente_equipo']?.toString() ?? '')),
                        DataCell(Text(fila['miembro_equipo']?.toString() ?? '')),
                        DataCell(Text(fila['obs_ejecutivo']?.toString() ?? '')),
                        DataCell(Text(fila['obs_gerente']?.toString() ?? '')),
                        DataCell(Text(fila['obs_miembro_equipo']?.toString() ?? '')),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
