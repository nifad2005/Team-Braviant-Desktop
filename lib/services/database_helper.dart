import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/team_member.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory, 'team_braviant.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE team_members(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        role TEXT
      )
      '''
    );
  }

  Future<int> insertMember(TeamMember member) async {
    Database db = await database;
    return await db.insert(
      'team_members',
      member.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TeamMember>> getMembers() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('team_members');

    return List.generate(maps.length, (i) {
      return TeamMember.fromMap(maps[i]);
    });
  }

  Future<int> updateMember(TeamMember member) async {
    Database db = await database;
    return await db.update(
      'team_members',
      member.toMap(),
      where: 'id = ?',
      whereArgs: [member.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteMember(int id) async {
    Database db = await database;
    return await db.delete(
      'team_members',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
