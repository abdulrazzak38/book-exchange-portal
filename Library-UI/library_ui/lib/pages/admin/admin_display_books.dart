import 'package:flutter/material.dart';
import 'package:library_ui/pages/admin/admin_modify_book.dart';
import 'package:library_ui/services/user_service.dart';

import '/../common/book_list_builder.dart';
import '/../common/search_widget.dart';

class AdminBook extends StatefulWidget {
  const AdminBook({Key? key}) : super(key: key);

  @override
  _AdminBook createState() => _AdminBook();
}

class _AdminBook extends State<AdminBook> {
  UserServices userServices = UserServices.instance;

  late BookListBuilder bookListBuilder;

  String query = "";
  String email = "";

  Widget appBarTitle = new Text("All books");
  late Function onTapFunction;

  @override
  void initState() {
    onTapFunction = (Map book) => {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminModifyBook(book: book)),
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
              onPressed: () => Navigator.of(context).pushNamed("adminchoice"),
            ),
            actions: [
              (IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: SearchWidget(userServices.getBookList(),
                          email, context, onTapFunction, "userDisplayBooks"));
                },
              ))
            ],
            title: appBarTitle,
          ),
          body: bookListBuilder
              .displayAvailableBooks(userServices.getBookList()),
        ));
  }
}
