import 'package:ai_chat_app/domain/repository/chat_repository.dart';

class SendMessage {
  final ChatRepository chatRepository;

  SendMessage(this.chatRepository);

  Future<String> call(List<Map<String, String>> messages) async {
    return await chatRepository.sendMessage(messages);
  }
}
