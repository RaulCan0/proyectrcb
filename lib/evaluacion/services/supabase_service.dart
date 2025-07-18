
// lib/evaluacion/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/asociado.dart';
import '../models/calificacion.dart';
import '../models/empresa.dart';
import '../models/level_averages.dart';

/// Servicio para operaciones con Supabase usando las tablas:
/// - empresas
/// - asociados
/// - calificaciones
class SupabaseService {
  /// Calcula el progreso de un asociado en una dimensión específica (0.0 a 1.0)
  Future<double> progresoAsociado({
    required String evaluacionId,
    required String asociadoId,
    required String dimensionId,
  }) async {
    if (evaluacionId.isEmpty || asociadoId.isEmpty || dimensionId.isEmpty) {
      return 0.0;
    }
    try {
      final response = await _client
          .from('calificaciones')
          .select('comportamiento')
          .eq('id_asociado', asociadoId)
          .eq('id_empresa', evaluacionId)
          .eq('id_dimension', int.tryParse(dimensionId) ?? -1);
      final total = (response as List).length;
      // Mapa de totales por dimensión (igual que en ProgresosService)
      const mapaTotalesDimension = {'1': 6, '2': 14, '3': 8};
      final totalDimension = mapaTotalesDimension[dimensionId] ?? 1;
      return (total / totalDimension).clamp(0.0, 1.0);
    } catch (_) {
      return 0.0;
    }
  }
  SupabaseClient get client => _client;
  final SupabaseClient _client = Supabase.instance.client;

  // ==== EMPRESAS ====
  Future<List<Empresa>> getEmpresas() async {
    final data = await _client.from('empresas').select();
    return (data as List)
        .map((e) => Empresa.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<Empresa> addEmpresa(Empresa e) async {
    final inserted = await _client.from('empresas').insert(e.toMap()).select().single();
    return Empresa.fromMap(inserted);
  }

  Future<void> updateEmpresa(String id, Empresa e) async {
    await _client.from('empresas').update(e.toMap()).eq('id', id);
  }

  Future<void> deleteEmpresa(String id) async {
    await _client.from('empresas').delete().eq('id', id);
  }

  // ==== ASOCIADOS ====
  Future<List<Asociado>> getAsociadosPorEmpresa(String empresaId) async {
    final data = await _client
        .from('asociados')
        .select()
        .eq('empresa_id', empresaId);
    return (data as List)
        .map((e) => Asociado.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<Asociado> addAsociado(Asociado a) async {
    final inserted =
        await _client.from('asociados').insert(a.toMap()).select().single();
    return Asociado.fromMap(inserted);
  }

  Future<void> updateAsociado(String id, Asociado a) async {
    await _client.from('asociados').update(a.toMap()).eq('id', id);
  }

  Future<void> deleteAsociado(String id) async {
    await _client.from('asociados').delete().eq('id', id);
  }

  // ==== CALIFICACIONES ====
  Future<List<Calificacion>> getCalificacionesPorAsociado(
      String idAsociado) async {
    final data = await _client
        .from('calificaciones')
        .select()
        .eq('id_asociado', idAsociado);
    return (data as List)
        .map((e) => Calificacion.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<Calificacion> addCalificacion(Calificacion c) async {
    final inserted =
        await _client.from('calificaciones').insert(c.toMap()).select().single();
    return Calificacion.fromMap(inserted);
  }

  Future<void> updateCalificacion(String id, int puntaje) async {
    await _client
        .from('calificaciones')
        .update({'puntaje': puntaje})
        .eq('id', id);
  }

  Future<void> deleteCalificacion(String id) async {
    await _client.from('calificaciones').delete().eq('id', id);
  }

  // ==== DASHBOARD PROMEDIOS (cálculo en cliente) ====
  Future<List<PromedioCargo>> getPromediosDimension(String empresaId) async {
    final califs = await _client
        .from('calificaciones')
        .select()
        .eq('id_empresa', empresaId);
    final list = (califs as List).map((e) => Calificacion.fromMap(e as Map<String, dynamic>));
    final mapDim = <String, List<double>>{};
    for (var c in list) {
      final dim = c.idDimension?.toString() ?? '0';
      mapDim.putIfAbsent(dim, () => []).add(c.puntaje?.toDouble() ?? 0.0);
    }
    return mapDim.entries.map((e) {
      final scores = e.value;
      final avg = scores.isNotEmpty
          ? scores.reduce((a, b) => a + b) / scores.length
          : 0.0;
      final dimId = int.tryParse(e.key) ?? 0;
      return PromedioCargo(
        id: dimId,
        nombre: 'Dimensión \$dimId',
        ejecutivo: 0.0,
        gerente: 0.0,
        miembro: 0.0,
        general: double.parse(avg.toStringAsFixed(2)),
        dimensionId: dimId,
      
      );
    }).toList();
  }

  Future<List<PromedioCargo>> getPromedioPrincipios(String empresaId) async {
    final califs = await _client
        .from('calificaciones')
        .select()
        .eq('id_empresa', empresaId);
    final list = (califs as List).map((e) => Calificacion.fromMap(e as Map<String, dynamic>));
    final mapPrin = <String, List<double>>{};
    for (var c in list) {
      final key = c.comportamiento;
      mapPrin.putIfAbsent(key, () => []).add(c.puntaje?.toDouble() ?? 0.0);
    }
    return mapPrin.entries.map((e) {
      final scores = e.value;
      final avg = scores.isNotEmpty
          ? scores.reduce((a, b) => a + b) / scores.length
          : 0.0;
      return PromedioCargo(
        id: 0,
        nombre: e.key,
        ejecutivo: 0.0,
        gerente: 0.0,
        miembro: 0.0,
        general: double.parse(avg.toStringAsFixed(2)),
        dimensionId: 0,
      );
    }).toList();
  }
}
