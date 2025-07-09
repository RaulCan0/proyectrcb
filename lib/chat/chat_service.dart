import 'dart:async';

import 'package:lensysapp/models-home/message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class ChatService {
  final _client = Supabase.instance.client;

    Future<void> sendMessage(String userId, String content) async {
    await _client
        .from('messages')
        .insert({
          'user_id': userId,
          'content': content,
        });
  }

    Future<Stream<List<dynamic>>> messageStream() async {
    return _client
        .from('messages')
        .stream(primaryKey: ['id'])
        .map((event) => event.map((m) => Message.fromMap(m)).toList());
  }

  
}