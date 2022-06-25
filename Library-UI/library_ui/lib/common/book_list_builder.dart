import 'dart:convert';

import 'package:flutter/material.dart';

class BookListBuilder {
  Function onTapFunction;
  String email;
  String pageName;
  String query;

  BookListBuilder(
      {required this.onTapFunction,
      required this.email,
      required this.query,
      required this.pageName});

  Widget displayAvailableBooks(Future<List> bookList) {
    return FutureBuilder<List>(
      future: bookList,
      builder: (
        BuildContext context,
        AsyncSnapshot<List> snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text('Error connecting to DB',
                style: TextStyle(color: Colors.white));
          } else if (snapshot.hasData) {
            return buildAvailableBookList(snapshot);
          } else {
            return const Text('Empty data');
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      },
    );
  }

  Widget buildAvailableBookList(AsyncSnapshot<List> snapshot) {
    bool filter;

    return ListView.builder(
      itemCount: snapshot.data?.length,
      itemBuilder: (BuildContext context, int index) {
        var book = json.decode(snapshot.data?[index]);

        if (pageName == "userRequest") {
          filter = (book['availability'] == "1") & (email != book['email']);
        } else {
          filter = true;
        }

        if (queryMatch(book["title"]) & filter) {
          return bookCard(book);
        } else {
          return Card();
        }
      },
    );
  }

  Widget bookCard(Map book) {
    return Card(
        child: InkWell(
            onTap: () => {onTapFunction.call(book)},
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(book['title'] + ' (' + book['year'] + ')',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text('by: ' + book['author']),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text('Publisher: ' + book['publisher']),
                  ),
                ]))));
  }

  bool queryMatch(String item) {
    item = item.toLowerCase();
    if (item.indexOf(query.toLowerCase()) == -1) {
      return false;
    }

    return true;
  }
}
