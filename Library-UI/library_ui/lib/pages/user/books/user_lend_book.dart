import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:library_ui/services/user_service.dart';

class LendBooks extends StatefulWidget {
  const LendBooks({Key? key}) : super(key: key);

  @override
  _LendBooks createState() => _LendBooks();
}

class _LendBooks extends State<LendBooks> {
  UserServices userServices = UserServices.instance;

  TextEditingController placeController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();
  TextEditingController timeController = new TextEditingController();

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
          title: new Text("Lend Books"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pushNamed("choice"),
          ),
        ),
        body: getAvailableRequests(),
      ),
    );
  }

  Widget getAvailableRequests() {
    return FutureBuilder<List>(
      future: userServices.getLendRequests(),
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
            return Center(
                child: SizedBox(
              width: 300,
              child: buildRequestsList(snapshot),
            ));
          } else {
            return const Text('Empty data');
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      },

      //
    );
  }

  Widget buildRequestsList(AsyncSnapshot<List> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data?.length,
      itemBuilder: (BuildContext context, int index) {
        var request = json.decode(snapshot.data?[index]);

        if ((request['status'] == '0')) {
          return new Card(
              child: InkWell(
            child: Column(children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    request['title'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("Borrower : " + request['borrower'])),
              Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                      "Lending period :" + request['holdPeriod'] + " days")),
            ]),
            onTap: () {
              Map requestBody = {
                "lender": request["lender"],
                "title": request["title"],
                "borrower": request["borrower"],
                "status": request['status'],
                "date": request['date'],
                "place": request['place'],
                "time": request['time'],
                "holdPeriod": request['holdPeriod'],
              };

              if (request['place'] != "NULL") {
                borrowPeriodExtensionDialog(request, requestBody);
              } else {
                updateRequestStatusDialog(requestBody);
              }
            },
          ));
        } else {
          return new Card();
        }
      },
    );
  }

  Future borrowPeriodExtensionDialog(Map request, Map requestBody) {
    return showDialog(
        context: context,
        builder: (upperDialog) => AlertDialog(
              title: Text("Approval of borrow period extension"),
              content: Text(request['holdPeriod'] + "  days more from now"),
              actions: [
                TextButton(
                    onPressed: () async {
                      DateTime now = DateTime.now();
                      DateFormat formatter = DateFormat('dd/MM/yyyy');
                      String formatted = formatter.format(now);
                      requestBody["status"] = "1";
                      requestBody['date'] = formatted;

                      userServices.updateBorrowRequest(requestBody);

                      Navigator.of(context, rootNavigator: true).pop(context);
                      setState(() {});
                    },
                    child: Text('Yes')),
                TextButton(
                    onPressed: () async {
                      requestBody["status"] = "-1";
                      userServices.updateBorrowRequest(requestBody);

                      Navigator.of(context, rootNavigator: true).pop(context);
                      setState(() {});
                    },
                    child: Text('No')),
              ],
            ));
  }

  Future updateRequestStatusDialog(Map requestBody) {
    return showDialog(
        context: context,
        builder: (upperDialog) => AlertDialog(
              title: Text("Approve request ?"),
              actions: [
                TextButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (lowerDialog) => AlertDialog(
                                  title: Text("Enter details"),
                                  content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        TextField(
                                          onChanged: (value) {},
                                          controller: placeController,
                                          decoration: InputDecoration(
                                              hintText: "Enter Place"),
                                        ),
                                        TextField(
                                          onChanged: (value) {},
                                          controller: dateController,
                                          decoration: InputDecoration(
                                              hintText:
                                                  "Enter Date(dd/mm/yyyy)"),
                                        ),
                                        TextField(
                                          onChanged: (value) {},
                                          controller: timeController,
                                          decoration: InputDecoration(
                                              hintText: "Enter Time"),
                                        ),
                                      ]),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        requestBody["status"] = "1";
                                        requestBody["place"] =
                                            placeController.text;
                                        requestBody["time"] =
                                            timeController.text;
                                        requestBody["date"] =
                                            dateController.text;

                                        userServices
                                            .updateBorrowRequest(requestBody);

                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(lowerDialog);
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(upperDialog);

                                        setState(() {});
                                      },
                                      child: Text("Submit"),
                                    )
                                  ]));
                    },
                    child: Text('Yes')),
                TextButton(
                    onPressed: () async {
                      requestBody["status"] = "-1";
                      userServices.updateBorrowRequest(requestBody);

                      Navigator.of(context, rootNavigator: true).pop(context);
                    },
                    child: Text('No')),
              ],
            ));
  }
}
