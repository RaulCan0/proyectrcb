import 'package:flutter/material.dart';
import 'package:lensysapp/evaluacion/screens/historial_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: unused_import
import 'package:lensysapp/custom/appcolors.dart';
import 'package:lensysapp/evaluacion/widgets/drawer_lensys.dart';
import 'package:lensysapp/evaluacion/models/empresa.dart';
import 'package:uuid/uuid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmpresasScreen extends StatefulWidget {
  const EmpresasScreen({super.key});

  @override
  State<EmpresasScreen> createState() => _EmpresasScreenState();
}

class _EmpresasScreenState extends State<EmpresasScreen> {
  Empresa? _empresaActual;
  bool isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String correoUsuario = '';

  @override
  void initState() {
    super.initState();
    _cargarEmpresaGuardada();
    _obtenerCorreoUsuario();
  }

  Future<void> _obtenerCorreoUsuario() async {
    final user = Supabase.instance.client.auth.currentUser;
    setState(() {
      correoUsuario = user?.email ?? 'Usuario';
    });
  }

  Future<void> _cargarEmpresaGuardada() async {
    final prefs = await SharedPreferences.getInstance();
    final nombre = prefs.getString('empresa_nombre');
    if (nombre != null) {
      setState(() {
        _empresaActual = Empresa(
          id: prefs.getString('empresa_id') ?? '',
          nombre: nombre,
          empleadosTotal: prefs.getInt('empresa_empleados') ?? 0,
          tamano: prefs.getString('empresa_tamano') ?? 'Pequeña',
          unidades: prefs.getString('empresa_unidades') ?? '',
          areas: prefs.getInt('empresa_areas') ?? 0,
          sector: prefs.getString('empresa_sector') ?? '', empleadosAsociados: [], createdAt: DateTime.now(),
        );
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> _guardarEmpresa(Empresa empresa) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('empresa_id', empresa.id);
    await prefs.setString('empresa_nombre', empresa.nombre);
    await prefs.setInt('empresa_empleados', empresa.empleadosTotal);
    await prefs.setString('empresa_tamano', empresa.tamano);
    await prefs.setString('empresa_unidades', empresa.unidades);
    await prefs.setInt('empresa_areas', empresa.areas);
    await prefs.setString('empresa_sector', empresa.sector);
    setState(() => _empresaActual = empresa);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const DrawerLensys(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003056),
        centerTitle: true,
        title: const Text(
          'LensysApp',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bienvenido: $correoUsuario',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_empresaActual != null)
                          _buildButton(
                            context,
                            label: 'Evaluación de ${_empresaActual!.nombre}',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/dimensiones',
                                arguments: _empresaActual,
                              );
                            },
                          ),
                        _buildButton(
                          context,
                          label: 'HISTORIAL',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HistorialScreen(
                                empresasHistorial: [], empresas: [],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogoNuevaEmpresa(context),
        backgroundColor: const Color(0xFF003056),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        elevation: 8,
        child: const Icon(Icons.add, size: 25, color: Colors.white),
      ),
    );
  }

  Widget _buildButton(BuildContext context, {required String label, required VoidCallback onTap}) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF003056)),
          borderRadius: BorderRadius.circular(12),
          color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 20),
            Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
            const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.chevron_right, color: Color(0xFF003056)),
            ),
          ],
        ),
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
        title: const Text('Registrar nueva empresa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
                decoration: const InputDecoration(labelText: 'Total de empleados en la empresa', border: OutlineInputBorder()),
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
                decoration: const InputDecoration(labelText: 'Unidades de negocio', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: areasController,
                decoration: const InputDecoration(labelText: 'Número de áreas', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: sectorController,
                decoration: const InputDecoration(labelText: 'Sector', border: OutlineInputBorder()),
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
              if (nombre.isNotEmpty) {
                final nuevaEmpresa = Empresa(
                  id: const Uuid().v4(),
                  nombre: nombre,
                  tamano: tamano,
                  empleadosTotal: int.tryParse(empleadosController.text.trim()) ?? 0,
                  empleadosAsociados: [],
                  unidades: unidadesController.text.trim(),
                  areas: int.tryParse(areasController.text.trim()) ?? 0,
                  sector: sectorController.text.trim(),
                  createdAt: DateTime.now(),
                );
                await _guardarEmpresa(nuevaEmpresa);
                if (!mounted) return;
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            child: const Text('Guardar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
