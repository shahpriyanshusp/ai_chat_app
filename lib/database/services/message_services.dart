import 'package:ai_chat_app/data/models/response/single_chat_message.dart';
import 'package:ai_chat_app/database/app_database.dart';
import 'package:ai_chat_app/domain/entities/single_chat.dart';
import 'package:drift/drift.dart';

class MessageServices {
  final db = AppDatabase();

  MessageServices();

  Future<void> insertMessage(String role, String content, int chatId) {
    return db
        .into(db.messages)
        .insert(
          MessagesCompanion(
            role: Value(role),
            content: Value(content),
            createdAt: Value(DateTime.now()),
            chatId: Value(chatId),
          ),
        );
  }

  Future<List<SingleChat>> getAllMessages(int chatId) async {
    final rows =
        await (db.select(db.messages)
              ..where((tbl) => tbl.chatId.equals(chatId))
              ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
            .get();

    return rows.map((e) {
      return SingleChatMessage(
        role: e.role,
        content: e.content,
        createdAt: e.createdAt,
      );
    }).toList();
  }

  Future<void> clearMessages(int chatId) {
    return (db.delete(
      db.messages,
    )..where((tbl) => tbl.chatId.equals(chatId))).go();
  }
}
