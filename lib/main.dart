import 'package:flutter/cupertino.dart';
import 'book_list_view.dart';
import 'new_book_detail_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Biblioteca',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.activeBlue,
      ),
      home: BookListWithButton(),
    );
  }
}

class BookListWithButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Biblioteca'),
      ),
      child: Stack(
        children: [
          BookListView(),
          Positioned(
            bottom: 16,
            right: 16,
            child: CupertinoButton(
              color: CupertinoColors.activeOrange,
              child: Icon(CupertinoIcons.add),
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => AddBookScreen(), // Aquí utilizamos la clase correcta
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
