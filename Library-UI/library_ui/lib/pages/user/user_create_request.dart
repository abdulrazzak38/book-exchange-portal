import 'package:flutter/material.dart';
import 'package:library_ui/common/search_widget.dart';
import 'package:library_ui/services/user_service.dart';

import '../../common/book_list_builder.dart';
import '../../common/book_request_dialog_box.dart';

class CreateBorrowRequest extends StatefulWidget {
  const CreateBorrowRequest({Key? key}) : super(key: key);

  @override
  _CreateBorrowRequest createState() => _CreateBorrowRequest();
}

class _CreateBorrowRequest extends State<CreateBorrowRequest> {
  UserServices userServices = UserServices.instance;

  late BookListBuilder bookListBuilder;

  String query = "";
  String email = "";

  Widget appBarTitle = new Text("Create a request");
  late Function onTapFunction;

  @override
  void initState() {
    userServices.getUserEmail();
    Future.delayed(Duration(seconds:2));
    email = userServices.getEmail;
    BookRequestDialog bookRequestDialog = BookRequestDialog(context, email);
    onTapFunction = bookRequestDialog.dialogWidget;
    bookListBuilder = new BookListBuilder(
        onTapFunction: onTapFunction,
        email: email,
        query: query,
        pageName: "userRequest");
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
              onPressed: () => Navigator.of(context).pushNamed("borrowbook"),
            ),
            actions: [
              (IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: SearchWidget(userServices.getBookList(), email,
                          context, onTapFunction, "userRequest"));
                },
              ))
            ],
            title: appBarTitle,
          ),
          body:
              bookListBuilder.displayAvailableBooks(userServices.getBookList()),
        ));
  }
}
