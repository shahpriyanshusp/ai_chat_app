import 'package:ai_chat_app/domain/entities/single_chat.dart';

abstract class ChatRepository {
  Future<String> sendMessage(List<Map<String, String>> messages);
  Future<void> saveMessage(String role, String content, int chatId);
  Future<List<SingleChat>> getAllMessages(int chatId);
  Future<void> deleteMessage(int chatId);
}
