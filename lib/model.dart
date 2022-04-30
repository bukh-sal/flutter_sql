class Book {
  final int id;
  final String title;
  final String author;

  const Book({
    required this.id,
    required this.title,
    required this.author,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
    };
  }

  @override
  String toString() {
    return 'Book{id: $id, title: $title, author: $author}';
  }
}