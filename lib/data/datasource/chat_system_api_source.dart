import 'dart:convert';
import 'package:ai_chat_app/core/constant.dart';
import 'package:ai_chat_app/models/chat_message_model.dart';
import 'package:http/http.dart' as http;

class ChatSystemApiSource {
  Future<String> sendMessage(List<ChatMessage> messages) async {
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/chat"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"messages": messages.map((e) => e.toMap()).toList()}),
    );

    final data = jsonDecode(response.body);
    return data["reply"];
  }
}
