import 'package:ai_chat_app/data/datasource/chat_system_api_source.dart';
import 'package:ai_chat_app/data/repository/chat_system_repo.dart';
import 'package:ai_chat_app/database/services/chats_services.dart';
import 'package:ai_chat_app/database/services/message_services.dart';
import 'package:ai_chat_app/domain/repository/chat_repository.dart';
import 'package:ai_chat_app/domain/usecases/fetch_all_messages.dart';
import 'package:ai_chat_app/domain/usecases/save_messages.dart';
import 'package:ai_chat_app/domain/usecases/send_message.dart';
import 'package:ai_chat_app/presentation/bloc/bloc/chat_bloc.dart';
import 'package:get_it/get_it.dart';

final GetIt getSll = GetIt.instance;

void initChatDependencies() {
  // Services
  getSll.registerLazySingleton(() => ChatsServices());

  getSll.registerLazySingleton(() => MessageServices());

  // API
  getSll.registerLazySingleton(() => ChatSystemApiSource());

  // Repository
  getSll.registerLazySingleton<ChatRepository>(
    () => ChatSystemRepo(
      getSll<MessageServices>(),
      getSll<ChatSystemApiSource>(),
    ),
  );

  // Use cases
  getSll.registerLazySingleton(() => SendMessage(getSll<ChatRepository>()));

  getSll.registerLazySingleton(() => SaveMessages(getSll<ChatRepository>()));

  getSll.registerLazySingleton(
    () => FetchAllMessages(getSll<ChatRepository>()),
  );

  // Bloc
  getSll.registerFactory(
    () => ChatBloc(
      getSll<SendMessage>(),
      getSll<ChatRepository>(),
      getSll<ChatsServices>(),
      getSll<MessageServices>(),
    ),
  );
}
