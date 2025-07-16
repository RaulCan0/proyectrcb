import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const List<String> sheetLabels = [
  'seguridad/medio ambiente/moral',
  'satisfacción del cliente',
  'calidad',
  'costo/productividad',
  'entregas',
];

class ShingoResultData {
  Map<String, String> campos;
  File? imagen;
  int calificacion;

  ShingoResultData({
    Map<String, String>? campos,
    this.imagen,
    this.calificacion = 0,
  }) : campos = campos ?? {
          'Cómo se calcula': '',
          'Cómo se mide': '',
          'Por qué es importante': '',
          'Sistemas usados para mejorar': '',
          'Explicación de desviaciones': '',
          'Cambios en 3 años': '',
          'Cómo se definen metas': '',
        };
}

class ShingoResultsScreen extends StatefulWidget {
  const ShingoResultsScreen({super.key});

  @override
  State<ShingoResultsScreen> createState() => _ShingoResultsScreenState();
}

class _ShingoResultsScreenState extends State<ShingoResultsScreen> {
  final Map<String, ShingoResultData> hojasGuardadas = {
    for (var label in sheetLabels) label: ShingoResultData(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shingo Prize – Resultados')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 40),
        children: sheetLabels.map((label) {
          return GestureDetector(
            onTap: () async {
              final resultado = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ShingoResultSheet(
                    title: label,
                    initialData: hojasGuardadas[label]!,
                  ),
                ),
              );
              if (resultado != null && resultado is ShingoResultData) {
                setState(() {
                  hojasGuardadas[label] = resultado;
                });
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ShingoResultSheet extends StatefulWidget {
  final String title;
  final ShingoResultData initialData;

  const ShingoResultSheet({
    super.key,
    required this.title,
    required this.initialData,
  });

  @override
  State<ShingoResultSheet> createState() => _ShingoResultSheetState();
}

class _ShingoResultSheetState extends State<ShingoResultSheet> {
  late Map<String, String> campos;
  File? imagen;
  int calificacion = 0;

  @override
  void initState() {
    super.initState();
    campos = Map.from(widget.initialData.campos);
    imagen = widget.initialData.imagen;
    calificacion = widget.initialData.calificacion;
  }

  Future<void> editarCampo(String titulo) async {
    final controller = TextEditingController(text: campos[titulo] ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(titulo),
        content: TextField(controller: controller, maxLines: 4),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('Guardar')),
        ],
      ),
    );
    if (result != null) {
      setState(() => campos[titulo] = result);
    }
  }

  Future<void> seleccionarImagen() async {
    final picker = ImagePicker();
    final archivo = await picker.pickImage(source: ImageSource.gallery);
    if (archivo != null) {
      setState(() => imagen = File(archivo.path));
    }
  }

  Widget calificacionWidget() => Row(
        children: [
          const Text('1'),
          Expanded(
            child: Slider(
              value: calificacion.toDouble(),
              min: 0.0,
              max: 5.0,
              divisions: 5,
              label: calificacion.toString(),
              onChanged: (value) {
                setState(() {
                  calificacion = value.round();
                });
              },
            ),
          ),
          const Text('5'),
        ],
      );

  String _tooltipForField(String campo) {
    switch (campo) {
      case 'Cómo se calcula':
        return 'Explica claramente cómo se mide y calcula este resultado.';
      case 'Cómo se mide':
        return 'Describe la fuente de datos y la frecuencia de medición.';
      case 'Por qué es importante':
        return 'Explica el impacto que tiene este resultado en la organización.';
      case 'Sistemas usados para mejorar':
        return 'Describe qué sistemas se usan para mejorar este resultado.';
      case 'Explicación de desviaciones':
        return 'Expón las razones de cualquier desviación significativa.';
      case 'Cambios en 3 años':
        return 'Describe si ha habido cambios en la medición durante los últimos 3 años.';
      case 'Cómo se definen metas':
        return 'Explica cómo se establecen los objetivos y metas para este resultado.';
      default:
        return 'Campo informativo';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              Navigator.pop(
                context,
                ShingoResultData(
                  campos: campos,
                  imagen: imagen,
                  calificacion: calificacion,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black87, width: 2),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(2, 2)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  widget.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              Tooltip(
                message: 'Incluye la gráfica de tendencia (ej. rendimiento, calidad).',
                child: GestureDetector(
                  onTap: seleccionarImagen,
                  child: Container(
                    height: 180,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.grey.shade200,
                      image: imagen != null
                          ? DecorationImage(image: FileImage(imagen!), fit: BoxFit.cover)
                          : null,
                    ),
                    child: imagen == null
                        ? const Center(child: Text('Tocar para agregar imagen del gráfico'))
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...campos.keys.map((campo) => Tooltip(
                    message: _tooltipForField(campo),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Text(campo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () => editarCampo(campo),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.grey.shade100,
                            ),
                            child: Text(
                              campos[campo]?.isEmpty ?? true ? 'Tocar para escribir...' : campos[campo]!,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),
              Tooltip(
                message: 'Asegúrate de explicar las tendencias y desviaciones.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Calificación (1-5)', style: TextStyle(fontWeight: FontWeight.bold)),
                    calificacionWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
