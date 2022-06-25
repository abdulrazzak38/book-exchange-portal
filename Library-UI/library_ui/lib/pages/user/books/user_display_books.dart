import 'package:flutter/material.dart';
import 'package:library_ui/pages/user/books/user_modify_book.dart';
import 'package:library_ui/services/user_service.dart';

import '../../../common/book_list_builder.dart';
import '../../../common/search_widget.dart';

class UserBook extends StatefulWidget {
  const UserBook({Key? key}) : super(key: key);

  @override
  _UserBook createState() => _UserBook();
}

class _UserBook extends State<UserBook> {
  UserServices userServices = UserServices.instance;

  late BookListBuilder bookListBuilder;

  String query = "";
  String email = "";

  Widget appBarTitle = new Text("My Books");
  late Function onTapFunction;

  @override
  void initState() {
    userServices.getUserEmail().then((value) => email = value);
    onTapFunction = (Map book) => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ModifyBook(book: book)),
          )
        };
    bookListBuilder = new BookListBuilder(
        onTapFunction: onTapFunction,
        email: email,
        query: query,
        pageName: "userDisplayBooks");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/register.png'), fit: BoxFit.fill),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pushNamed("choice"),
            ),
            actions: [
              (IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'addbook');
                  },
                  icon: Icon(Icons.add))),
              (IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: SearchWidget(userServices.getUserBookList(),
                          email, context, onTapFunction, "userDisplayBooks"));
                },
              ))
            ],
            title: appBarTitle,
          ),
          body: bookListBuilder
              .displayAvailableBooks(userServices.getUserBookList()),
        ));
  }
}
