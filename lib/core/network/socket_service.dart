import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void connect(String userId) {
    socket = IO.io(
      'https://flutter-socket-server.shifasmehar.repl.co',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'query': {'userId': userId},
      },
    );

    socket.onConnect((_) {
      print('Connected to Socket.IO');
    });

    socket.onDisconnect((_) {
      print('Disconnected from Socket.IO');
    });

    socket.connect();
  }

  void sendMessage(String senderId, String receiverId, String message) {
    socket.emit('send_message', {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
    });
  }

  void onNewMessage(Function(dynamic) callback) {
    socket.on('new_message', (data) => callback(data));
  }

  void disconnect() {
    socket.disconnect();
  }
}
