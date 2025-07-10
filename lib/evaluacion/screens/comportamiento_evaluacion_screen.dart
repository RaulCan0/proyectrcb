// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lensysapp/custom/appcolors.dart';
import 'package:uuid/uuid.dart';
import 'package:lensysapp/evaluacion/models/calificacion.dart';
import 'package:lensysapp/evaluacion/services/supabase_service.dart';
import '../widgets/tabla_rol_button.dart';
import '../widgets/drawer_lensys.dart';

class ComportamientoEvaluacionScreen extends StatefulWidget {
  final String principio;
  final String cargo;
  final String evaluacionId;
  final String dimensionId;
  final String empresaId;
  final String asociadoId;
  final Calificacion? calificacionExistente;

  const ComportamientoEvaluacionScreen({
    super.key,
    required this.principio,
    required this.cargo,
    required this.evaluacionId,
    required this.dimensionId,
    required this.empresaId,
    required this.asociadoId,
    this.calificacionExistente,
  });

  @override
  State<ComportamientoEvaluacionScreen> createState() => _ComportamientoEvaluacionScreenState();
}

class _ComportamientoEvaluacionScreenState extends State<ComportamientoEvaluacionScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  final _picker = ImagePicker();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int calificacion = 0;
  final observacionController = TextEditingController();
  List<String> sistemasSeleccionados = [];
  bool isSaving = false;
  String? evidenciaUrl;

  @override
  void initState() {
    super.initState();
    if (widget.calificacionExistente != null) {
      calificacion = widget.calificacionExistente!.puntaje ?? 0;
      observacionController.text = widget.calificacionExistente!.observaciones ?? '';
      sistemasSeleccionados = widget.calificacionExistente!.sistemas != null
        ? widget.calificacionExistente!.sistemas!.split(',')
        : [];
      evidenciaUrl = widget.calificacionExistente!.evidenciaUrl;
    }
  }

  Future<void> _saveSelectedSystems(List<String> selected) async {
    setState(() {
      sistemasSeleccionados = List.from(selected);
    });
  }

  void _showAlert(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'))
        ],
      ),
    );
  }

  Future<void> _takePhoto() async {
    final source = ImageSource.gallery;
    try {
      final XFile? photo = await _picker.pickImage(source: source);
      if (photo == null) return;
      // Aquí deberías subir la imagen a tu storage y obtener la URL
      // Por ahora solo simulo la URL
      evidenciaUrl = photo.path;
      setState(() {});
      _showAlert('Evidencia', 'Imagen seleccionada correctamente.');
    } catch (e) {
      _showAlert('Error', 'No se pudo obtener la imagen: $e');
    }
  }

  Future<void> _guardarEvaluacion() async {
    final obs = observacionController.text.trim();
    if (obs.isEmpty) {
      _showAlert('Validación', 'Debes escribir una observación.');
      return;
    }
    if (sistemasSeleccionados.isEmpty) {
      _showAlert('Validación', 'Selecciona al menos un sistema.');
      return;
    }
    setState(() => isSaving = true);
    try {
      final calObj = Calificacion(
        id: widget.calificacionExistente?.id ?? const Uuid().v4(),
        idAsociado: widget.asociadoId,
        idEmpresa: widget.empresaId,
        idDimension: int.tryParse(widget.dimensionId),
        comportamiento: widget.principio,
        puntaje: calificacion,
        fechaEvaluacion: DateTime.now(),
        observaciones: obs,
        sistemas: sistemasSeleccionados.join(','),
        evidenciaUrl: evidenciaUrl,
      );
      if (widget.calificacionExistente != null) {
        await _supabaseService.updateCalificacionFull(calObj);
      } else {
        await _supabaseService.addCalificacion(calObj, id: calObj.id, idAsociado: widget.asociadoId);
      }
      if (mounted) Navigator.pop(context, widget.principio);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('Evaluación: ${widget.principio}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
        ],
      ),
      endDrawer: const DrawerLensys(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Benchmark text (puedes personalizarlo)
          Text('Benchmark: ...', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.help_outline),
                  label: const Text('Guía'),
                  onPressed: () => _showAlert('Guía', 'Aquí va la guía del principio.'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.settings),
                  label: const Text('Sistemas asociados'),
                  onPressed: isSaving
                      ? null
                      : () async {
                          // Aquí deberías mostrar un selector de sistemas
                          // Por ahora simulo selección
                          await _saveSelectedSystems(['Sistema 1', 'Sistema 2']);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (evidenciaUrl != null) ...[
            Image.file(File(evidenciaUrl!), height: 200),
            const SizedBox(height: 16),
          ],
          const Text('Calificación:', style: TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: calificacion.toDouble(),
            min: 0,
            max: 5,
            divisions: 5,
            label: calificacion.toString(),
            activeColor: AppColors.primary,
            onChanged: isSaving ? null : (v) => setState(() => calificacion = v.round()),
          ),
          const SizedBox(height: 16),
          TablaRolButton(),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
              child: TextField(
                controller: observacionController,
                maxLines: 2,
                enabled: !isSaving,
                decoration: const InputDecoration(hintText: 'Observaciones...', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(icon: const Icon(Icons.camera_alt, size: 28), onPressed: isSaving ? null : _takePhoto),
          ]),
          if (sistemasSeleccionados.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text('Sistemas Asociados:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: sistemasSeleccionados.map((s) => Chip(
                label: Text(s),
                onDeleted: () => _saveSelectedSystems(sistemasSeleccionados..remove(s)),
              )).toList(),
            ),
          ],
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              icon: isSaving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.save, color: Colors.white),
              label: Text(isSaving ? 'Guardando...' : 'Guardar Evaluación'),
              onPressed: isSaving ? null : _guardarEvaluacion,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                side: const BorderSide(color: AppColors.primary, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
