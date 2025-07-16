
// ✅ ASOCIADO REMOTE SERVICE
import 'package:lensysapp/evaluacion/models/asociado.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AsociadoRemoteService {
  final _client = Supabase.instance.client;

  Future<List<Asociado>> getAsociadosPorEmpresa(String empresaId) async {
    try {
      final res = await _client.from('asociados').select().eq('empresa_id', empresaId);
      return (res as List).map((e) => Asociado.fromMap(e)).toList();
    } catch (e) {
      ('Error al obtener asociados: $e');
      return [];
    }
  }

  Future<void> addAsociado(Asociado asociado) async {
    await _client.from('asociados').insert(asociado.toMap());
  }
}