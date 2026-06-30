import 'package:ai_chat_app/database/app_database.dart';
import 'package:ai_chat_app/database/services/chats_services.dart';
import 'package:ai_chat_app/database/services/message_services.dart';
import 'package:ai_chat_app/domain/entities/chats_system.dart';
import 'package:ai_chat_app/presentation/bloc/event/chat_list_event.dart';
import 'package:ai_chat_app/presentation/bloc/state/chat_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final ChatsServices chatServices = ChatsServices();
  final MessageServices messageServices = MessageServices();

  ChatListBloc()
    : super(ChatListState(chats: [], isLoading: false, error: null)) {
    on<GetAllChatsEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      // simulate API
      List<Chat> responseChats = await chatServices.getAllChats();

      List<ChatsSystem> chats = responseChats.map((e) {
        return ChatsSystem(
          chatId: e.id,
          title: e.title,
          createdAt: e.createdAt,
          lastUpdatedAt: e.updatedAt,
        );
      }).toList();

      emit(state.copyWith(chats: chats, isLoading: false));
    });

    on<CreateChatEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      await chatServices.createChat(event.title);

      emit(state.copyWith(isLoading: false));
    });

    on<DeleteChatEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      await chatServices.deleteChat(event.chatId);
      await messageServices.clearMessages(event.chatId);

      emit(state.copyWith(isLoading: false));
    });
  }
}
