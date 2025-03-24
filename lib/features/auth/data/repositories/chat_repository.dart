import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatRepository {
  final String baseUrl = 'https://test.myfliqapp.com/api/v1';

  Future<List<Map<String, dynamic>>> fetchChats() async {
    final response = await http.get(Uri.parse('$baseUrl/chats'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((chat) => {
        'id': chat['id'].toString(),
        'name': chat['name'] ?? 'Unknown',
        'last_message': chat['last_message'] ?? '',
        'timestamp': chat['timestamp'] ?? '',
      }).toList();
    } else {
      throw Exception('Failed to load chats');
    }
  }

  Future<List<Map<String, dynamic>>> fetchChatBetweenUsers(
      String senderId, String receiverId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/chats/$senderId/$receiverId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];

      return data.map((msg) => {
        'sender_id': msg['sender_id'].toString(),
        'receiver_id': msg['receiver_id'].toString(),
        'message': msg['message'] ?? '',
        'created_at': msg['created_at'] ?? DateTime.now().toString(),
      }).toList();
    } else {
      throw Exception('❌ Failed to load chat between users');
    }
  }

  Future<void> sendMessage(
      String senderId, String receiverId, String message) async {
    final response = await http.post(
      Uri.parse('$baseUrl/chats/send'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'sender_id': senderId,
        'receiver_id': receiverId,
        'message': message,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('❌ Failed to send message');
    }
  }
}
