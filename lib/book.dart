


class BookFields {
  static const List<String> values = [
    id, title, publicationDate, availability,
  ];

  static const String tableName = 'books';
  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String textType = 'TEXT NOT NULL';
  static const String dateType = 'TEXT NOT NULL';
  static const String boolType = 'INTEGER NOT NULL';

  static const String id = '_id';
  static const String title = 'title';
  static const String publicationDate = 'publication_date';
  static const String availability = 'availability';
}

class Book {
  final int? id;
  final String title;
  final String publicationDate;
  late final bool availability;

  Book({
    this.id,
    required this.title,
    required this.publicationDate,
    required this.availability,
  });

  Map<String, Object?> toJson() => {
        BookFields.id: id,
        BookFields.title: title,
        BookFields.publicationDate: publicationDate,
        BookFields.availability: availability ? 1 : 0,
      };

  static Book fromJson(Map<String, Object?> json) => Book(
        id: json[BookFields.id] as int?,
        title: json[BookFields.title] as String,
        publicationDate: json[BookFields.publicationDate] as String,
        availability: json[BookFields.availability] == 1,
      );

  Book copy({
    int? id,
    String? title,
    String? publicationDate,
    bool? availability,
  }) =>
      Book(
        id: id ?? this.id,
        title: title ?? this.title,
        publicationDate: publicationDate ?? this.publicationDate,
        availability: availability ?? this.availability,
      );
}