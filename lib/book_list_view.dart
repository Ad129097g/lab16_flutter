import 'package:flutter/cupertino.dart';
import 'book.dart';
import 'book_service.dart';
import 'new_book_detail_view.dart';

class BookListView extends StatefulWidget {
  @override
  _BookListViewState createState() => _BookListViewState();
}

class _BookListViewState extends State<BookListView> {
  final BookService bookService = BookService();
  late List<Book> books = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshBooks();
  }

  Future<void> refreshBooks() async {
    setState(() => isLoading = true);
    try {
      books = await bookService.getBooks();
    } catch (e) {
      print('Error loading books: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CupertinoActivityIndicator())
        : ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => AddBookScreen(book: book), // Aquí utilizamos la clase correcta
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: CupertinoColors.separator)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              style: CupertinoTheme.of(context).textTheme.textStyle,
                            ),
                            Text(
                              book.publicationDate,
                              style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                          ],
                        ),
                        CupertinoSwitch(
                          value: book.availability,
                          onChanged: (value) async {
                            book.availability = value;
                            try {
                              await bookService.updateBook(book);
                              setState(() {});
                            } catch (e) {
                              print('Error updating book: $e');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
