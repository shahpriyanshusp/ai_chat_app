import 'package:ai_chat_app/domain/entities/chats_system.dart';

class ChatListState {
  final List<ChatsSystem> chats;
  final bool isLoading;
  final String? error;

  ChatListState({required this.chats, required this.isLoading, this.error});

  ChatListState copyWith({
    List<ChatsSystem>? chats,
    bool? isLoading,
    String? error,
  }) {
    return ChatListState(
      chats: chats ?? this.chats,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
