// ✅ EMPRESA REMOTE SERVICE
import 'package:lensysapp/evaluacion/models/empresa.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmpresaRemoteService {
  final _client = Supabase.instance.client;

  Future<List<Empresa>> getEmpresas() async {
    try {
      final res = await _client.from('empresas').select();
      return (res as List).map((e) => Empresa.fromMap(e)).toList();
    } catch (e) {
      ('Error al obtener empresas: $e');
      return [];
    }
  }
}