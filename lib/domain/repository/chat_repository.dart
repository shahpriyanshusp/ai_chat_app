import 'package:ai_chat_app/domain/entities/single_chat.dart';
import 'package:ai_chat_app/models/chat_message_model.dart';

abstract class ChatRepository {
  Future<String> sendMessage(List<ChatMessage> messages);
  Future<void> saveMessage(String role, String content, int chatId);
  Future<List<SingleChat>> getAllMessages(int chatId);
  Future<void> deleteMessage(int chatId);
}
