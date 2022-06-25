import 'package:flutter/material.dart';
import 'package:library_ui/common/book_list_builder.dart';

class SearchWidget extends SearchDelegate {
  Future<List> bookList;
  String email;
  BuildContext context;
  Function onTapFunction;
  String pageName;

  SearchWidget(this.bookList, this.email, this.context, this.onTapFunction,
      this.pageName);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        color: Colors.black,
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      color: Colors.black,
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    BookListBuilder bookListBuilder = BookListBuilder(
        onTapFunction: onTapFunction,
        email: email,
        pageName: pageName,
        query: query);

    return bookListBuilder.displayAvailableBooks(bookList);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Card();
  }
}
