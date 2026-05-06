import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class SendMessageEvent extends ChatEvent {
  final String message;
  const SendMessageEvent(this.message);

  @override
  List<Object?> get props => [message];
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

class CreateChatEvent extends ChatEvent {
  final String title;
  const CreateChatEvent(this.title);

  @override
  List<Object?> get props => [title];
}

class DeleteChatEvent extends ChatEvent {
  final int chatId;
  const DeleteChatEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class GetAllChatsEvent extends ChatEvent {
  const GetAllChatsEvent();

  @override
  List<Object?> get props => [];
}
