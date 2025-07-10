import 'package:flutter/material.dart';
import 'package:lensysapp/custom/appcolors.dart';
import 'package:lensysapp/chat/chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum TextSizeOption { ch, m, g }
class TextSizeProvider extends ChangeNotifier {
  TextSizeOption _option = TextSizeOption.m;
  double get fontSize {
    switch (_option) {
      case TextSizeOption.ch:
        return 12.0;
      case TextSizeOption.m:
        return 14.0;
      case TextSizeOption.g:
        return 16.0;
    }
  }

  TextSizeOption get option => _option;
  void setOption(TextSizeOption option) {
    _option = option;
    notifyListeners();
  }
}
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}


class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  bool _isLoading = false;
  bool _notificacionesActivas = true;
  bool _syncAutomatic = true;

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  Future<void> _cargarDatosUsuario() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    try {
      final data = await Supabase.instance.client
          .from('usuarios')
          .select('nombre, telefono')
          .eq('id', user.id)
          .single();

      setState(() {
        _nombreController.text = data['nombre'] ?? '';
        _telefonoController.text = data['telefono'] ?? '';
        // Configuraciones locales, no desde la base de datos
        // _notificacionesActivas y _syncAutomatic ya tienen valores por defecto
      });
    } catch (e) {
      debugPrint('Error cargando datos: $e');
    }
  }

  Future<void> _guardarCambios() async {
    if (_nombreController.text.trim().isEmpty) {
      _mostrarSnackBar('El nombre es obligatorio', error: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw 'Usuario no autenticado';

      await Supabase.instance.client.from('usuarios').upsert({
        'id': user.id,
        'nombre': _nombreController.text.trim(),
           });

      _mostrarSnackBar('Perfil actualizado correctamente');
    } catch (e) {
      _mostrarSnackBar('Error al guardar: $e', error: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _mostrarSnackBar(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final textSizeProvider = context.watch<TextSizeProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final scaleFactor = textSizeProvider.fontSize / 14.0;
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      key: scaffoldKey,
      drawer: const SizedBox(width: 300, child: ChatWidgetDrawer()),
     
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
             icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          
        ),
        title: Text(
          'Mi Perfil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20 * scaleFactor,
            color: Colors.white,
          ),
        ),
      ),  
      body: SingleChildScrollView(
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
                                user?.email ?? 'Sin email',
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
                        themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        color: AppColors.primary,
                      ),
                      title: Text(
                        'Tema',
                        style: TextStyle(fontSize: 14 * scaleFactor),
                      ),
                      subtitle: Text(
                        themeProvider.isDarkMode ? 'Modo oscuro' : 'Modo claro',
                        style: TextStyle(fontSize: 12 * scaleFactor),
                      ),
                      trailing: Switch(
                        value: themeProvider.isDarkMode,
                        onChanged: (value) {
                          themeProvider.toggleTheme();
                        },
                        activeColor: AppColors.primary,
                      ),
                    ),
                    
                                        ListTile(
                      leading: const Icon(
                        Icons.text_fields,
                        color: AppColors.primary,
                      ),
                      title: Text(
                        'Tamaño de letra',
                        style: TextStyle(fontSize: 14 * scaleFactor),
                      ),
                      subtitle: Text(
                        textSizeProvider.option.name.toUpperCase(),
                        style: TextStyle(fontSize: 12 * scaleFactor),
                      ),
                      trailing: DropdownButton<TextSizeOption>(
                        value: textSizeProvider.option,
                        items: [
                          DropdownMenuItem(
                            value: TextSizeOption.ch,
                            child: Text('CH', style: TextStyle(fontSize: 12 * scaleFactor)),
                          ),
                          DropdownMenuItem(
                            value: TextSizeOption.m,
                            child: Text('M', style: TextStyle(fontSize: 14 * scaleFactor)),
                          ),
                          DropdownMenuItem(
                            value: TextSizeOption.g,
                            child: Text('G', style: TextStyle(fontSize: 16 * scaleFactor)),
                          ),
                        ],
                        onChanged: (option) {
                          if (option != null) {
                            textSizeProvider.setOption(option);
                          }
                        },
                      ),
                    ),
                    
                                        SwitchListTile(
                      secondary: const Icon(
                        Icons.notifications_outlined,
                        color: AppColors.primary,
                      ),
                      title: Text(
                        'Notificaciones',
                        style: TextStyle(fontSize: 14 * scaleFactor),
                      ),
                      subtitle: Text(
                        'Recibir notificaciones de la app',
                        style: TextStyle(fontSize: 12 * scaleFactor),
                      ),
                      value: _notificacionesActivas,
                      onChanged: (value) {
                        setState(() => _notificacionesActivas = value);
                      },
                      activeColor: AppColors.primary,
                    ),
                    
                                        SwitchListTile(
                      secondary: const Icon(
                        Icons.sync,
                        color: AppColors.primary,
                      ),
                      title: Text(
                        'Sincronización automática',
                        style: TextStyle(fontSize: 14 * scaleFactor),
                      ),
                      subtitle: Text(
                        'Sincronizar datos automáticamente',
                        style: TextStyle(fontSize: 12 * scaleFactor),
                      ),
                      value: _syncAutomatic,
                      onChanged: (value) {
                        setState(() => _syncAutomatic = value);
                      },
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
                        SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(
                  _isLoading ? 'Guardando...' : 'Guardar Cambios',
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
                onPressed: _isLoading ? null : _guardarCambios,
              ),
            ),
          ],
        ),
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
