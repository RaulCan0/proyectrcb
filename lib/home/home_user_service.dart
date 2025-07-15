import 'package:supabase_flutter/supabase_flutter.dart';

class HomeUserService {
  final _client = Supabase.instance.client;

  Future<Map<String, dynamic>> getUserData() async {
    final user = _client.auth.currentUser;
    if (user == null) return {};
    try {
      final data = await _client
          .from('usuarios')
          .select('foto_url')
          .eq('id', user.id)
          .single();
      return {'foto_url': data['foto_url'] ?? ''};
    } catch (_) {
      return {'foto_url': user.userMetadata?['avatar_url'] ?? ''};
    }
  }
}
