import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/asociado.dart';

class AsociadosProvider with ChangeNotifier {
  final _client = Supabase.instance.client;
  List<Asociado> asociados = [];
  bool isLoading = false;

  Future<void> cargarAsociados(String empresaId) async {
    isLoading = true;
    notifyListeners();
    final response = await _client.from('asociados').select().eq('empresa_id', empresaId);
    asociados = (response as List).map((e) => Asociado.fromMap(e)).toList();
    isLoading = false;
    notifyListeners();
  }
}