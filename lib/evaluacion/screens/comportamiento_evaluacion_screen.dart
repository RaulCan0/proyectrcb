import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lensysapp/custom/appcolors.dart';
import 'package:lensysapp/evaluacion/models/principio_json.dart';
import 'package:lensysapp/evaluacion/widgets/drawer_lensys.dart';
import 'package:lensysapp/evaluacion/widgets/sistema_selector.dart';
import 'package:uuid/uuid.dart';
import 'package:lensysapp/evaluacion/models/calificacion.dart';
import 'package:lensysapp/evaluacion/services/supabase_service.dart';
import '../widgets/tabla_rol_button.dart';

// Mapa de sistemas recomendados por comportamiento
const Map<String, String> sistemasRecomendadosPorComportamiento = {
  "Soporte": "Desarrollo de personas, Medición, Reconocimiento",
  "Reconocer":
      "Medición, Involucramiento, Reconocimiento, Desarrollo de Personas",
  "Comunidad": "Seguridad, Ambiental, EHS, Compromiso, Desarrollo de Personas",
  "Liderazgo de servidor": "Desarrollo de Personas",
  "Valorar": "Desarrollo de Personas, Involucramiento",
  "Empoderar": "Medición, Reconocimiento, Desarrollo de Personas",
  "Mentalidad": "Sistemas de Mejora",
  "Estructura": "Sistemas de Mejora",
  "Reflexionar": "Solución de Problemas",
  "Análisis": "Solución de Problemas",
  "Colaborar": "Solución de Problemas",
  "Comprender": "Solución de Problemas, Gestión Visual",
  "Diseño": "Sistemas de Mejora, Gestión Visual",
  "Atribución": "Sistemas de Mejora, Solución de Problemas",
  "A prueba de error": "Sistemas de Mejora, Solución de Problemas",
  "Propiedad": "Sistemas de Mejora, Solución de Problemas",
  "Conectar": "Sistemas de Mejora",
  "Ininterrumpido": "Planificación y Programación, Sistemas de Mejora",
  "Demanda": "Planificación y Programación",
  "Eliminar": "Voz de cliente, Sistemas de Mejora",
  "Optimizar": "Sistemas de Mejora, Despliegue de Estrategia",
  "Impacto": "Sistemas de Mejora",
  "Alinear": "Despliegue de Estrategia",
  "Aclarar": "Comunicación, Despliegue de Estrategia",
  "Comunicar": "Comunicación, Despliegue de Estrategia",
  "Relación": "Voz del Cliente",
  "Valor": "Voz del Cliente",
  "Medida":"Despliegue de Estrategia, Medición, Voz del Cliente, Recompensas, Reconocimientos",
};

class ComportamientoEvaluacionScreen extends StatefulWidget {
  final PrincipioJson principio;
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
  State<ComportamientoEvaluacionScreen> createState() =>
      _ComportamientoEvaluacionScreenState();
}

class _ComportamientoEvaluacionScreenState
    extends State<ComportamientoEvaluacionScreen> {
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
      calificacion = widget.calificacionExistente!.puntaje!;
      observacionController.text =
          widget.calificacionExistente!.observaciones ?? '';
      sistemasSeleccionados = widget.calificacionExistente!.sistemas as List<String>;
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
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Future<void> _takePhoto() async {
    final source = ImageSource.gallery;
    try {
      final XFile? photo = await _picker.pickImage(source: source);
      if (photo == null) return;
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
        idDimension: int.tryParse(widget.dimensionId) ?? 0,
        comportamiento: widget.principio.nombre,
        puntaje: calificacion,
        fechaEvaluacion: DateTime.now(),
        observaciones: obs,
        sistemas: sistemasSeleccionados.join(','),
        evidenciaUrl: evidenciaUrl,
      );
      if (widget.calificacionExistente != null) {
        await _supabaseService.updateCalificacionFull(calObj);
      } else {
        await _supabaseService.addCalificacion(
          calObj,
          id: calObj.id,
          idAsociado: widget.asociadoId,
        );
      }
      // Notifica al provider para que recargue el progreso en PrincipiosScreen
      if (mounted) {
        Navigator.pop(context, true); // Devuelve un flag para recargar
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = 1.0;

    // Texto dinámico para el slider, usando tu modelo si está disponible
    // ignore: unnecessary_null_comparison
    final desc = widget.principio.calificaciones != null
        ? (widget.principio.calificaciones['C$calificacion'] ??
              'Desliza para agregar una calificación')
        : 'Desliza para agregar una calificación';

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              widget.principio.nombre,
              style: TextStyle(color: Colors.white, fontSize: 20 * scaleFactor),
            ),
            Text(
              widget.principio.benchmarkComportamiento.split(':').first.trim(),
              style: TextStyle(color: Colors.white, fontSize: 14 * scaleFactor),
            ),
          ],
        ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Benchmark: ${widget.principio.benchmarkPorCargo}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14 * scaleFactor,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.help_outline),
                    label: Text(
                      'Guía',
                      style: TextStyle(fontSize: 14 * scaleFactor),
                    ),
                    onPressed: () =>
                        _showAlert('Guía', widget.principio.preguntas),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 12 * scaleFactor,
                        horizontal: 16 * scaleFactor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.settings),
                    label: Text(
                      'Sistemas asociados',
                      style: TextStyle(fontSize: 14 * scaleFactor),
                    ),
                    onPressed: isSaving
                        ? null
                        : () async {
                            final seleccion =
                                await showModalBottomSheet<List<String>>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (_) => SistemasScreen(
                                    onSeleccionar: (s) => Navigator.pop(
                                      context,
                                      s
                                          .map((e) => e['nombre'].toString())
                                          .toList(),
                                    ),
                                  ),
                                );
                            if (seleccion != null) {
                              await _saveSelectedSystems(seleccion);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 12 * scaleFactor,
                        horizontal: 16 * scaleFactor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (evidenciaUrl != null) ...[
              Image.file(File(evidenciaUrl!), height: 200 * scaleFactor),
              const SizedBox(height: 16),
            ],
            Text(
              'Calificación:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14 * scaleFactor,
              ),
            ),
            Slider(
              value: calificacion.toDouble(),
              min: 0,
              max: 5,
              divisions: 5,
              label: calificacion.toString(),
              activeColor: AppColors.primary,
              inactiveColor: AppColors.primary.withAlpha(77),
              onChanged: isSaving
                  ? null
                  : (v) => setState(() => calificacion = v.round()),
            ),
            Text(
              desc,
              style: TextStyle(
                fontSize: 14 * scaleFactor,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            TablaRolButton(),
            const SizedBox(height: 8),
            if (sistemasRecomendadosPorComportamiento.containsKey(
              widget.principio.benchmarkComportamiento.split(':').first.trim(),
            )) ...[
              Text(
                sistemasRecomendadosPorComportamiento[widget
                        .principio
                        .benchmarkComportamiento
                        .split(':')
                        .first
                        .trim()]!
                    .replaceAll('\\n', ', '),
                style: TextStyle(
                  color: const Color(0xFF003056),
                  fontSize: 13 * scaleFactor,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: observacionController,
                    maxLines: 2,
                    enabled: !isSaving,
                    decoration: const InputDecoration(
                      hintText: 'Observaciones...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.camera_alt, size: 28),
                  onPressed: isSaving ? null : _takePhoto,
                ),
              ],
            ),
            if (sistemasSeleccionados.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Sistemas Asociados:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14 * scaleFactor,
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: sistemasSeleccionados
                    .map(
                      (s) => Chip(
                        label: Text(
                          s,
                          style: TextStyle(fontSize: 12 * scaleFactor),
                        ),
                        onDeleted: () => _saveSelectedSystems(
                          sistemasSeleccionados..remove(s),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                icon: isSaving
                    ? SizedBox(
                        width: 20 * scaleFactor,
                        height: 20 * scaleFactor,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save, color: Colors.white),
                label: Text(
                  isSaving ? 'Guardando...' : 'Guardar Evaluación',
                  style: TextStyle(fontSize: 14 * scaleFactor),
                ),
                onPressed: isSaving ? null : _guardarEvaluacion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 30 * scaleFactor,
                    vertical: 15 * scaleFactor,
                  ),
                  side: const BorderSide(color: AppColors.primary, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}