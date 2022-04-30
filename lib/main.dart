import 'package:flutter/material.dart';

import 'model.dart';
import 'io.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Books',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'My Books'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Book> _books = [];

  @override
    void initState() {
      super.initState();
      _refreshPage();
    }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<Book>>(
          future: getBooks(),
          builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
            if (snapshot.hasData) {
              _books = snapshot.data!;
            }
            return ListView.builder(
              itemCount: _books.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_books[index].title),
                  subtitle: Text(_books[index].author),
                  // add delete button
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      deleteBook(_books[index]);
                      setState(() {
                        _books.removeAt(index);
                      });
                    },
                  ),
                );
              },
            );
          },
      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addBook,
        tooltip: 'Add New Book',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  addBook() {
    String _title = '';
    String _author = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),

          title: const Text('Add a book'),
          // two fields one for title and one for author
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                onChanged: (String value) {
                  _title = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Author',
                ),
                onChanged: (String value) {
                  _author = value;
                },
              ),
            ],
          ),
          
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                insertBook(_title, _author);
                Navigator.of(context).pop();
                setState(() {
                  _books.add(Book(id: _books.length, title: _title, author: _author));
                });
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _refreshPage() async {
    setState(() {
      _books.clear();
      getBooks().then((List<Book> books) {
        setState(() {
          _books = books;
        });
      });
    });
    
  }

}


