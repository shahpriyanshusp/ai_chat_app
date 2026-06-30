import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class IntializedFirstAIMessage extends ChatEvent {
  final int chatId;
  const IntializedFirstAIMessage(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class SaveUserMessageEvent extends ChatEvent {
  final String message;
  final int chatId;
  const SaveUserMessageEvent(this.message, this.chatId);

  @override
  List<Object?> get props => [message, chatId];
}

class SaveAIMessageEvent extends ChatEvent {
  final String message;
  final int chatId;
  const SaveAIMessageEvent(this.message, this.chatId);

  @override
  List<Object?> get props => [message, chatId];
}


class SendUserMessageEvent extends ChatEvent {
  final String message;
  final int chatId;
  // final List<Map<String, String>> messages;
  const SendUserMessageEvent(this.message, this.chatId);

  @override
  List<Object?> get props => [message, chatId];
}

class ClearMessagesEvent extends ChatEvent {
  final int chatId;
  const ClearMessagesEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class GetAllMessagesEvent extends ChatEvent {
  final int chatId;
  const GetAllMessagesEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class DeleteChatEvent extends ChatEvent {
  final int chatId;
  const DeleteChatEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}
