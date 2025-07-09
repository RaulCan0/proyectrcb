import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/empresa.dart';

class EmpresasProvider with ChangeNotifier {
  final _client = Supabase.instance.client;
  List<Empresa> empresas = [];
  bool isLoading = false;

  Future<void> cargarEmpresas() async {
    isLoading = true;
    notifyListeners();
    final response = await _client.from('empresas').select();
    empresas = (response as List).map((e) => Empresa.fromMap(e)).toList();
    isLoading = false;
    notifyListeners();
  }
}