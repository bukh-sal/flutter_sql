import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model.dart';



Future<Database> getDatabase() async {
  final String path = await getDatabasesPath();
  final String pathToFile = join(path, 'books.db');

  final Database database = await openDatabase(pathToFile, version: 1,
      onCreate: (Database db, int version) async {
    await db.execute(
        'CREATE TABLE books (id INTEGER PRIMARY KEY, title TEXT, author TEXT)');
  });
  return database;
}



Future<List<Book>> getBooks() async {
  final Database database = await getDatabase();
  final List<Map<String, dynamic>> maps = await database.query('books');
  return List.generate(maps.length, (i) {
    return Book(
      id: maps[i]['id'],
      title: maps[i]['title'],
      author: maps[i]['author'],
    );
  });
}



Future<Book> getBook(int id) async {
  final Database database = await getDatabase();
  final List<Map<String, dynamic>> maps = await database.query('books',
      where: 'id = ?', whereArgs: [id]);
  return Book(
    id: maps[0]['id'],
    title: maps[0]['title'],
    author: maps[0]['author'],
  );
}



Future<void> updateBook(Book book) async {
  final Database database = await getDatabase();
  await database.update('books', book.toMap(), where: 'id = ?', whereArgs: [book.id]);
}



Future<void> insertBook(String title, String author) async {
  final Database database = await getDatabase();
  await database.insert('books', {'title': title, 'author': author});
}



Future<void> deleteBook(Book book) async {
  final Database database = await getDatabase();
  await database.delete('books', where: 'id = ?', whereArgs: [book.id]);
}