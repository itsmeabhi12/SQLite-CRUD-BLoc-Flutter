import 'package:dbsearch/db/usermodel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UsernameDB {
  static final UsernameDB instance = UsernameDB._init(); //Singleton Class

  Database? _database; //Create DB instance

  UsernameDB._init(); //Private Named Constructor

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('usernames.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('CREATE TABLE username(id $idType, name $textType)');
  }

  Future<UserModel> create(UserModel userModel) async {
    final db = await instance.database;

    final id =
        await db.insert('username', userModel.toJson(userModel: userModel));

    return userModel.copyWith(id: id);
  }

  Future<UserModel?> getuser(int id) async {
    final db = await instance.database;
    final user = await db.query('username',
        columns: ['id', 'name'], where: 'id = ?', whereArgs: [id]);
    if (user.isNotEmpty) {
      return UserModel.fromJson(user.first);
    } else {
      throw Exception('Not Found');
    }
  }

  Future<List<UserModel>> getalluser() async {
    final db = await instance.database;
    final users = await db.query(
      'username',
      columns: ['id', 'name'],
    );
    return users.map((e) => UserModel.fromJson(e)).toList();
  }

  Future<void> updateUser(UserModel user) async {
    final db = await instance.database;
    await db.update('username', user.toJson(userModel: user),
        where: 'id =?', whereArgs: [user.id]);
  }

  Future<void> deleteUser(int id) async {
    final db = await instance.database;
    db.delete('username', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<UserModel>> searchUser(String keyword) async {
    final db = await instance.database;
    final users = await db.query('username',
        columns: ['id', 'name'], where: 'name LIKE "$keyword%"');
    return users.map((e) => UserModel.fromJson(e)).toList();
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
