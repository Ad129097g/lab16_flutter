import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'book.dart';

class BookDatabase {
  static final BookDatabase instance = BookDatabase._internal();
  static Database? _database;

  BookDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'books.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${BookFields.tableName} (
        ${BookFields.id} ${BookFields.idType},
        ${BookFields.title} ${BookFields.textType},
        ${BookFields.publicationDate} ${BookFields.dateType},
        ${BookFields.availability} ${BookFields.boolType}
      )
    ''');
  }

  Future<Book> create(Book book) async {
    final db = await instance.database;
    final id = await db.insert(BookFields.tableName, book.toJson());
    return book.copy(id: id);
  }

  Future<Book> readBook(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      BookFields.tableName,
      columns: BookFields.values,
      where: '${BookFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Book.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Book>> readAllBooks() async {
    final db = await instance.database;
    final result = await db.query(BookFields.tableName);
    return result.map((json) => Book.fromJson(json)).toList();
  }

  Future<int> update(Book book) async {
    final db = await instance.database;
    return db.update(
      BookFields.tableName,
      book.toJson(),
      where: '${BookFields.id} = ?',
      whereArgs: [book.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      BookFields.tableName,
      where: '${BookFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}