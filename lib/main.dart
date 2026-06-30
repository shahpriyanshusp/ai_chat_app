import 'package:ai_chat_app/core/di/di.dart';
import 'package:ai_chat_app/presentation/bloc/bloc/chat_bloc.dart';
import 'package:ai_chat_app/presentation/bloc/bloc/chat_list_bloc.dart';
import 'package:ai_chat_app/core/di/di_injection_holder.dart';
import 'package:ai_chat_app/presentation/bloc/event/chat_list_event.dart';
import 'package:ai_chat_app/presentation/screens/chat_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 5. Service locator — the first frame's providers depend on it.
  await _safeInit('injections', initInjections(), const Duration(seconds: 5));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ChatListBloc()..add(GetAllChatsEvent())),

          BlocProvider(create: (_) => getSll<ChatBloc>()),
        ],
        child: const ActualChatScreen(),
      ),
    );
  }
}

/// Awaits [task] with a hard ceiling. A timeout or thrown error is logged
/// and swallowed so a hung step cannot ANR the launch. Used for every
/// pre-runApp await in [main].
Future<void> _safeInit(
  String label,
  Future<void> task,
  Duration ceiling,
) async {
  try {
    await task.timeout(ceiling);
  } catch (e) {
    debugPrint(
      '[Init] $label timed out/failed (ceiling ${ceiling.inSeconds}s): $e',
    );
  }
}
