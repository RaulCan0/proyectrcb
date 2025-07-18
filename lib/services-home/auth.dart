import 'package:supabase_flutter/supabase_flutter.dart';
class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  // AUTH
  Future<Map<String, dynamic>> register(String email, String password, String telefono) async {
    try {
      await _client.auth.signUp(email: email, password: password, data: {'telefono': telefono});
      return {'success': true};
    } on AuthException catch (e) {
      return {'success': false, 'message': e.message};
    } catch (e) {
      return {'success': false, 'message': 'Error desconocido: $e'};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
      return {'success': true};
    } on AuthException catch (e) {
      return {'success': false, 'message': e.message};
    } catch (e) {
      return {'success': false, 'message': 'Error desconocido: $e'};
    }
  }

  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      return {'success': true};
    } on AuthException catch (e) {
      return {'success': false, 'message': e.message};
    } catch (e) {
      return {'success': false, 'message': 'Error desconocido: $e'};
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  String? get userId => _client.auth.currentUser?.id;
}