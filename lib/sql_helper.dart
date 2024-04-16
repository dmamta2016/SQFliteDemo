import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'dart:developer';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'moviemodel.dart';
class SQLHelper {

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }
  static Future<Database> initDatabase() async {
    final getDirectory = await getApplicationDocumentsDirectory();
    String path = getDirectory.path + '/movies.db';
    log(path);
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  static void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE Movies(id TEXT PRIMARY KEY, title TEXT, language TEXT, year INTEGER)');
    log('TABLE CREATED');
  }

  static Future<void>addMovie(MovieModel movie) async {
    final db = await SQLHelper.initDatabase();
    final id = await db.insert('movies', movie.toMap());
    print("inserted");
    log('inserted $id');
  }

  // List all movies
  /*static Future<List<Map<String, dynamic>>> getMovies() async {
    final db = await SQLHelper.initDatabase();
    return db.query('movies', orderBy: "id");
  }*/


  static Future<List<MovieModel>> getAllMovies() async {
    final db = await SQLHelper.initDatabase();
    var data = await db.query('movies', orderBy: "id");
    List<MovieModel> movies =
    List.generate(data.length, (index) => MovieModel.fromJson(data[index]));
    print(movies.length);
    return movies;
  }
/*
  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id, String title, String? descrption) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': descrption,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }*/
}