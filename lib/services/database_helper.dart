import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/team_member.dart';
import 'package:flutter/foundation.dart'; // Import for debugPrint

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
    try {
      final id = await db.insert(
        'team_members',
        member.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint('Inserted member with id: $id');
      return id;
    } catch (e) {
      debugPrint('Error inserting member: $e');
      rethrow; // Rethrow the exception to be handled by the caller
    }
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
    try {
      final rowsAffected = await db.update(
        'team_members',
        member.toMap(),
        where: 'id = ?',
        whereArgs: [member.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint('Updated member with id: ${member.id}, rows affected: $rowsAffected');
      return rowsAffected;
    } catch (e) {
      debugPrint('Error updating member: $e');
      rethrow; // Rethrow the exception to be handled by the caller
    }
  }

  Future<int> deleteMember(int id) async {
    Database db = await database;
    try {
      final rowsAffected = await db.delete(
        'team_members',
        where: 'id = ?',
        whereArgs: [id],
      );
      debugPrint('Deleted member with id: $id, rows affected: $rowsAffected');
      return rowsAffected;
    } catch (e) {
      debugPrint('Error deleting member: $e');
      rethrow; // Rethrow the exception to be handled by the caller
    }
  }
}
