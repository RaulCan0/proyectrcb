import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lensysapp/custom/appcolors.dart';
import 'package:lensysapp/evaluacion/models/empresa.dart';
import 'package:lensysapp/evaluacion/services/error_handler_service.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class HistorialScreen extends StatefulWidget {
  final List<Empresa> empresas;

  const HistorialScreen({super.key, required this.empresas});

  @override
  // ignore: library_private_types_in_public_api
  _HistorialScreenState createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  final _supabase = Supabase.instance.client;
  List<Empresa> empresas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    empresas = widget.empresas;
    _fetchEmpresas();
  }

  Future<void> _fetchEmpresas() async {
    try {
      final response = await _supabase.from('empresas').select();

      final empresasCargadas = response.map<Empresa>((item) {
        List<String> empleadosAsociados = [];

        try {
          if (item['empleados_asociados'] is List) {
            empleadosAsociados = List<String>.from(item['empleados_asociados']);
          } else if (item['empleados_asociados'] is String && item['empleados_asociados'].isNotEmpty) {
            empleadosAsociados = List<String>.from(jsonDecode(item['empleados_asociados']));
          }
        } catch (e) {
          debugPrint('Error al decodificar empleados_asociados: $e');
        }

        return Empresa(
          id: item['id'] ?? 'Sin ID',
          evaluacionid: item['id_evaluacion'] ?? '',
          nombre: item['nombre'] ?? 'Empresa sin nombre',
          tamano: item['tamano'] ?? '-',
          empleadosTotal: item['empleados_total'] ?? 0,
          empleadosAsociados: empleadosAsociados,
          unidades: item['unidades'] ?? '-',
          areas: item['areas'] ?? 0,
          sector: item['sector'] ?? '-',
          createdAt: item['created_at'] != null
              ? DateTime.parse(item['created_at'])
              : DateTime.fromMillisecondsSinceEpoch(0),
        );
      }).toList();

      if (mounted) {
        setState(() {
          empresas = empresasCargadas;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ErrorHandlerService.showSnackBar(context, 'Error al cargar empresas: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Empresas'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchEmpresas,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : empresas.isEmpty
              ? const Center(child: Text('No hay empresas registradas.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: empresas.length,
                  itemBuilder: (context, index) {
                    final empresa = empresas[index];
                    return _buildEmpresaTile(empresa);
                  },
                ),
    );
  }

  Widget _buildEmpresaTile(Empresa empresa) {
    return ExpansionTile(
      leading: const Icon(Icons.business, color: Color.fromARGB(255, 3, 20, 119)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(empresa.nombre, style: Theme.of(context).textTheme.titleMedium),
          Text('Empleados: ${empresa.empleadosTotal}', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoRow(label: 'Tamaño', value: empresa.tamano),
              InfoRow(label: 'Sector', value: empresa.sector),
              InfoRow(label: 'Unidades', value: empresa.unidades),
              InfoRow(label: 'Áreas', value: empresa.areas.toString()),
              InfoRow(label: 'Empleados', value: empresa.empleadosTotal.toString()),
              const SizedBox(height: 8),
              const Text('Empleados asociados:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              empresa.empleadosAsociados.isEmpty
                  ? const Text('No hay empleados asociados')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: empresa.empleadosAsociados
                          .map((e) => Padding(
                                padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                                child: Text('• $e'),
                              ))
                          .toList(),
                    ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}


class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
