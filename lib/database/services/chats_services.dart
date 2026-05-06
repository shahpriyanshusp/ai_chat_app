import 'package:ai_chat_app/database/app_database.dart';
import 'package:drift/drift.dart';

class ChatsServices {
  final db = AppDatabase();

  ChatsServices();

  Future<List<Chat>> getAllChats() async {
    final rows = await (db.select(db.chats)).get();
    return rows.map((e) {
      return Chat(
        id: e.id,
        title: e.title,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );
    }).toList();
  }

  Future<void> deleteChat(int id) {
    return (db.delete(db.chats)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> createChat(String title) {
    return db
        .into(db.chats)
        .insert(
          ChatsCompanion(
            title: Value(title),
            createdAt: Value(DateTime.now()),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }
}
