import 'package:ai_chat_app/domain/entities/single_chat.dart';

class SingleChatMessage extends SingleChat {
  SingleChatMessage({
    required super.role,
    required super.content,
    required super.createdAt,
  });

  factory SingleChatMessage.fromJson(Map<String, dynamic> json) {
    return SingleChatMessage(
      role: json["role"],
      content: json["content"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }
}
