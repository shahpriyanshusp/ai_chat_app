import 'package:ai_chat_app/database/services/chats_services.dart';
import 'package:ai_chat_app/database/services/message_services.dart';
import 'package:ai_chat_app/domain/repository/chat_repository.dart';
import 'package:ai_chat_app/domain/usecases/send_message.dart';
import 'package:ai_chat_app/models/chat_message_model.dart';
import 'package:ai_chat_app/presentation/bloc/event/chat_event.dart';
import 'package:ai_chat_app/presentation/bloc/state/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatsServices chatServices;
  final MessageServices messageServices;
  final SendMessage sendMessageApi;
  final ChatRepository chatRepository;

  ChatBloc(
    this.sendMessageApi,
    this.chatRepository,
    this.chatServices,
    this.messageServices,
  ) : super(ChatState(messages: [], isTyping: false, isLoading: false)) {
    on<SendUserMessageEvent>((event, emit) async {
      emit(state.copyWith(isTyping: true));
      add(SaveUserMessageEvent(event.message, event.chatId));
      String aiReply = await sendMessageApi.call(state.messages);
      add(SaveAIMessageEvent(aiReply, event.chatId));
      emit(state.copyWith(isTyping: false));
    });

    on<IntializedFirstAIMessage>((event, emit) async {
      final data = await chatRepository.getAllMessages(event.chatId);

      if (data.isEmpty) {
        await messageServices.insertMessage(
          "assistant",
          "You are a helpful assistant",
          event.chatId,
        );
        final updatedMessages = state.messages
          ..add(
            ChatMessage(
              role: "assistant",
              content: "You are a helpful assistant",
            ),
          );

        emit(state.copyWith(messages: updatedMessages));
      } else {
        final updatedMessages = state.messages
          ..addAll(
            data.map((e) => ChatMessage(role: e.role, content: e.content)),
          );

        emit(state.copyWith(messages: updatedMessages));
      }
    });

    on<SaveUserMessageEvent>((event, emit) async {
      await messageServices.insertMessage("user", event.message, event.chatId);
      final updatedMessages = state.messages
        ..add(ChatMessage(role: "user", content: event.message));

      emit(state.copyWith(messages: updatedMessages));
    });

    on<SaveAIMessageEvent>((event, emit) async {
      await messageServices.insertMessage(
        "assistant",
        event.message,
        event.chatId,
      );
      final updatedMessages = state.messages
        ..add(ChatMessage(role: "assistant", content: event.message));

      String currentText = "";

      for (int i = 0; i < event.message.length; i++) {
        await Future.delayed(const Duration(milliseconds: 5));

        currentText += event.message[i];

        final updatedMessages = [...state.messages];
        updatedMessages.last = updatedMessages.last.copyWith(
          content: currentText,
        );

        emit(state.copyWith(messages: updatedMessages));
      }

      emit(state.copyWith(isTyping: false, messages: updatedMessages));
    });
  }
}
