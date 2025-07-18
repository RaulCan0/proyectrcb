import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import '../models/empresa.dart';
import '../models/asociado.dart';

class AppProvider with ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;
  SharedPreferences? _prefs;

  List<Empresa> _empresas = [];
  List<Asociado> _asociados = [];
  final Map<String, dynamic> _cache = {};

  final Map<String, double> _progresoDimensiones = {};
  final Map<String, Map<String, double>> _progresoAsociados = {};
  final Map<String, List<Map<String, dynamic>>> _principios = {};
  final Map<String, Map<String, List<Map<String, dynamic>>>> _tablaDatos = {};

  // NUEVO: Calificaciones
  Map<String, Map<String, Map<String, Map<String, Map<String, int>>>>> _calificaciones = {};

  List<Empresa> get empresas => _empresas;
  List<Asociado> get asociados => _asociados;
  Map<String, double> get progresoDimensiones => _progresoDimensiones;
  Map<String, Map<String, double>> get progresoAsociados => _progresoAsociados;
  Map<String, List<Map<String, dynamic>>> get principios => _principios;
  Map<String, Map<String, List<Map<String, dynamic>>>> get tablaDatos => _tablaDatos;
  Map<String, Map<String, Map<String, Map<String, Map<String, int>>>>> get calificaciones => _calificaciones;

  /// Inicialización
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadEmpresas();
    await _loadCalificaciones();
    notifyListeners();
  }

  /// CALIFICACIONES

  void setCalificacion({
    required String dimension,
    required String principio,
    required String comportamiento,
    required String sistema,
    required String cargo,
    required int valor,
  }) {
    _calificaciones.putIfAbsent(dimension, () => {});
    _calificaciones[dimension]!.putIfAbsent(principio, () => {});
    _calificaciones[dimension]![principio]!.putIfAbsent(comportamiento, () => {});
    _calificaciones[dimension]![principio]![comportamiento]!.putIfAbsent(sistema, () => {});
    _calificaciones[dimension]![principio]![comportamiento]![sistema]![cargo] = valor;

    _saveCalificaciones();
    notifyListeners();
  }

  void actualizarDato(
    String evaluacionId, {
      required String dimension,
      required String principio,
      required String comportamiento,
      required String cargo,
      required double valor,
      required List<String> sistemas,
    }) {
    setCalificacion(
      dimension: dimension,
      principio: principio,
      comportamiento: comportamiento,
      sistema: sistemas.isNotEmpty ? sistemas.first : '',
      cargo: cargo,
      valor: valor.toInt(),
    );
  }

  int getSumaDimension(String dimension) {
    int total = 0;
    if (_calificaciones.containsKey(dimension)) {
      _calificaciones[dimension]!.forEach((principio, compMap) {
        compMap.forEach((comportamiento, sistMap) {
          sistMap.forEach((sistema, cargos) {
            cargos.forEach((_, valor) {
              total += valor;
            });
          });
        });
      });
    }
    return total;
  }

  int getSumaDimensionPorCargo(String dimension, String cargo) {
    int total = 0;
    if (_calificaciones.containsKey(dimension)) {
      _calificaciones[dimension]!.forEach((principio, compMap) {
        compMap.forEach((comportamiento, sistMap) {
          sistMap.forEach((sistema, cargos) {
            total += cargos[cargo] ?? 0;
          });
        });
      });
    }
    return total;
  }

  double getPromedioDimensionPorCargo(String dimension, String cargo) {
    int total = 0;
    int count = 0;
    if (_calificaciones.containsKey(dimension)) {
      _calificaciones[dimension]!.forEach((principio, compMap) {
        compMap.forEach((comportamiento, sistMap) {
          sistMap.forEach((sistema, cargos) {
            if (cargos.containsKey(cargo)) {
              total += cargos[cargo]!;
              count++;
            }
          });
        });
      });
    }
    return count == 0 ? 0.0 : total / count;
  }

  Future<void> _saveCalificaciones() async {
    if (_prefs != null) {
      _prefs!.setString('calificaciones', jsonEncode(_calificaciones));
    }
  }

  Future<void> _loadCalificaciones() async {
    if (_prefs != null) {
      String? data = _prefs!.getString('calificaciones');
      if (data != null) {
        _calificaciones = (jsonDecode(data) as Map<String, dynamic>).map((dimensionKey, principioMap) =>
          MapEntry(dimensionKey, (principioMap as Map<String, dynamic>).map((principioKey, comportamientoMap) =>
            MapEntry(principioKey, (comportamientoMap as Map<String, dynamic>).map((comportamientoKey, sistemaMap) =>
              MapEntry(comportamientoKey, (sistemaMap as Map<String, dynamic>).map((sistemaKey, cargoMap) =>
                MapEntry(sistemaKey, (cargoMap as Map<String, dynamic>).map((cargoKey, valor) =>
                  MapEntry(cargoKey, valor as int)
                ))
              ))
            ))
          )
        ));  
      }
    }
  }

  /// EMPRESAS

  Future<void> _loadEmpresas() async {
    try {
      final response = await _client.from('empresas').select();
      _empresas = (response as List).map((e) => Empresa.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Error loading empresas: $e');
    }
  }

  Future<void> addEmpresa(Empresa empresa) async {
    try {
      await _client.from('empresas').insert(empresa.toMap());
      _empresas.add(empresa);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding empresa: $e');
    }
  }

  Future<void> deleteEmpresa(String id) async {
    try {
      await _client.from('empresas').delete().eq('id', id);
      _empresas.removeWhere((empresa) => empresa.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting empresa: $e');
    }
  }

  /// SINCRONIZACIÓN

  Future<void> syncData() async {
    try {
      debugPrint('Sincronizando datos...');
      await _loadEmpresas();
      for (var empresa in _empresas) {
        await loadAsociados(empresa.id);
        await loadProgresoDimensiones(empresa.id);
        await loadProgresoAsociados(empresa.id);
        await loadPrincipios(empresa.id);
        await loadTablaDatos(empresa.id);
      }
      debugPrint('Sincronización completada.');
    } catch (e) {
      debugPrint('Error durante la sincronización: $e');
    }
  }

  Future<void> clearCache() async {
    _cache.clear();
    await _prefs?.clear();
    notifyListeners();
  }

  /// AUTH

  Future<bool> login(String email, String password) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error during login: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _client.auth.signOut();
    notifyListeners();
  }

  /// ASOCIADOS

  Future<void> loadAsociados(String empresaId) async {
    try {
      final response = await _client.from('asociados').select().eq('empresa_id', empresaId);
      _asociados = (response as List).map((e) => Asociado.fromMap(e)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading asociados: $e');
    }
  }

  Future<void> addAsociado(Asociado asociado) async {
    try {
      await _client.from('asociados').insert(asociado.toMap());
      _asociados.add(asociado);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding asociado: $e');
    }
  }

  /// PROMEDIOS

  Future<void> uploadPromedios(String evaluacionId, String dimension, List<Map<String, dynamic>> filas) async {
    if (filas.isEmpty) {
      debugPrint('No hay datos para subir en uploadPromedios.');
      return;
    }
    try {
      final data = filas.map((fila) => {
        'evaluacion_id': evaluacionId,
        'dimension': dimension,
        'cargo': fila['cargo'],
        'promedio': fila['promedio'],
        'created_at': DateTime.now().toIso8601String(),
      }).toList();
      await _client.from('promedios_comportamientos').insert(data);
      debugPrint('Promedios subidos exitosamente.');
    } catch (e) {
      debugPrint('Error subiendo promedios: $e');
    }
  }

  /// BUCKETS

  Future<String> uploadFile(String bucket, String path, Uint8List bytes) async {
    try {
      await _client.storage.from(bucket).uploadBinary(path, bytes);
      return _client.storage.from(bucket).getPublicUrl(path);
    } catch (e) {
      debugPrint('Error uploading file: $e');
      throw Exception('File upload failed');
    }
  }

  /// PROGRESO

  Future<void> loadProgresoDimensiones(String empresaId) async {
    try {
      final response = await _client.from('progreso_dimensiones').select().eq('empresa_id', empresaId);
      for (var item in response) {
        _progresoDimensiones[item['dimension_id']] = item['progreso'];
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading progreso dimensiones: $e');
    }
  }

  Future<void> loadProgresoAsociados(String empresaId) async {
    try {
      final response = await _client.from('progreso_asociados').select().eq('empresa_id', empresaId);
      for (var item in response) {
        final asociadoId = item['asociado_id'];
        _progresoAsociados[asociadoId] ??= {};
        _progresoAsociados[asociadoId]![item['dimension_id']] = item['progreso'];
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading progreso asociados: $e');
    }
  }

  Future<void> loadPrincipios(String empresaId) async {
    try {
      final response = await _client.from('principios').select().eq('empresa_id', empresaId);
      for (var item in response) {
        final dimensionId = item['dimension_id'];
        _principios[dimensionId] ??= [];
        _principios[dimensionId]!.add(item);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading principios: $e');
    }
  }

  Future<void> loadTablaDatos(String empresaId) async {
    try {
      final response = await _client.from('tabla_datos').select().eq('id_empresa', empresaId).order('dimensión', ascending: true);
      // Procesar y almacenar los datos en _tablaDatos
      _tablaDatos[empresaId] = {};
      for (var item in response) {
        final dimension = item['dimensión'] ?? item['dimension'];
        if (dimension != null) {
          _tablaDatos[empresaId]![dimension] ??= [];
          _tablaDatos[empresaId]![dimension]!.add(item);
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error al cargar tablaDatos: $e');
    }
  }

  Future<void> clearTablaDatos() async {
    _tablaDatos.clear();
    notifyListeners();
  }

  // Devuelve la suma de una dimensión según el nombre visible en el dashboard
  double obtenerSumaPorDimension(String nombreDimension) {
    switch (nombreDimension) {
      case 'Impulsores Culturales':
        return getSumaDimension('Dimensión 1').toDouble();
      case 'Mejora Continua':
        return getSumaDimension('Dimensión 2').toDouble();
      case 'Alineamiento Empresarial':
        return getSumaDimension('Dimensión 3').toDouble();
      default:
        return 0.0;
    }
  }
}
