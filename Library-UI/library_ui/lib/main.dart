import 'package:flutter/material.dart';
import 'package:library_ui/pages/admin/admin_display_books.dart';
import 'package:library_ui/pages/admin/admin_home.dart';
import 'package:library_ui/pages/admin/admin_display_transactions.dart';
import 'package:library_ui/pages/admin/admin_view_users.dart';
import 'package:library_ui/common/login_page.dart';
import 'package:library_ui/pages/user/books/user_add_book.dart';
import 'package:library_ui/pages/user/books/user_borrow_book.dart';
import 'package:library_ui/pages/user/books/user_display_books.dart';
import 'package:library_ui/pages/user/books/user_lend_book.dart';
import 'package:library_ui/pages/user/user_pay_fine.dart';
import 'package:library_ui/pages/user/user_add_balance.dart';
import 'package:library_ui/pages/user/user_change_password.dart';
import 'package:library_ui/pages/user/user_create_request.dart';
import 'package:library_ui/pages/user/user_forgot_password.dart';
import 'package:library_ui/pages/user/user_home.dart';
import 'package:library_ui/pages/user/user_register.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
    routes: {
      'addbalance': (context) => AddBalance(),
      'register': (context) => MyRegister(),
      'login': (context) => LoginPage(),
      'forgotpassword': (context) => MyForgotPassword(),
      'choice': (context) => UserHome(),
      'changepassword': (context) => MyChangePassword(),
      'addbook': (context) => MyAddBook(),
      'borrowbook': (context) => BorrowBooks(),
      'lendbook': (context) => LendBooks(),
      'request': (context) => CreateBorrowRequest(),
      'adminchoice': (context) => AdminHome(),
      'adminbook': (context) => AdminBook(),
      'admintransactions': (context) => AdminTransactions(),
      'adminuser': (context) => AdminUser(),
      'userbooks': (context) => UserBook(),
      'payfine': (context) => PayFine(),
    },
  ));
}
