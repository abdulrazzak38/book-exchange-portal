import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class UserServices extends ChangeNotifier {
  UserServices._privateConstructor();

  final backend_uri = "http://localhost:5000";
  static final UserServices instance = UserServices._privateConstructor();

  Map _userDetails = {};
  Map _requestBody={};
  Map get getUserMap => _userDetails;
  String email="";

  get getEmail => email;

  set setRequestBody(Map requestBody)
  {
    this._requestBody = requestBody;
  }

  Future<void> _deleteUser(Map requestBody) async
  {
    var url = backend_uri + '/deleteuser';


    var body = json.encode(requestBody);

    await http.delete(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: body);
  }

  get getDeleteFunction => _deleteUser(_requestBody);


  void storeUserEmail(String email) async {
    Box box = await Hive.openBox('emailBox');
    box.put('email', email);
  }

  Future<void> registerNewUser(Map requestBody) async {
    var url = backend_uri + '/newUser';

    var body = json.encode(requestBody);

    await http.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: body);
  }



  Future<String> getUserPassword(String email) async {
    var response = await http.post(
        Uri.parse(backend_uri + "/getPassword"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email}));

    return '${response.body}';
  }

  Future<String> getUserEmail() async {
    Box box = await Hive.openBox('emailBox');
    email = await box.get('email');
    return email;
  }

  Future<List> getUserFines() async {
    String email = await getUserEmail();
    Object requestBody = jsonEncode({"email": email});

    var response = await http.post(
        Uri.parse(backend_uri +"/getUserFines"),
        headers: {"Content-Type": "application/json"},
        body: requestBody);

    return json.decode(response.body);
  }

  Future<Map> getUserDetails() async {
    String email = await getUserEmail();
    Object requestBody = jsonEncode({"email": email});

    var response = await http.post(
        Uri.parse(backend_uri +"/getUserDetails"),
        headers: {"Content-Type": "application/json"},
        body: requestBody);

    this._userDetails = json.decode(response.body);
    notifyListeners();
    return this._userDetails;
  }

  Future<void> payFine(var fineAmount) async {
    var url = backend_uri +'/fine';
    String email = await getUserEmail();
    Map requestBody = {
      "email": email,
      "fineAmount": -fineAmount,
    };

    var body = json.encode(requestBody);
    var client = http.Client();
    await client.patch(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: body);

    Map _requestBody = {
      "email": email,
    };

    var _body = json.encode(_requestBody);

    await client.delete(Uri.parse(backend_uri +'/deleteFine'),
        headers: {
          "Content-Type": "application/json",
        },
        body: _body);
    client.close();
  }

  Future<void> addBalance(int balance) async {
    var url = backend_uri +'/addBalance';
    String email = await getUserEmail();
    Map requestBody = {
      "email": email,
      "balance": balance,
    };

    var body = json.encode(requestBody);
    var client = http.Client();
    await client.patch(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: body);
  }

  Future<void> updateBorrowRequest(Map requestBody) async {
    var url = backend_uri +'/updaterequest';

    var body = json.encode(requestBody);

    await http.patch(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: body);
  }

  Future<List> getLendRequests() async {
    var url = backend_uri +"/requestlender";

    String email = await getUserEmail();

    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email}));

    return json.decode(response.body);
  }

  Future<List> getBookList() async {
    String url = backend_uri +"/listBooks";

    var response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});

    return json.decode(response.body);
  }

  Future<void> createBorrowRequest(Map requestBody) async {
    String url = backend_uri + "/newrequest";

    await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody));
  }

  Future<List> getUserBookList() async {
    String url = backend_uri +"/listUserBooks";
    String email = await getUserEmail();

    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email}));

    return json.decode(response.body);
  }

  Future<List> getBorrowRequests() async {
    String url = backend_uri +"/requestborrower";
    String email = await getUserEmail();
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email}));

    return json.decode(response.body);
    ;
  }

  Future<void> deleteBorrowRequest(Map requestBody) async {
    String url = backend_uri +'/deletetransaction';

    await http.delete(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody));
  }

  Future<String> checkBookAvailability(Map requestBody) async {
    String url = backend_uri +"/checkAvailability";
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody));

    return "${response.body}";
  }

  Future<void> deleteBook(Map requestBody) async {
    String url = backend_uri +'/deletebook';

    var body = json.encode(requestBody);

    await http.delete(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: body);
  }

  Future<void> updateBookAvailability(Map requestBody) async {
    String url = backend_uri +'/updateAvailability';

    var body = json.encode(requestBody);
    await http.patch(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: body);
  }

  Future<void> addNewBook(Map requestBody) async {
    var url = backend_uri +'/newBook';

    var body = json.encode(requestBody);

    await http.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: body);
  }

  Future<Response> sendOTP(String email) async {
    var url = backend_uri +'/sendotp';
    storeUserEmail(email);
    var body = json.encode({"email": email});
    return http.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: body);
  }

  Future<void> changePassword(String newPassword) async {
    String email = await getUserEmail();
    Map requestBody = {"email": email, "password": newPassword};

    await http.patch(Uri.parse(backend_uri +"/changePassword"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody));
  }

  Future<void> createFine(Map userFine,Map notificationFine) async {

    await http.patch(
        Uri.parse(
            backend_uri +"/fine"),
        headers: {
          "Content-Type":
          "application/json"
        },
        body: json
            .encode(userFine));

    await http.post(
        Uri.parse(
            backend_uri +"/createFine"),
        headers: {
          "Content-Type":
          "application/json"
        },
        body: json
            .encode(notificationFine));

  }

  Future<List> getAllTransactions() async
  {
    var response = await http.get(
        Uri.parse(backend_uri +"/viewtransactions"),
        headers: {"Accept": "application/json"});

    return json.decode(response.body);
  }







}
