import 'package:ai_chat_app/data/datasource/chat_system_api_source.dart';
import 'package:ai_chat_app/data/repository/chat_system_repo.dart';
import 'package:ai_chat_app/database/services/message_services.dart';
import 'package:ai_chat_app/domain/repository/chat_repository.dart';
import 'package:ai_chat_app/domain/usecases/send_message.dart';
import 'package:ai_chat_app/models/chat_message_model.dart';
import 'package:ai_chat_app/presentation/bloc/bloc/chat_bloc.dart';
import 'package:ai_chat_app/presentation/bloc/event/chat_event.dart';
import 'package:ai_chat_app/presentation/bloc/state/chat_state.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  final int chatId;

  const ChatScreen({super.key, required this.chatId});
  @override
  State createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();
  // late SendMessage sendMessageApi;
  // late ChatRepository chatRepository;
  // List<Map<String, String>> messages = [];
  // bool isResponseLoading = false;

  ScrollController scrollController = ScrollController();

  // late MessageServices db;

  @override
  void initState() {
    super.initState();
    // db = MessageServices();
    // chatRepository = ChatSystemRepo(db, ChatSystemApiSource());
    // sendMessageApi = SendMessage(chatRepository);

    // loadMessagesFromDb();

    context.read<ChatBloc>().add(IntializedFirstAIMessage(widget.chatId));
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  // Future<void> loadMessagesFromDb() async {
  //   final data = await db.getAllMessages(widget.chatId);

  //   setState(() {
  //     messages = data
  //         .map((e) => {"role": e.role, "content": e.content})
  //         .toList();
  //   });

  //   if (messages.isEmpty) {
  //     initialMessage();
  //   }
  // }

  // void initialMessage() async {
  //   setState(() {
  //     isResponseLoading = true;
  //   });

  //   controller.clear();

  //   String aiReply = await sendMessageApi.call([
  //     {"role": "assistant", "content": "You are a helpful assistant"},
  //   ]);

  //   setState(() {
  //     messages.add({"role": "assistant", "content": aiReply});
  //     isResponseLoading = false;
  //   });
  // }

  // void sendMessage() async {
  //   try {
  //     if (controller.text.isEmpty) return;

  //     String userText = controller.text;

  //     // Save user message to DB
  //     await db.insertMessage("user", userText, widget.chatId);

  //     setState(() {
  //       isResponseLoading = true;
  //       messages.add({"role": "user", "content": userText});
  //     });

  //     controller.clear();

  //     String aiReply = await sendMessageApi.call(messages);

  //     // Save user message to DB
  //     await db.insertMessage("assistant", aiReply, widget.chatId);

  //     setState(() {
  //       messages.add({"role": "assistant", "content": aiReply});
  //       // isResponseLoading = false;
  //     });

  //     // Simulate typing
  //     await simulateTyping(aiReply);

  //     setState(() {
  //       isResponseLoading = false;
  //     });

  //     Future.delayed(Duration(milliseconds: 100), () {
  //       scrollController.jumpTo(scrollController.position.maxScrollExtent);
  //     });
  //   } catch (exception) {
  //     debugPrint(exception.toString());
  //   }
  // }

  Widget buildMessage(ChatMessage msg) {
    bool isUser = msg.role == "user";
    bool isSystem = msg.role == "assistant";

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
              msg.content,
              style: TextStyle(color: isUser ? Colors.white : Colors.black),
            ),
          ),
        ),

        Text(DateTime.now().toString(), style: TextStyle(fontSize: 10)),
      ],
    );
  }

  // Future<void> simulateTyping(String fullText, ChatState state) async {
  //   String currentText = "";

  //   for (int i = 0; i < fullText.length; i++) {
  //     await Future.delayed(Duration(milliseconds: 5));

  //     currentText += fullText[i];

  //     setState(() {
  //       messages[messages.length - 1]["content"] = currentText;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Chat"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () =>
                context.read<ChatBloc>().add(DeleteChatEvent(widget.chatId)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                return ListView.builder(
                  controller: scrollController,
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    return buildMessage(state.messages[index]);
                  },
                );
              },
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
              BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  return state.isLoading || state.isTyping
                      ? const CircularProgressIndicator()
                      : IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            final text = controller.text.trim();

                            if (text.isEmpty) return;

                            context.read<ChatBloc>().add(
                              SendUserMessageEvent(text, widget.chatId),
                            );

                            controller.clear();
                          },
                        );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
