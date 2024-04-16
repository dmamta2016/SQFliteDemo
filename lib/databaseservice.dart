import 'dart:developer';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'moviemodel.dart';

class DatabaseService {
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }
  Future<Database> initDatabase() async {
    final getDirectory = await getApplicationDocumentsDirectory();
    String path = getDirectory.path + '/movies.db';
    log(path);
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
    'CREATE TABLE Movies(id TEXT PRIMARY KEY, title TEXT, language TEXT, year INTEGER)');
    log('TABLE CREATED');
  }

   Future<void>addMovie(MovieModel movie) async {
    final db = await _databaseService.initDatabase();
    final id = await db.insert('movies', movie.toMap());
     log('inserted $id');
  }

   Future<List<MovieModel>> getAllMovies() async {
    final db = await _databaseService.initDatabase();
    var data = await db.query('movies', orderBy: "id");
    List<MovieModel> movies =
    List.generate(data.length, (index) => MovieModel.fromJson(data[index]));
    return movies;
  }

   Future<void> updateMovie(MovieModel movie) async {
    final db = await _databaseService.database;
    var data = await db.update('Movies', movie.toMap(), where: 'id = ?', whereArgs: [movie.id]);
     log('updated $data');
  }

  Future<void> deleteMovie(String id) async {
    final db = await _databaseService.database;
    var data = await db.delete('Movies', where: 'id = ?', whereArgs: [id]);
    log('deleted $data');
  }
}
