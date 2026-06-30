import 'package:ai_chat_app/domain/repository/chat_repository.dart';
import 'package:ai_chat_app/models/chat_message_model.dart';

class SendMessage {
  final ChatRepository chatRepository;

  SendMessage(this.chatRepository);

  Future<String> call(List<ChatMessage> messages) async {
    return await chatRepository.sendMessage(messages);
  }
}
