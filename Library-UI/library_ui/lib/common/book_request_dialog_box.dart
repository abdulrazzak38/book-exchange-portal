import 'package:flutter/material.dart';

import '../services/user_service.dart';

class BookRequestDialog {
  BuildContext context;
  UserServices userServices = UserServices.instance;
  String email;

  BookRequestDialog(this.context, this.email);

  Future dialogWidget(Map book) {
    TextEditingController holdPeriodController = new TextEditingController();
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Enter borrowing period"),
              content: TextField(
                onChanged: (value) {},
                controller: holdPeriodController,
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      Map requestBody = {
                        "title": book['title'],
                        "lender": book['email'],
                        "borrower": email,
                        "date": book['date'],
                        "place": book['place'],
                        "time": book['time'],
                        "holdPeriod": holdPeriodController.text,
                        "status": "0"
                      };
                      userServices.createBorrowRequest(requestBody);

                      Navigator.pop(context);
                    },
                    child: Text('Submit')),
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel')),
              ],
            ));
  }
}
