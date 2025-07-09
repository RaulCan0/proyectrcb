import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lensysapp/custom/appcolors.dart';
import '../models/asociado.dart';
import '../models/empresa.dart';
import 'principios_screen.dart';
import '../widgets/drawer_lensys.dart';
// Asegúrate de importar donde esté definido AppColors

class AsociadoScreen extends StatefulWidget {
  final Empresa empresa;
  final String dimensionId;

  const AsociadoScreen({
    super.key,
    required this.empresa,
    required this.dimensionId,
    required String evaluacionId,
  });

  @override
  State<AsociadoScreen> createState() => _AsociadoScreenState();
}

class _AsociadoScreenState extends State<AsociadoScreen> {
  List<Asociado> asociados = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Aquí podrías cargar asociados desde un JSON local si lo deseas
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _mostrarDialogoAgregarAsociado() async {
    final nombreController = TextEditingController();
    final antiguedadController = TextEditingController();
    String cargoSeleccionado = 'Ejecutivo';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nuevo Asociado', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: antiguedadController,
                decoration: const InputDecoration(
                  labelText: 'Antigüedad (años)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: cargoSeleccionado,
                items: ['Ejecutivo', 'Gerente', 'Miembro de Equipo'].map((nivel) {
                  return DropdownMenuItem<String>(
                    value: nivel,
                    child: Text(nivel),
                  );
                }).toList(),
                onChanged: (value) {
                  cargoSeleccionado = value!;
                },
                decoration: const InputDecoration(
                  labelText: 'Nivel',
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
            onPressed: () async {
              final nombre = nombreController.text.trim();
              final antiguedadTexto = antiguedadController.text.trim();
              final antiguedad = int.tryParse(antiguedadTexto);

              if (nombre.isEmpty || antiguedad == null) {
                _mostrarAlerta('Error', 'Completa todos los campos correctamente.');
                return;
              }

              final nuevo = Asociado(
                id: Random().nextInt(100000).toString(),
                nombre: nombre,
                cargo: cargoSeleccionado.toLowerCase(),
                empresaId: widget.empresa.id,
                empleadosAsociados: [],
                progresoDimensiones: {},
                comportamientosEvaluados: {},
                antiguedad: antiguedad,
              );

              setState(() {
                asociados.add(nuevo);
              });

              Navigator.pop(context);
              _mostrarAlerta('Éxito', 'Asociado agregado exitosamente.');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Asociar empleado'),
          ),
        ],
      ),
    );
  }

  void _mostrarAlerta(String titulo, String mensaje) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(titulo),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Center(
          child: Text(
            'Asociados - ${widget.empresa.nombre}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
        ],
      ),
      endDrawer: const DrawerLensys(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: asociados.isEmpty
            ? const Center(child: Text('No hay asociados registrados'))
            : ListView.builder(
                itemCount: asociados.length,
                itemBuilder: (context, index) {
                  final asociado = asociados[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.person_outline, color: AppColors.primary),
                      title: Text(asociado.nombre),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${asociado.cargo.toLowerCase() == 'miembro' ? 'MIEMBRO DE EQUIPO' : asociado.cargo.toUpperCase()} - ${asociado.antiguedad} años',
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PrincipiosScreen(
                              empresa: widget.empresa,
                              asociado: asociado,
                              dimensionId: widget.dimensionId,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoAgregarAsociado,
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        elevation: 8,
        child: const Icon(Icons.person_add_alt_1, size: 32, color: Colors.white),
      ),
    );
  }
}