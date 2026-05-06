import 'package:ai_chat_app/controller/chat_list_controller.dart';
import 'package:ai_chat_app/domain/entities/chats_system.dart';
import 'package:ai_chat_app/presentation/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class ActualChatScreen extends StatefulWidget {
  const ActualChatScreen({super.key});

  @override
  State<ActualChatScreen> createState() => _ActualChatScreenState();
}

class _ActualChatScreenState extends State<ActualChatScreen> {
  final chatListController = ChatListController();

  @override
  void initState() {
    chatListController.getAllChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Actual Chat')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          int chatId = await chatListController.createChat(
            title: "New Chat - ${DateTime.now()}",
          );
          setState(() {});
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen(chatId: chatId)),
          );
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: chatListController.getAllChats(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return buildChatSystem(snapshot.data![index]);
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.data?.isEmpty == true) {
            return const Center(child: Text("No chats yet"));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget buildChatSystem(ChatsSystem chat) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.grey[300],
        padding: EdgeInsets.all(10),
        child: ListTile(
          title: Text(chat.title),
          subtitle: Text(chat.lastUpdatedAt.toString()),
          leading: Icon(Icons.chat, size: 25, color: Colors.blue),
          trailing: Icon(Icons.delete),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(chatId: chat.chatId),
              ),
            );
          },
        ),
      ),
    );
  }
}
