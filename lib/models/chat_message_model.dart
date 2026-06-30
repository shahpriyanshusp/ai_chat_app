class ChatMessage {
  final String role;
  final String content;

  ChatMessage({required this.role, required this.content});

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(role: map['role'], content: map['content']);
  }

  Map<String, dynamic> toMap() {
    return {'role': role, 'content': content};
  }

  ChatMessage copyWith({String? role, String? content}) {
    return ChatMessage(
      role: role ?? this.role,
      content: content ?? this.content,
    );
  }
}
