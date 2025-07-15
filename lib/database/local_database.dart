import 'package:shared_preferences/shared_preferences.dart';

class LOCALDATABASE {
  static const _keyThemeMode = 'lensys_theme_mode';
  static const _keyTextSize = 'lensys_text_size';
  static const _keyNotificaciones = 'lensys_notificaciones';
  static const _keySincronizacion = 'lensys_sincronizacion';

  Future<void> saveConfig({
    required String themeMode,
    required String textSize,
    required bool notificaciones,
    required bool sincronizacion,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeMode, themeMode);
    await prefs.setString(_keyTextSize, textSize);
    await prefs.setBool(_keyNotificaciones, notificaciones);
    await prefs.setBool(_keySincronizacion, sincronizacion);
  }

  Future<Map<String, dynamic>> getConfig() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'themeMode': prefs.getString(_keyThemeMode),
      'textSize': prefs.get(_keyTextSize)?.toString(),
      'notificaciones': prefs.getBool(_keyNotificaciones),
      'sincronizacion': prefs.getBool(_keySincronizacion),
    };
  }

  Future<void> saveThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeMode, mode);
  }

  Future<String?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyThemeMode);
  }

  Future<void> saveTextSize(String size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTextSize, size);
  }

  Future<String?> getTextSize() async {
    final prefs = await SharedPreferences.getInstance();
    // Si se guardó como int, lo convierte a string
    final dynamic value = prefs.get(_keyTextSize);
    if (value == null) return null;
    if (value is int) return value.toString();
    if (value is String) return value;
    return value.toString();
  }

  Future<void> saveNotificaciones(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotificaciones, value);
  }

  Future<bool?> getNotificaciones() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNotificaciones);
  }

  Future<void> saveSincronizacion(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySincronizacion, value);
  }

  Future<bool?> getSincronizacion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keySincronizacion);
  }
}
