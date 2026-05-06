import 'package:ai_chat_app/presentation/bloc/event/chat_event.dart';
import 'package:ai_chat_app/presentation/bloc/state/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc()
    : super(ChatState(messages: [], isTyping: false, isLoading: false)) {
    on<SendMessageEvent>((event, emit) async {
      emit(state.copyWith(isTyping: true));

      // simulate API
      await Future.delayed(Duration(seconds: 2));

      final updatedMessages = List<Map<String, String>>.from(state.messages)
        ..add({"user": event.message})
        ..add({"assistant": "Hello!"});

      emit(state.copyWith(messages: updatedMessages, isTyping: false));
    });
  }
}
