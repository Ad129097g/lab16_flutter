import 'dart:convert';
import 'package:http/http.dart' as http;
import 'book.dart';

class BookService {
  static const apiUrl = 'http://192.168.101.81:8080/api/books'; // Usando la IP real de tu máquina

  Future<List<Book>> getBooks() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Book.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<Book> createBook(Book book) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(book.toJson()),
    );

    if (response.statusCode == 201) {
      return Book.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create book');
    }
  }

  Future<Book> updateBook(Book book) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${book.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(book.toJson()),
    );

    if (response.statusCode == 200) {
      return Book.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update book');
    }
  }

  Future<void> deleteBook(int id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/$id'),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete book');
    }
  }
}
