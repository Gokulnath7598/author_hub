import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import '../models/messages_response.dart';
import 'utils/utils.dart';

class MessageDBHelper {
  static const String _databaseName = 'message.db';
  static const String _tableName = 'message';

  static Future<Database> getDatabase() async {
    final String databasePath = await getDatabasesPath();
    final String fullPath = path.join(databasePath, _databaseName);

    return openDatabase(
      fullPath,
      onCreate: (Database db, int version) {
        db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY,
            content TEXT, 
            updated TEXT,
            is_favourite INTEGER,
            author_name TEXT,
            author_photoUrl TEXT      
            )
        ''');
      },
      version: 1,
    );
  }

  // clear table
  static Future<void> clearAllMessages() async {
    final Database db = await getDatabase();
    await db.delete(_tableName);
  }

  // get table data
  static Future<List<Message>> getAllMessages() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List<Message>.generate(maps.length, (int i) {
      return Utils.constructMessageObject(maps[i]);
    });
  }

  // delete table data
  static Future<void> deleteMessage({required Message? message}) async {
    final Database db = await getDatabase();
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: <Object?>[message?.id],
    );
  }

  // delete table data
  static Future<Message?> getMessage({required int? id}) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: <Object?>[id],
    );

    if (result.isNotEmpty) {
      final Map<String, dynamic> messageJson = result.first;
      return Utils.constructMessageObject(messageJson);
    }
    return null;
  }

  // sync table data
  static Future<void> syncMessages(List<Message> messages) async {

    final Database db = await getDatabase();
    final Batch batch = db.batch();

    for (final Message message in messages) {
      batch.insert(_tableName, Utils.constructMessageJSON(message));
    }

    await batch.commit();
  }

  // search table data
  static Future<List<Message>> searchMessage(String name) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'message',
      where: 'author_name LIKE ?',
      whereArgs: <Object?>['%$name%'],
    );

    return List<Message>.generate(maps.length, (int i) {
      return Utils.constructMessageObject(maps[i]);
    });
  }

  // search table data
  static Future<int> updateFavourite({required Message? message}) async {
    final Database db = await getDatabase();
    return db.update(
      _tableName,
      Utils.constructMessageJSON(message, isFavouriteUpdate: true),
      where: 'id = ?',
      whereArgs: <Object?>[message?.id],
    );
  }
}
