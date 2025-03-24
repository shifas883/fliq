import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../data/repositories/chat_repository.dart';

class ChatProvider with ChangeNotifier {
  final ChatRepository repository;

  List<Map<String, dynamic>> _chatList = [];
  List<Map<String, dynamic>> _messages = [];
  IO.Socket? _socket;

  List<Map<String, dynamic>> get chatList => _chatList;
  List<Map<String, dynamic>> get messages => _messages;

  ChatProvider({required this.repository});

  Future<void> fetchChats() async {
    try {
      _chatList = await repository.fetchChats();
      notifyListeners();
    } catch (e) {
      print('❌ Failed to load chats: $e');
    }
  }

  Future<void> fetchChatBetweenUsers(String senderId, String receiverId) async {
    try {
      _messages = await repository.fetchChatBetweenUsers(senderId, receiverId);
      notifyListeners();
    } catch (e) {
      print('❌ Failed to load messages: $e');
    }
  }

  void connectToSocket(String senderId) {
    if (_socket != null && _socket!.connected) return;

    _socket = IO.io(
      'https://flutter-socket-server.shifasmehar.repl.co',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    _socket!.onConnect((_) {
      print('✅ Connected to socket');
      _socket!.emit('user_connected', {'user_id': senderId});
    });

    _socket!.on('receive_message', (data) {
      print('📥 New message received: $data');

      if (data != null && data is Map<String, dynamic>) {
        _messages.add({
          'sender_id': data['sender_id'],
          'receiver_id': data['receiver_id'],
          'message': data['message'],
          'created_at': data['created_at'] ?? DateTime.now().toString(),
        });
        notifyListeners();
      }
    });

    _socket!.onDisconnect((_) => print('❌ Socket disconnected'));
  }

  void disconnectSocket() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket = null;
    }
  }

  void sendMessage(String senderId, String receiverId, String message) {
    if (_socket != null && _socket!.connected) {
      final messageData = {
        'sender_id': senderId,
        'receiver_id': receiverId,
        'message': message,
        'created_at': DateTime.now().toIso8601String(),
      };

      _socket!.emit('send_message', messageData);

      _messages.add(messageData);
      notifyListeners();
    } else {
      print('❌ Socket not connected, unable to send message');
    }
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}
