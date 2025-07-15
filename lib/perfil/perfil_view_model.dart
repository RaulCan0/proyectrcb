import 'package:flutter/material.dart';
import 'package:lensysapp/perfil/text_size_provider.dart';
import 'package:provider/provider.dart';
import 'perfil_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PerfilViewModel extends ChangeNotifier {
  final PerfilService _service = PerfilService();

  String nombre = '';
  String telefono = '';
  bool notificacionesActivas = true;
  bool syncAutomatic = true;
  String tamanoTexto = 'm'; // ch, m, g
  bool isLoading = false;

  final BuildContext context;

  PerfilViewModel(this.context);

  void cargarDatos() async {
    isLoading = true;
    notifyListeners();

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    final data = await _service.obtenerDatosUsuario(user.id);
    if (data != null) {
      nombre = data['nombre'] ?? '';
      telefono = data['telefono'] ?? '';
    }

    // Cargar configuración local
    final tamanoLocal = await _service.cargarTamanoTextoLocal();
    if (tamanoLocal != null) tamanoTexto = tamanoLocal;

    _actualizarTextSizeProvider(tamanoTexto);

    isLoading = false;
    notifyListeners();
  }

  Future<String?> guardarCambios() async {
    if (nombre.trim().isEmpty) return 'El nombre es obligatorio';

    isLoading = true;
    notifyListeners();

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      isLoading = false;
      notifyListeners();
      return 'Usuario no autenticado';
    }

    final ok = await _service.guardarDatosUsuario(user.id, nombre.trim(), telefono.trim());
    if (!ok) {
      isLoading = false;
      notifyListeners();
      return 'Error al guardar datos';
    }

    await _service.guardarTamanoTextoLocal(tamanoTexto);
    _actualizarTextSizeProvider(tamanoTexto);

    isLoading = false;
    notifyListeners();

    return null;
  }

  void _actualizarTextSizeProvider(String tamano) {
    final textSizeProvider = Provider.of<TextSizeProvider>(context, listen: false);
    switch (tamano) {
      case 'ch':
        textSizeProvider.setOption(TextSizeOption.ch);
        break;
      case 'm':
        textSizeProvider.setOption(TextSizeOption.m);
        break;
      case 'g':
        textSizeProvider.setOption(TextSizeOption.g);
        break;
      default:
        textSizeProvider.setOption(TextSizeOption.m);
    }
  }

  void actualizarTamanoTexto(String nuevoTamano) {
    tamanoTexto = nuevoTamano;
    notifyListeners();
    _actualizarTextSizeProvider(tamanoTexto);
  }
}
