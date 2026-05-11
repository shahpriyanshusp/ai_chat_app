import 'dart:io';
import 'package:ai_chat_app/database/tabels/chats_table.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tabels/messages_table.dart';
part 'app_database.g.dart';

@DriftDatabase(tables: [Messages, Chats])
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(_openConnection());

  static final AppDatabase _instance = AppDatabase._internal();

  factory AppDatabase() => _instance;

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 3) {
        await migrator.addColumn(chats, chats.updatedAt);
      }

      if (from < 2) {
        // 1. Add new column to Messages
        await migrator.addColumn(messages, messages.chatId);

        // 2. Create any new tables
        await migrator.createTable(chats);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'chat.db'));
    return NativeDatabase(file);
  });
}
