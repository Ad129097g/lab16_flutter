import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'book.dart';

class AddBookScreen extends StatefulWidget {
  final Book? book;

  const AddBookScreen({Key? key, this.book}) : super(key: key);

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _publicationDateController = TextEditingController();
  bool _availability = true;

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _titleController.text = widget.book!.title;
      _publicationDateController.text = widget.book!.publicationDate;
      _availability = widget.book!.availability;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.book == null ? 'Agregar Libro' : 'Editar Libro'),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 80.0), // Added top padding here
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CupertinoTextFormFieldRow(
                  controller: _titleController,
                  placeholder: 'Título',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingrese un título';
                    }
                    return null;
                  },
                ),
                CupertinoTextFormFieldRow(
                  controller: _publicationDateController,
                  placeholder: 'Fecha de Publicación (YYYY-MM-DD)',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingrese una fecha de publicación';
                    }
                    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
                      return 'Por favor ingrese una fecha válida (YYYY-MM-DD)';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Text('Disponibilidad'),
                    CupertinoSwitch(
                      value: _availability,
                      onChanged: (bool value) {
                        setState(() {
                          _availability = value;
                        });
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: CupertinoButton.filled(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Guardar libro en la API
                        Book newBook = Book(
                          title: _titleController.text,
                          publicationDate: _publicationDateController.text,
                          availability: _availability,
                        );

                        addBook(newBook).then((value) {
                          _showMessage('Se guardó correctamente');
                          Navigator.pop(context); // Volver a la pantalla anterior
                        }).catchError((error) {
                          _showMessage('Falla al guardar los datos');
                        });
                      }
                    },
                    child: Text('Guardar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addBook(Book book) async {
    final response = await http.post(
      Uri.parse('http://192.168.101.81:8080/api/books'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(book.toJson()),
    );

    if (response.statusCode == 201) {
      // Libro creado exitosamente
    } else {
      throw Exception('Failed to add book');
    }
  }

  void _showMessage(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
