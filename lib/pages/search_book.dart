import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'more_details_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  List<dynamic> _books = [];

  Future<void> _searchBooks(String query) async {
    final apiKey = 'AIzaSyCqi37mzRrzkBrDZDb0BX9_IarX5iMOT88';
    final url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query&key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        _books = data['items'] ?? [];
      });
    } else {
      throw Exception('Failed to load books');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Card(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search...',
            ),
            onSubmitted: (query) {
              if (query.isNotEmpty) {
                _searchBooks(query);
              }
            },
          ),
        ),
        
      ),
      body: _books.isEmpty
          ? Center(
              child: Text('Search for books'),
            )
          : ListView.builder(
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final book = _books[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      final author =
                          book['volumeInfo']['authors']?.join(', ') ?? 'N/A';
                      final image =
                          book['volumeInfo']['imageLinks']['thumbnail'];
                      final title = book['volumeInfo']['title'];
                      final edition = 'Edition: ${book['volumeInfo']['edition'] ?? 'N/A'}';
                      final price = 'Price: \$${book['saleInfo']['listPrice']?['amount'] ?? 'N/A'}';
                      return MoreDetailsPage(imageUrl: image, author: author, edition: edition, price: price, title: title);
                    }));
                  },
                  child: ListTile(
                    leading: book['volumeInfo']['imageLinks'] != null
                        ? Image.network(
                            book['volumeInfo']['imageLinks']['thumbnail'],
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          )
                        : SizedBox.shrink(),
                    title: Text(book['volumeInfo']['title']),
                    subtitle: Text(book['volumeInfo']['authors']?.join(', ') ?? ''),
                  ),
                );
              },
            ),
    );
  }
}
