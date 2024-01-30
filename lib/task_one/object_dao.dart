import 'database_helper.dart';
import 'object_model.dart';

class ObjectDao {
  final dbHelper = DatabaseHelper();

  Future<int> insertObject(ObjectModel object) async {
    final db = await dbHelper.database;
    final result = await db?.insert('objects', object.toMap());
    return result ?? 0;
  }

  Future<List<ObjectModel>> getAllObjects() async {
    final db = await dbHelper.database;
    final List<Map<String, Object?>> maps = await db?.query('objects') ?? [];
    return List.generate(maps.length, (i) {
      return ObjectModel(
        id: maps[i]['id'] as int,
        name: maps[i]['name'] as String,
        description: maps[i]['description'] as String,
      );
    });
  }

  Future<int> updateObject(ObjectModel object) async {
    final db = await dbHelper.database;
    return await db?.update('objects', object.toMap(),
        where: 'id = ?', whereArgs: [object.id]) ?? 0;
  }

  Future<int> deleteObject(int id) async {
    final db = await dbHelper.database;
    return await db?.delete('objects', where: 'id = ?', whereArgs: [id]) ?? 0;
  }
}
