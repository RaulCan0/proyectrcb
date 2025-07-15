import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/local_database.dart';


class PerfilService {
  final SupabaseClient _client = Supabase.instance.client;
  final LOCALDATABASE _db = LOCALDATABASE();

  Future<Map<String, dynamic>?> obtenerDatosUsuario(String userId) async {
    try {
      final data = await _client
          .from('usuarios')
          .select('nombre, telefono')
          .eq('id', userId)
          .single();
      return data;
    } catch (_) {
      return null;
    }
  }

  Future<bool> guardarDatosUsuario(String userId, String nombre, String telefono) async {
    try {
      await _client.from('usuarios').upsert({
        'id': userId,
        'nombre': nombre,
        'telefono': telefono,
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String?> cargarTamanoTextoLocal() async {
    return await _db.getTextSize();
  }

  Future<void> guardarTamanoTextoLocal(String tamano) async {
    await _db.saveTextSize(tamano);
  }

  Future<void> guardarConfiguracionLocal({
    required String themeMode,
    required String textSize,
    required bool notificaciones,
    required bool sincronizacion,
  }) async {
    await _db.saveConfig(
      themeMode: themeMode,
      textSize: textSize,
      notificaciones: notificaciones,
      sincronizacion: sincronizacion,
    );
  }

  Future<Map<String, dynamic>> cargarConfiguracionLocal() async {
    return await _db.getConfig();
  }
}
