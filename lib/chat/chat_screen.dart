

import 'chat_service.dart';
import 'message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// ... imports sin cambios

class ChatWidgetDrawer extends StatefulWidget {
  const ChatWidgetDrawer({super.key});

  @override
  State<ChatWidgetDrawer> createState() => _ChatWidgetDrawerState();
}

class _ChatWidgetDrawerState extends State<ChatWidgetDrawer> {
  final _chatService = ChatService();
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  late final String _myUserId;
  List<Message> _previousMessages = [];

  final Color chatColor = Colors.teal;
  final Color receivedColor = Colors.grey.shade200;

  Stream<List<Message>>? _messageStream;

  @override
  void initState() {
    super.initState();
    _myUserId = Supabase.instance.client.auth.currentUser!.id;
    _initMessageStream();
  }

  Future<void> _initMessageStream() async {
    final stream = await _chatService.messageStream();
    setState(() {
      _messageStream = stream as Stream<List<Message>>?;
    });
    stream.listen((messages) {
      if (mounted && messages.length > _previousMessages.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
        _previousMessages = List.from(messages);
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _tomarYSubirFoto() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función de foto en desarrollo')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final drawerWidth = MediaQuery.of(context).size.width.clamp(280, 380).toDouble();

    return Drawer(
      width: drawerWidth,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: chatColor,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const Text(
                  'Chat',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const Spacer(),
                const Icon(Icons.chat_bubble_outline, color: Colors.white),
              ],
            ),
          ),
          Expanded(
            child: _messageStream == null
                ? const Center(child: CircularProgressIndicator())
                : StreamBuilder<List<Message>>(
                    stream: _messageStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
                      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                      final messages = snapshot.data!;
                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(6),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          final isMe = msg.userId == _myUserId;
                          final isImage = msg.content.startsWith('http');

                          return Align(
                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 3),
                              padding: const EdgeInsets.all(10),
                              constraints: BoxConstraints(maxWidth: drawerWidth * 0.75),
                              decoration: BoxDecoration(
                                color: isMe ? chatColor : receivedColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  isImage
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            msg.content,
                                            fit: BoxFit.cover,
                                            width: drawerWidth * 0.65,
                                          ),
                                        )
                                      : Text(
                                          msg.content,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: isMe ? Colors.white : Colors.black87,
                                          ),
                                        ),
                                  const SizedBox(height: 2),
                                  Text(
                                    DateFormat('HH:mm').format(
                                      msg.createdAt is String
                                          ? DateTime.parse(msg.createdAt as String)
                                          : msg.createdAt,
                                    ),
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: isMe ? Colors.white70 : Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.camera_alt, color: chatColor),
                  onPressed: _tomarYSubirFoto,
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Mensaje...',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onSubmitted: (text) async {
                      final trimmed = text.trim();
                      if (trimmed.isNotEmpty) {
                        await _chatService.sendMessage(_myUserId, trimmed);
                        _textController.clear();
                        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: chatColor),
                  onPressed: () async {
                    final text = _textController.text.trim();
                    if (text.isNotEmpty) {
                      await _chatService.sendMessage(_myUserId, text);
                      _textController.clear();
                      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
