import 'package:flutter/material.dart';
import 'package:lensysapp/custom/appcolors.dart';
import 'package:lensysapp/evaluacion/screens/dimensiones_screen.dart';
import 'package:lensysapp/evaluacion/widgets/drawer_lensys.dart';
import 'package:uuid/uuid.dart';
import 'package:lensysapp/evaluacion/models/empresa.dart';

class EmpresasScreen extends StatefulWidget {
  const EmpresasScreen({super.key});

  @override
  State<EmpresasScreen> createState() => _EmpresasScreenState();
}

class _EmpresasScreenState extends State<EmpresasScreen> {
  final List<Empresa> empresas = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final empresaCreada = empresas.isNotEmpty ? empresas.last : null;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text(
          'EVALUACION SHINGO PRIZE',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
        ],
      ),
      endDrawer: const DrawerLensys(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bienvenido',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),
                ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/historial');
                },
                child: const Text('HISTORIAL'),
                ),
              const SizedBox(height: 20),
              if (empresaCreada != null)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DimensionesScreen(
                          empresaId: empresaCreada.id,
                          evaluacionId: const Uuid().v4(),
                          empresa: empresaCreada,
                        ),
                      ),
                    );
                  },
                  child: Text('Evaluar ${empresaCreada.nombre}'),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarDialogoNuevaEmpresa(context);
        },
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        elevation: 8,
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
    );
  }

  void _mostrarDialogoNuevaEmpresa(BuildContext context) {
    final nombreController = TextEditingController();
    final empleadosController = TextEditingController();
    final unidadesController = TextEditingController();
    final areasController = TextEditingController();
    final sectorController = TextEditingController();
    String tamano = 'Pequeña';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Registrar nueva empresa',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: empleadosController,
                decoration: const InputDecoration(
                    labelText: 'Total de empleados en la empresa', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: tamano,
                items: ['Pequeña', 'Mediana', 'Grande']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => tamano = value ?? 'Pequeña',
                decoration: const InputDecoration(
                  labelText: 'Tamaño de la empresa',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: unidadesController,
                decoration: const InputDecoration(
                  labelText: 'Unidades de negocio',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: areasController,
                decoration: const InputDecoration(
                  labelText: 'Número de áreas',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: sectorController,
                decoration: const InputDecoration(
                  labelText: 'Sector',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final nombre = nombreController.text.trim();
              if (nombre.isNotEmpty) {
                final nuevaEmpresa = Empresa(
                  id: const Uuid().v4(),
                  nombre: nombre,
                  tamano: tamano,
                  empleadosTotal: int.tryParse(empleadosController.text.trim()) ?? 0,
                  unidades: unidadesController.text.trim(),
                  areas: int.tryParse(areasController.text.trim()) ?? 0,
                  sector: sectorController.text.trim(),
                  createdAt: DateTime.now(), empleadosAsociados: [],
                );
                setState(() => empresas.add(nuevaEmpresa));
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
