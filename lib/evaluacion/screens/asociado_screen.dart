import 'package:flutter/material.dart';
import 'package:lensysapp/evaluacion/services/supabase_service.dart';
import '../models/asociado.dart';
import '../models/empresa.dart';
import 'principios_screen.dart';
import '../widgets/drawer_lensys.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class AsociadoScreen extends StatefulWidget {
  final Empresa empresa;
  final String dimensionId;
  final String evaluacionId;

  const AsociadoScreen({
    super.key,
    required this.empresa,
    required this.dimensionId,
    required this.evaluacionId,
  });

  @override
  State<AsociadoScreen> createState() => _AsociadoScreenState();
}

class _AsociadoScreenState extends State<AsociadoScreen> with SingleTickerProviderStateMixin {
  final SupabaseService _supabaseService = SupabaseService();
  final Map<String, double> progresoAsociado = {};
  final GlobalKey<ScaffoldState> _scaffoldKeyAsociado = GlobalKey<ScaffoldState>();

  List<Asociado> ejecutivos = [];
  List<Asociado> gerentes = [];
  List<Asociado> miembros = [];

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _cargarAsociados();
  }

  Future<void> _cargarAsociados() async {
    try {
      final asociadosCargados = await _supabaseService.getAsociadosPorEmpresa(widget.empresa.id);
      ejecutivos.clear();
      gerentes.clear();
      miembros.clear();

      for (final asociado in asociadosCargados) {
        final progreso = await _supabaseService.obtenerProgresoAsociado(
          evaluacionId: widget.evaluacionId,
          asociadoId: asociado.id,
          dimensionId: widget.dimensionId,
        );
        progresoAsociado[asociado.id] = progreso;

        switch (asociado.cargo.toLowerCase()) {
          case 'ejecutivo':
            ejecutivos.add(asociado);
            break;
          case 'gerente':
            gerentes.add(asociado);
            break;
          case 'miembro':
            miembros.add(asociado);
            break;
        }
      }
      if (mounted) setState(() {});
    } catch (e) {
      if (!mounted) return;
      _mostrarAlerta('Error', 'Error al cargar asociados: $e');
    }
  }

  void _mostrarAlerta(String titulo, String mensaje) {
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

  Widget _buildLista(List<Asociado> lista) {
    return lista.isEmpty
        ? const Center(child: Text('SIN ASOCIADOS'))
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final asociado = lista[index];
                final progreso = progresoAsociado[asociado.id] ?? 0.0;
                return Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.person_outline,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xFF003056),
                    ),
                    title: Text(asociado.nombre),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${asociado.cargo.trim().toLowerCase() == "miembro" ? "MIEMBRO DE EQUIPO" : asociado.cargo.toUpperCase()} - ${asociado.antiguedad} años',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Progreso:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                              '${(progreso * 100).toStringAsFixed(1)}% completado',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: progreso,
                          backgroundColor: Colors.grey[300],
                          color: Colors.green,
                        ),
                        Text('${(progreso * 100).toStringAsFixed(1)}% completado'),
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
                            evaluacionId: widget.evaluacionId, empresaId: '',
                          ),
                        ),
                      ).then((_) => _cargarAsociados());
                    },
                  ),
                );
              },
            ),
          );
  }

  Future<void> _mostrarDialogoAgregarAsociado() async {
    final nombreController = TextEditingController();
    final antiguedadController = TextEditingController();
    String cargoSeleccionado = 'Ejecutivo';

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Nuevo Asociado', style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  labelStyle: GoogleFonts.roboto(),
                  border: const OutlineInputBorder(),
                ),
                style: GoogleFonts.roboto(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: antiguedadController,
                decoration: InputDecoration(
                  labelText: 'Antigüedad (años)',
                  labelStyle: GoogleFonts.roboto(),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                style: GoogleFonts.roboto(),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: cargoSeleccionado,
                items: ['Ejecutivo', 'Gerente', 'Miembro'].map((nivel) {
                  return DropdownMenuItem<String>(
                    value: nivel,
                    child: Text(nivel, style: GoogleFonts.roboto()),
                  );
                }).toList(),
                onChanged: (value) {
                  cargoSeleccionado = value!;
                },
                decoration: InputDecoration(
                  labelText: 'Nivel',
                  labelStyle: GoogleFonts.roboto(),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: GoogleFonts.roboto()),
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

              final nuevoId = const Uuid().v4();
              final nuevo = Asociado(
                id: nuevoId,
                nombre: nombre,
                cargo: cargoSeleccionado.toLowerCase(),
                empresaId: widget.empresa.id,
                empleadosAsociados: [],
                progresoDimensiones: {},
                comportamientosEvaluados: {},
                antiguedad: antiguedad,
              );

              try {
                await _supabaseService.addAsociado(nuevo);
                if (!mounted) return;
                Navigator.pop(context); // Cierra el diálogo solo si fue exitoso
                await _cargarAsociados();
                _mostrarAlerta('Éxito', 'Asociado agregado exitosamente.');
              } catch (e) {
                if (mounted) Navigator.pop(context);
                _mostrarAlerta('Error', 'Error al guardar asociado: $e');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003056),
              foregroundColor: Colors.white,
            ),
            child: Text('Asociar empleado', style: GoogleFonts.roboto()),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKeyAsociado,
      drawer: SizedBox(width: 300, child: const DrawerLensys()),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003056),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Center(
          child: Text(
            ' ${widget.empresa.nombre}',
            style: GoogleFonts.roboto(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => _scaffoldKeyAsociado.currentState?.openEndDrawer(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController!,
          indicatorColor: Colors.grey.shade300,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey.shade300,
          labelStyle: GoogleFonts.roboto(fontWeight: FontWeight.w500),
          unselectedLabelStyle: GoogleFonts.roboto(),
          tabs: const [
            Tab(text: 'EJECUTIVOS'),
            Tab(text: 'GERENTES'),
            Tab(text: 'MIEMBROS DE EQUIPO'),
          ],
        ),
      ),
      endDrawer: const DrawerLensys(),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildLista(ejecutivos),
            _buildLista(gerentes),
            _buildLista(miembros),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _mostrarDialogoAgregarAsociado();
        },
        backgroundColor: const Color(0xFF003056),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        elevation: 8,
        child: const Icon(Icons.person_add, size: 25, color: Colors.white),
      ),
    );
  }
}
