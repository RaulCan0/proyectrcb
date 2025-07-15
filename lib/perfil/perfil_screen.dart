// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lensysapp/perfil/perfil_view_model.dart';
import 'package:lensysapp/perfil/text_size_provider.dart';
import 'package:provider/provider.dart';
import 'package:lensysapp/custom/appcolors.dart';
import 'package:lensysapp/perfil/theme_provider.dart'; // Ajusta la ruta según tu proyecto

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  late PerfilViewModel _viewModel;
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = PerfilViewModel(context);
    _viewModel.cargarDatos();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PerfilViewModel>.value(
      value: _viewModel,
      child: Consumer2<PerfilViewModel, ThemeProvider>(
        builder: (context, perfilVM, themeVM, _) {
          _nombreController.text = perfilVM.nombre;
          _telefonoController.text = perfilVM.telefono;

          final textSize = Provider.of<TextSizeProvider>(context);
          final scaleFactor = textSize.fontSize / 14.0;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Mi Perfil',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: AppColors.primary,
              leading: BackButton(color: Colors.white),
            ),
            body: perfilVM.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 30,
                                      backgroundColor: AppColors.primary,
                                      child: Icon(
                                        Icons.person,
                                        size: 36,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Información Personal',
                                            style: TextStyle(
                                              fontSize: 18 * scaleFactor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            perfilVM.nombre.isEmpty
                                                ? 'Sin nombre'
                                                : perfilVM.nombre,
                                            style: TextStyle(
                                              fontSize: 14 * scaleFactor,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  controller: _nombreController,
                                  decoration: InputDecoration(
                                    labelText: 'Nombre completo',
                                    prefixIcon: const Icon(Icons.person_outline),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onChanged: (value) => perfilVM.nombre = value,
                                  style: TextStyle(fontSize: 14 * scaleFactor),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: _telefonoController,
                                  decoration: InputDecoration(
                                    labelText: 'Teléfono',
                                    prefixIcon: const Icon(Icons.phone_outlined),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  onChanged: (value) => perfilVM.telefono = value,
                                  style: TextStyle(fontSize: 14 * scaleFactor),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Configuraciones de la App',
                                  style: TextStyle(
                                    fontSize: 18 * scaleFactor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ListTile(
                                  leading: Icon(
                                    themeVM.isDarkMode
                                        ? Icons.dark_mode
                                        : Icons.light_mode,
                                    color: AppColors.primary,
                                  ),
                                  title: Text(
                                    'Tema',
                                    style: TextStyle(fontSize: 14 * scaleFactor),
                                  ),
                                  subtitle: Text(
                                    themeVM.isDarkMode ? 'Modo oscuro' : 'Modo claro',
                                    style: TextStyle(fontSize: 12 * scaleFactor),
                                  ),
                                  trailing: Switch(
                                    value: themeVM.isDarkMode,
                                    onChanged: (val) async {
                                      await themeVM.toggleTheme();
                                    },
                                    activeColor: AppColors.primary,
                                  ),
                                ),
                                // Aquí puedes agregar más configuraciones
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: perfilVM.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white),
                                  )
                                : const Icon(Icons.save),
                            label: Text(
                              perfilVM.isLoading ? 'Guardando...' : 'Guardar Cambios',
                              style: TextStyle(fontSize: 16 * scaleFactor),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: perfilVM.isLoading
                                ? null
                                : () async {
                                    final error = await perfilVM.guardarCambios();
                                    if (error != null && error.isNotEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(error),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Perfil actualizado correctamente'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                  },
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }
}
