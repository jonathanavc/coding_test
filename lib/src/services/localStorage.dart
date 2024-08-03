import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:coding_test/src/models/article.dart';
import 'dart:async';

class localStorage {
  static final localStorage _instance = localStorage._internal();
  factory localStorage() => _instance;

  localStorage._internal() {
    _init();
  }

  late final Database _database;
  final Completer<void> _initCompleter = Completer<void>();

  Future<void> _init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'articles.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE articles(id INTEGER PRIMARY KEY, storyTitle TEXT, author TEXT, createdAt DATETIME)',
        );
      },
      version: 1,
    );
    _initCompleter.complete();
  }

  Future<void> _ensureInitialized() async {
    if (!_initCompleter.isCompleted) {
      await _initCompleter.future;
    }
  }

  Future<void> insertArticle(Article article) async {
    await _ensureInitialized();
    await _database.insert(
      'articles',
      article.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertArticles(List<Article> articles) async {
    await _ensureInitialized();
    final batch = _database.batch();
    for (final article in articles) {
      batch.insert(
        'articles',
        article.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Article>> articles() async {
    await _ensureInitialized();
    final List<Map<String, dynamic>> maps =
        await _database.query('articles', orderBy: 'createdAt DESC');
    return List.generate(maps.length, (i) {
      return Article(
        id: maps[i]['id'],
        storyTitle: maps[i]['storyTitle'],
        author: maps[i]['author'],
        createdAt: DateTime.parse(maps[i]['createdAt']),
      );
    });
  }
}
