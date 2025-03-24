import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import 'chat_details.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ChatProvider>(context, listen: false).fetchChats();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body:
      chatProvider.chatList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          :
      ListView.builder(
        itemCount: chatProvider.chatList.length,
        itemBuilder: (context, index) {
          final chat = chatProvider.chatList[index];
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(chat['name'] ?? 'Unknown'),
            subtitle: Text(chat['last_message'] ?? ''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailScreen(
                    senderId: '1',  // Your ID
                    receiverId: chat['id'].toString(),
                    receiverName: chat['name'],
                  ),
                ),
              );
            },
          );
        },
      ),

    );
  }
}
