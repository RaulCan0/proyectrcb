// ✅ STORAGE SERVICE
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final _client = Supabase.instance.client;

  Future<void> uploadFile({
    required String bucket,
    required String path,
    required Uint8List bytes,
    String contentType = 'application/octet-stream',
  }) async {
    try {
      await _client.storage.from(bucket).uploadBinary(
        path,
        bytes,
        fileOptions: FileOptions(contentType: contentType),
      );
    } catch (e) {
      ('Error al subir archivo: $e');
      rethrow;
    }
  }

  String getPublicUrl({
    required String bucket,
    required String path,
  }) {
    final res = _client.storage.from(bucket).getPublicUrl(path);
    if (res.isEmpty) throw Exception('No se pudo generar URL pública');
    return res;
  }
}