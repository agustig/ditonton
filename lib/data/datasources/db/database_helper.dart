import 'dart:async';

import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_table.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    if (_database == null) {
      _database = await _initDb();
    }
    return _database;
  }

  static const String _tblMovieWatchlist = 'movie_watchlist';
  static const String _tblTvWatchlist = 'tv_watchlist';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';

    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblMovieWatchlist (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        poster_path TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE  $_tblTvWatchlist (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        poster_path TEXT
      );
    ''');
  }

  Future<int> insertMovieToWatchlist(MovieTable movie) async {
    final db = await database;
    return await db!.insert(_tblMovieWatchlist, movie.toJson());
  }

  Future<int> removeMovieFromWatchlist(MovieTable movie) async {
    final db = await database;
    return await db!.delete(
      _tblMovieWatchlist,
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  Future<Map<String, dynamic>?> getMovieById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblMovieWatchlist,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> results =
        await db!.query(_tblMovieWatchlist);
    return results;
  }

  Future<int> insertTvToWatchlist(TvTable tv) async =>
      await _insertWatchlist(_tblTvWatchlist, tv.toJson());

  Future<Map<String, dynamic>?> getTvById(int id) async =>
      await _getWatchListById(_tblTvWatchlist, id);

  Future<int> removeTvFromWatchlist(TvTable tv) async =>
      await _removeWatchlist(_tblTvWatchlist, tv.id);

  Future<List<Map<String, dynamic>>> getWatchlistTvs() async {
    final db = await database;
    final result = await db!.query(_tblTvWatchlist);

    return result;
  }

  Future<int> _insertWatchlist(
    String tableName,
    Map<String, dynamic> jsonData,
  ) async {
    final db = await database;
    return await db!.insert(tableName, jsonData);
  }

  Future<int> _removeWatchlist(String tableName, int id) async {
    final db = await database;
    return await db!.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> _getWatchListById(
    String tableName,
    int id,
  ) async {
    final db = await database;
    final results = await db!.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }
}
