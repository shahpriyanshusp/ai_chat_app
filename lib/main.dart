import 'package:ai_chat_app/presentation/screens/chat_list_screen.dart';
import 'package:ai_chat_app/presentation/screens/chat_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ActualChatScreen(),
    );
  }
}
