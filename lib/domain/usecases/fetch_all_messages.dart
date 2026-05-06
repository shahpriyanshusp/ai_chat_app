import 'package:ai_chat_app/domain/entities/single_chat.dart';
import 'package:ai_chat_app/domain/repository/chat_repository.dart';

class FetchAllMessages {
  final ChatRepository chatRepository;

  FetchAllMessages(this.chatRepository);

  Future<List<SingleChat>> call({required int chatId}) async {
    return await chatRepository.getAllMessages(chatId);
  }
}
