import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:library_ui/services/user_service.dart';

class BorrowBooks extends StatefulWidget {
  const BorrowBooks({Key? key}) : super(key: key);

  @override
  _BorrowBooks createState() => _BorrowBooks();
}

class _BorrowBooks extends State<BorrowBooks> {
  TextEditingController holdPeriodController = new TextEditingController();
  UserServices userServices = UserServices.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/register.png'), fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: new AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pushNamed("choice"),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'request');
                },
                icon: Icon(Icons.add))
          ],
          title: new Text("Borrow Books"),
        ),
        body: displayBorrowRequests(),
      ),
    );
  }

  Widget displayBorrowRequests() {
    return FutureBuilder<List>(
      future: userServices.getBorrowRequests(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List> snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text('Error');
          } else if (snapshot.hasData) {
            return buildBorrowRequestList(snapshot);
          } else {
            return const Text('Empty data');
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      },
    );
  }

  Widget buildBorrowRequestList(AsyncSnapshot<List> snapshot) {
    return Center(
        child: SizedBox(
            width: 800,
            child: ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                var request = json.decode(snapshot.data?[index]);
                var status = request['status'];

                return new Card(
                    child: InkWell(
                        onTap: () async {
                          if (status == "1") {
                            extendBorrowPeriodDialog(request);
                          }
                        },
                        child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(children: <Widget>[
                              Row(children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(request['lender'])),
                                Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(request['title'])),
                                if (status == "0")
                                  Icon(Icons.access_time)
                                else if (checkValidity(
                                    request["holdPeriod"], request["date"]))
                                  Icon(Icons.check, color: Colors.green)
                                else if (status == "-1")
                                  Icon(Icons.close, color: Colors.red)
                                else
                                  Icon(Icons.warning, color: Colors.red),
                                IconButton(
                                  icon: Icon(Icons.delete_forever,
                                      color: Colors.red),
                                  onPressed: () async {
                                    deleteBorrowRequest(request);
                                  },
                                ),
                              ]),
                              if (status == "1")
                                displayCollectingDetails(request),
                            ]))));
              },
            )));
  }

  Future deleteBorrowRequestDialog(Map request) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Do you want to delete ?"),
              content: Text("You cannot apply for extension after deletion"),
              actions: [
                TextButton(
                    onPressed: () async {
                      Map requestBody = {
                        "title": request["title"],
                        "borrower": request["borrower"],
                        "lender": request["lender"]
                      };

                      userServices.deleteBorrowRequest(requestBody);

                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: Text('Yes')),
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Text('No')),
              ],
            ));
  }

  Future extendBorrowPeriodDialog(Map request) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Extend borrowing period"),
              content: TextField(
                onChanged: (value) {},
                controller: holdPeriodController,
                decoration: InputDecoration(hintText: "Enter days to extend"),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      Map requestBody = {
                        "status": "0",
                        "borrower": request['borrower'],
                        "title": request['title'],
                        "lender": request['lender'],
                        "date": request['date'],
                        "place": request['place'],
                        "time": request['time'],
                        "holdPeriod": holdPeriodController.text,
                      };

                      await userServices.updateBorrowRequest(requestBody);

                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: Text('Submit')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel')),
              ],
            ));
  }

  Future<void> deleteBorrowRequest(Map request) async {
    Map requestBody = {
      "bookTitle": request["title"],
      "email": request["lender"]
    };

    String response = await userServices.checkBookAvailability(requestBody);

    if (response == "true") {
      deleteBorrowRequestDialog(request);
    } else {
      final snackBar = SnackBar(
        content: const Text('Please return the book before deletion'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget displayCollectingDetails(Map request) {
    return Container(
        alignment: Alignment.bottomLeft,
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: Text("Book Collection info :",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(padding: EdgeInsets.all(8), child: Text(request['place'])),
          Padding(padding: EdgeInsets.all(8), child: Text(request['date'])),
          Padding(padding: EdgeInsets.all(8), child: Text(request['time']))
        ]));
  }

  bool checkValidity(String holdPeriod, String borrowDate) {
    DateFormat format = DateFormat("dd/MM/yyyy");
    DateTime date = format.parse(borrowDate);

    int period = int.parse(holdPeriod);
    DateTime currentDate = DateTime.now();

    if (currentDate.difference(date).inDays < period) return true;

    return false;
  }
}
