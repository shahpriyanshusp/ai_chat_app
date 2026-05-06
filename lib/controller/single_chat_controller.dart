import 'package:ai_chat_app/database/app_database.dart';
import 'package:ai_chat_app/database/services/message_services.dart';
import 'package:ai_chat_app/domain/entities/single_chat.dart';

class SingleChatController {
  final MessageServices db;

  SingleChatController(this.db);

  Future<void> saveUserMessage({
    required String text,
    required int chatId,
  }) async {
    await db.insertMessage("user", text, chatId);
  }

  Future<void> saveAIMessage({
    required String text,
    required int chatId,
  }) async {
    await db.insertMessage("assistant", text, chatId);
  }

  Future<List<SingleChat>> getAllMessages({required int chatId}) async {
    return await db.getAllMessages(chatId);
  }

  Future<void> deleteMessage({required int chatId}) async {
    await db.clearMessages(chatId);
  }
}
