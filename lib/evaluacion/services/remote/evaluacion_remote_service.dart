import 'package:lensysapp/evaluacion/models/calificacion.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CalificacionRemoteService {
  final _client = Supabase.instance.client;

  Future<void> addOrUpdateCalificacion(Calificacion calificacion) async {
    final res = await _client.from('calificacion').select().eq('id', calificacion.id);
    if (res.isEmpty) {
      await _client.from('calificacion').insert(calificacion.toMap());
    } else {
      await _client.from('calificacion').update(calificacion.toMap()).eq('id', calificacion.id);
    }
  }
}