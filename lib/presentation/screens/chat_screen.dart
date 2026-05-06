import 'package:ai_chat_app/data/datasource/chat_system_api_source.dart';
import 'package:ai_chat_app/data/repository/chat_system_repo.dart';
import 'package:ai_chat_app/database/app_database.dart';
import 'package:ai_chat_app/database/services/message_services.dart';
import 'package:ai_chat_app/domain/repository/chat_repository.dart';
import 'package:ai_chat_app/domain/usecases/send_message.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final int chatId;

  const ChatScreen({super.key, required this.chatId});
  @override
  State createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();
  late SendMessage sendMessageApi;
  late ChatRepository chatRepository;
  List<Map<String, String>> messages = [];
  bool isResponseLoading = false;

  ScrollController scrollController = ScrollController();

  late MessageServices db;

  @override
  void initState() {
    super.initState();
    db = MessageServices();
    chatRepository = ChatSystemRepo(db, ChatSystemApiSource());
    sendMessageApi = SendMessage(chatRepository);

    loadMessagesFromDb();
  }

  Future<void> loadMessagesFromDb() async {
    final data = await db.getAllMessages(widget.chatId);

    setState(() {
      messages = data
          .map((e) => {"role": e.role, "content": e.content})
          .toList();
    });

    if (messages.isEmpty) {
      initialMessage();
    }
  }

  void initialMessage() async {
    setState(() {
      isResponseLoading = true;
    });

    controller.clear();

    String aiReply = await sendMessageApi.call([
      {"role": "assistant", "content": "You are a helpful assistant"},
    ]);

    setState(() {
      messages.add({"role": "assistant", "content": aiReply});
      isResponseLoading = false;
    });
  }

  void sendMessage() async {
    try {
      if (controller.text.isEmpty) return;

      String userText = controller.text;

      // Save user message to DB
      await db.insertMessage("user", userText, widget.chatId);

      setState(() {
        isResponseLoading = true;
        messages.add({"role": "user", "content": userText});
      });

      controller.clear();

      String aiReply = await sendMessageApi.call(messages);

      // Save user message to DB
      await db.insertMessage("assistant", aiReply, widget.chatId);

      setState(() {
        messages.add({"role": "assistant", "content": aiReply});
        // isResponseLoading = false;
      });

      // Simulate typing
      await simulateTyping(aiReply);

      setState(() {
        isResponseLoading = false;
      });

      Future.delayed(Duration(milliseconds: 100), () {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
    } catch (exception) {
      debugPrint(exception.toString());
    }
  }

  Widget buildMessage(Map<String, String> msg) {
    bool isUser = msg["role"] == "user";
    bool isSystem = msg["role"] == "assistant";

    return Column(
      children: [
        Container(
          alignment: isUser
              ? Alignment.centerRight
              : isSystem
              ? Alignment.centerLeft
              : Alignment.centerLeft,
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isUser ? Colors.blue : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              msg["content"]!,
              style: TextStyle(color: isUser ? Colors.white : Colors.black),
            ),
          ),
        ),

        Text(DateTime.now().toString(), style: TextStyle(fontSize: 10)),
      ],
    );
  }

  Future<void> simulateTyping(String fullText) async {
    String currentText = "";

    for (int i = 0; i < fullText.length; i++) {
      await Future.delayed(Duration(milliseconds: 5));

      currentText += fullText[i];

      setState(() {
        messages[messages.length - 1]["content"] = currentText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Chat"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await db.clearMessages(widget.chatId);

              setState(() {
                messages.clear();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: scrollController,
              children: messages.map(buildMessage).toList(),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Type message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              isResponseLoading
                  ? CircularProgressIndicator()
                  : IconButton(icon: Icon(Icons.send), onPressed: sendMessage),
            ],
          ),
        ],
      ),
    );
  }
}
