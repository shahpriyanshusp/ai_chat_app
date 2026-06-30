import 'package:ai_chat_app/data/datasource/chat_system_api_source.dart';
import 'package:ai_chat_app/database/services/message_services.dart';
import 'package:ai_chat_app/domain/entities/single_chat.dart';
import 'package:ai_chat_app/domain/repository/chat_repository.dart';
import 'package:ai_chat_app/models/chat_message_model.dart';

class ChatSystemRepo implements ChatRepository {
  final MessageServices db;
  final ChatSystemApiSource chatSystemApiSource;

  ChatSystemRepo(this.db, this.chatSystemApiSource);

  @override
  Future<String> sendMessage(List<ChatMessage> messages) async {
    return await chatSystemApiSource.sendMessage(messages);
  }

  @override
  Future<void> saveMessage(String role, String content, int chatId) async {
    await db.insertMessage(role, content, chatId);
  }

  @override
  Future<List<SingleChat>> getAllMessages(int chatId) async {
    return await db.getAllMessages(chatId);
  }

  @override
  Future<void> deleteMessage(int chatId) async {
    await db.clearMessages(chatId);
  }
}
