import 'package:equatable/equatable.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();

  @override
  List<Object?> get props => [];
}

class GetAllChatsEvent extends ChatListEvent {
  const GetAllChatsEvent();

  @override
  List<Object?> get props => [];
}

class CreateChatEvent extends ChatListEvent {
  final String title;
  const CreateChatEvent(this.title);

  @override
  List<Object?> get props => [title];
}

class DeleteChatEvent extends ChatListEvent {
  final int chatId;
  const DeleteChatEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}
