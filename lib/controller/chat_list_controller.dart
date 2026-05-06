import 'package:ai_chat_app/database/app_database.dart';
import 'package:ai_chat_app/database/services/chats_services.dart';
import 'package:ai_chat_app/database/services/message_services.dart';
import 'package:ai_chat_app/domain/entities/chats_system.dart';

class ChatListController {
  final ChatsServices chatServices = ChatsServices();
  final MessageServices messageServices = MessageServices();

  ChatListController();

  Future<List<ChatsSystem>> getAllChats() async {
    List<Chat> responseChats = await chatServices.getAllChats();

    return responseChats.map((e) {
      return ChatsSystem(
        chatId: e.id,
        title: e.title,
        createdAt: e.createdAt,
        lastUpdatedAt: e.updatedAt,
      );
    }).toList();
  }

  Future<void> deleteChat({required int chatId}) async {
    await chatServices.deleteChat(chatId);
    await messageServices.clearMessages(chatId);
  }

  Future<int> createChat({required String title}) async {
    int id = await chatServices.createChat(title);
    return id;
  }
}
