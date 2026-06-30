import 'package:ai_chat_app/models/chat_message_model.dart';

class ChatState {
  final List<ChatMessage> messages;
  final bool isTyping;
  final bool isLoading;
  final String? error;

  ChatState({
    required this.messages,
    required this.isTyping,
    required this.isLoading,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
