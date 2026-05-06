import 'dart:convert';
import 'package:ai_chat_app/core/constant.dart';
import 'package:http/http.dart' as http;

class ChatSystemApiSource {
  Future<String> sendMessage(List<Map<String, String>> messages) async {
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/chat"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"messages": messages}),
    );

    final data = jsonDecode(response.body);
    return data["reply"];
  }
}
