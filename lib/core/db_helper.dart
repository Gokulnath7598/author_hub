import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import '../models/messages_response.dart';

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
      return Message(
        id: maps[i]['id'] as int?,
        content: maps[i]['content'] as String?,
        updated: maps[i]['updated'] as String?,
        isFavourite: (maps[i]['is_favourite'] == 1) as bool?,
        author: Author(
          name: maps[i]['author_name'] as String?,
          photoUrl: maps[i]['author_photoUrl'] as String?,
        ),
      );
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
      return Message(
        id: messageJson['id'] as int?,
        content: messageJson['content'] as String?,
        updated: messageJson['updated'] as String?,
        isFavourite: (messageJson['is_favourite'] == 1) as bool?,
        author: Author(
          name: messageJson['author_name'] as String?,
          photoUrl: messageJson['author_photoUrl'] as String?,
        ),
      );
    }
    return null;
  }

  // sync table data
  static Future<void> syncMessages(List<Message> messages) async {

    final Database db = await getDatabase();
    final Batch batch = db.batch();

    for (final Message message in messages) {
      batch.insert(_tableName, <String, Object?>{
        'id': message.id,
        'content': message.content,
        'updated': message.updated,
        'is_favourite': (message.isFavourite ?? false) ? 1:0,
        'author_name': message.author?.name,
        'author_photoUrl': message.author?.photoUrl,
      });
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
      return Message(
        id: maps[i]['id'] as int?,
        content: maps[i]['content'] as String?,
        updated: maps[i]['updated'] as String?,
        isFavourite: (maps[i]['is_favourite'] == 1) as bool?,
        author: Author(
          name: maps[i]['author_name'] as String?,
          photoUrl: maps[i]['author_photoUrl'] as String?,
        ),
      );
    });
  }

  static Future<int> updateFavourite({required Message? message}) async {
    final Database db = await getDatabase();
    return db.update(
      _tableName,
      <String, Object?>{
        'id': message?.id,
        'content': message?.content,
        'updated': message?.updated,
        'is_favourite': !(message?.isFavourite ?? false) ? 1:0,
        'author_name': message?.author?.name,
        'author_photoUrl': message?.author?.photoUrl,
      },
      where: 'id = ?',
      whereArgs: <Object?>[message?.id],
    );
  }
}
