import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';

class ChatDetailScreen extends StatefulWidget {
  final String senderId;
  final String receiverId;
  final String receiverName;

  const ChatDetailScreen({
    super.key,
    required this.senderId,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController messageController = TextEditingController();
  late ChatProvider chatProvider;
  bool _isSocketConnected = false;

  @override
  void initState() {
    super.initState();
    chatProvider = Provider.of<ChatProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatProvider.fetchChatBetweenUsers(widget.senderId, widget.receiverId);
      if (!_isSocketConnected) {
        chatProvider.connectToSocket(widget.senderId);
        _isSocketConnected = true;
      }
    });
  }

  @override
  void dispose() {
    chatProvider.disconnectSocket();
    messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = messageController.text.trim();
    if (message.isNotEmpty) {
      chatProvider.sendMessage(
        widget.senderId,
        widget.receiverId,
        message,
      );
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          children: [
            CircleAvatar(radius: 15,child: Icon(Icons.person),),
            SizedBox(width: 5,),
            Text(widget.receiverName),
          ],
        ),
      ),
      body: Column(
        children: [
          // Chat message list
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, provider, child) {
                if (provider.messages.isEmpty) {
                  return const Center(
                    child: Text('No messages yet.'),
                  );
                }

                return ListView.builder(
                  itemCount: provider.messages.length,
                  itemBuilder: (context, index) {
                    final message = provider.messages[index];

                    final senderId = message['sender_id']?.toString() ?? '';
                    final messageText = message['message'] ?? '';

                    final isSentByMe = senderId == widget.senderId;

                    return Align(
                      alignment: isSentByMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: isSentByMe ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          messageText,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send,color: Colors.pink,),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
