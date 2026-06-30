import 'package:ai_chat_app/domain/entities/chats_system.dart';
import 'package:ai_chat_app/presentation/bloc/bloc/chat_bloc.dart';
import 'package:ai_chat_app/presentation/bloc/bloc/chat_list_bloc.dart';
import 'package:ai_chat_app/presentation/bloc/event/chat_list_event.dart';
import 'package:ai_chat_app/presentation/bloc/state/chat_list_state.dart';
import 'package:ai_chat_app/presentation/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActualChatScreen extends StatefulWidget {
  const ActualChatScreen({super.key});

  @override
  State<ActualChatScreen> createState() => _ActualChatScreenState();
}

class _ActualChatScreenState extends State<ActualChatScreen> {
  // final chatListController = ChatListController();

  @override
  void initState() {
    context.read<ChatListBloc>().add(GetAllChatsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Actual Chat')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          context.read<ChatListBloc>().add(
            CreateChatEvent("New Chat - ${DateTime.now()}"),
          );

          final chatBloc = context.read<ChatBloc>();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: chatBloc,
                child: ChatScreen(
                  chatId: context.read<ChatListBloc>().state.chats.last.chatId,
                ),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: BlocConsumer<ChatListBloc, ChatListState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        builder: (context, state) {
          if (state.chats.isNotEmpty) {
            return ListView.builder(
              itemCount: state.chats.length,
              itemBuilder: (context, index) {
                return buildChatSystem(state.chats[index]);
              },
            );
          } else if (state.error != null) {
            return Center(child: Text(state.error.toString()));
          } else if (state.chats.isEmpty) {
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
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => ChatScreen(chatId: chat.chatId),
            //   ),
            // );

            final chatBloc = context.read<ChatBloc>();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: chatBloc, // 2. Pass it down to the new route branch
                  child: ChatScreen(chatId: chat.chatId),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
