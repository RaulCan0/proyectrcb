import 'package:flutter/material.dart';
import 'package:lensysapp/chat/chat_screen.dart';
import 'package:lensysapp/custom/appcolors.dart';
import 'package:lensysapp/evaluacion/models/empresa.dart';
import 'package:lensysapp/evaluacion/screens/principios_screen.dart';
import 'package:lensysapp/evaluacion/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/asociado.dart';
import '../widgets/endrawer_lensys.dart';
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

class _AsociadoScreenState extends State<AsociadoScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKeyAsociado = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  final SupabaseService _supabaseService = SupabaseService();
  List<Asociado> ejecutivos = [];
  List<Asociado> gerentes = [];
  List<Asociado> miembros = [];
  Map<String, double> progresoAsociado = {};
  String? nombreEmpresa;

  Empresa get empresa => widget.empresa;
  String get dimensionId => widget.dimensionId;
  String get evaluacionId => widget.evaluacionId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _cargarNombreEmpresa();
    _cargarAsociados();
  }

  Future<void> _cargarNombreEmpresa() async {
    try {
      final data = await Supabase.instance.client
          .from('evaluacion_modular.empresas')
          .select('nombre')
          .eq('id', empresa.id)
          .single();
      if (mounted) {
        setState(() {
        nombreEmpresa = data['nombre'] ?? empresa.nombre;
      });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
        nombreEmpresa = empresa.nombre;
      });
      }
    }
  }

  Future<void> _cargarAsociados() async {
    try {
      final asociadosCargados = await _supabaseService.getAsociadosPorEmpresa(empresa.id);
      ejecutivos.clear();
      gerentes.clear();
      miembros.clear();
      progresoAsociado.clear();
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
      if (mounted) _mostrarAlerta('Error', 'Error al cargar asociados: $e');
    }
  }

  void _mostrarAlerta(String titulo, String mensaje) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(titulo, style: GoogleFonts.roboto()),
        content: Text(mensaje, style: GoogleFonts.roboto()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Aceptar', style: GoogleFonts.roboto()),
          ),
        ],
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

              if (nombre.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('El nombre es obligatorio.', style: Theme.of(context).textTheme.bodyMedium),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }
              if (antiguedad == null || antiguedad < 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('La antigüedad debe ser un número positivo.', style: Theme.of(context).textTheme.bodyMedium),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              final nuevoId = const Uuid().v4();
              final nuevo = Asociado(
                id: nuevoId,
                nombre: nombre,
                cargo: cargoSeleccionado.toLowerCase(),
                empresa: widget.empresa.id,
                empleadosAsociados: [],
                progresoDimensiones: {},
                comportamientosEvaluados: {},
                antiguedad: antiguedad,
              );

              try {
                // Validar que la empresa exista en la tabla empresas
                final empresaExiste = await Supabase.instance.client
                  .from('empresas')
                  .select('id')
                  .eq('id', empresa.id)
                  .maybeSingle();

                if (empresaExiste == null) {
                  // Si no existe, la crea automáticamente
                  await Supabase.instance.client.from('empresas').insert({
                    'id': empresa.id,
                    'nombre': empresa.nombre,
                    'tamano': empresa.tamano,
                    'empleados_total': empresa.empleadosTotal,
                    'empleados_asociados': empresa.empleadosAsociados,
                    'unidades': empresa.unidades,
                    'areas': empresa.areas,
                    'sector': empresa.sector,
                    'created_at': DateTime.now().toIso8601String(),
                  });
                }

                await Supabase.instance.client.from('asociados').insert({
                  'id': nuevoId,
                  'nombre': nombre,
                  'cargo': cargoSeleccionado.toLowerCase(),
                  'empresa_id': empresa.id,
                  'dimension_id': dimensionId,
                  'antiguedad': antiguedad,
                });

                if (!mounted) return;
                setState(() {
                  switch (cargoSeleccionado.toLowerCase()) {
                    case 'ejecutivo':
                      ejecutivos.add(nuevo);
                      break;
                    case 'gerente':
                      gerentes.add(nuevo);
                      break;
                    case 'miembro':
                      miembros.add(nuevo);
                      break;
                  }
                  progresoAsociado[nuevoId] = 0.0;
                });

                if (mounted) Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Asociado agregado exitosamente.', style: Theme.of(context).textTheme.bodyMedium),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                if (mounted) Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Error crítico', style: Theme.of(context).textTheme.titleLarge),
                    content: Text('Error al guardar asociado: $e', style: Theme.of(context).textTheme.bodyMedium),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Aceptar', style: Theme.of(context).textTheme.labelLarge),
                      ),
                    ],
                  ),
                );
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
                  color: Theme.of(context).cardColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Icon(
                      Icons.person_outline,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      asociado.nombre,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${asociado.cargo.trim().toLowerCase() == "miembro" ? "MIEMBRO DE EQUIPO" : asociado.cargo.toUpperCase()} - ${asociado.antiguedad} años',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progreso:',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${(progreso * 100).toStringAsFixed(1)}% completado',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: progreso,
                          backgroundColor: Colors.grey[300],
                          color: Theme.of(context).primaryColor,
                        ),
                        Text(
                          '${(progreso * 100).toStringAsFixed(1)}% completado',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    onTap: () {
                      // Validación previa a la navegación
                      final empresaReal = empresa;
                      final datosValidos = empresaReal.id.isNotEmpty && asociado.id.isNotEmpty && widget.evaluacionId.isNotEmpty;
                      if (!datosValidos) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('Datos incompletos', style: Theme.of(context).textTheme.titleLarge),
                            content: Text('No se puede continuar porque falta información de empresa, asociado o evaluación.', style: Theme.of(context).textTheme.bodyMedium),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Aceptar', style: Theme.of(context).textTheme.labelLarge),
                              ),
                            ],
                          ),
                        );
                        return;
                      }
                      try {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PrincipiosScreen(
                              empresa: empresaReal,
                              asociado: asociado,
                              dimensionId: widget.dimensionId,
                              evaluacionId: widget.evaluacionId,
                            ),
                          ),
                        ).then((_) => _cargarAsociados());
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al navegar: $e', style: Theme.of(context).textTheme.bodyMedium),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      key: _scaffoldKeyAsociado,
      drawer: SizedBox(width: 300, child: const ChatWidgetDrawer()),
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : AppColors.primary,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Center(
          child: Text(
            'Evaluación de ${nombreEmpresa ?? empresa.nombre}',
            style: GoogleFonts.roboto(color: Colors.white),
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
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

      endDrawer: const EndrawerLensys(),
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
          await _cargarAsociados();
        },
        backgroundColor: const Color(0xFF003056),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        elevation: 8,
        child: const Icon(Icons.add, size: 25, color: Colors.white),
      ),
    );
  }
}