import 'package:ai_chat_app/domain/repository/chat_repository.dart';

class SaveMessages {
  final ChatRepository chatRepository;

  SaveMessages(this.chatRepository);

  Future<void> call(String role, String content, int chatId) async {
    return await chatRepository.saveMessage(role, content, chatId);
  }
}
