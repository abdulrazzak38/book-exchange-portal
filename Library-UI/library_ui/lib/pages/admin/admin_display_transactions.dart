import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:library_ui/services/user_service.dart';

class AdminTransactions extends StatefulWidget {
  const AdminTransactions({Key? key}) : super(key: key);

  @override
  _AdminTransactions createState() => _AdminTransactions();
}

class _AdminTransactions extends State<AdminTransactions> {
  TextEditingController fineAmountController = new TextEditingController();
  UserServices userServices = UserServices.instance;

  bool checkValidity(String holdPeriod, String borrowDate) {
    DateFormat format = DateFormat("dd/MM/yyyy");
    DateTime date = format.parse(borrowDate);

    int period = int.parse(holdPeriod);
    DateTime currentDate = DateTime.now();

    if (currentDate.difference(date).inDays < period) return true;

    return false;
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
          appBar: new AppBar(
            title: new Text("Transaction List"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pushNamed("adminchoice"),
            ),
          ),
          body: FutureBuilder<List>(
            future: userServices.getAllTransactions(),
            builder: (
              BuildContext context,
              AsyncSnapshot<List> snapshot,
            ) {
              print(snapshot.connectionState);
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Text('Error');
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map transaction = json.decode(snapshot.data?[index]);
                      var status = transaction['status'];
                      return new Card(
                          child: InkWell(
                              onTap: () {
                                if (status == "1") {
                                  if (checkValidity(transaction["holdPeriod"],
                                          transaction["date"]) ==
                                      false) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text("Enter fine amount"),
                                              content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Text("Due date was : "),
                                                    TextField(
                                                      onChanged: (value) {},
                                                      controller:
                                                          fineAmountController,
                                                    )
                                                  ]),
                                              actions: [
                                                TextButton(
                                                    onPressed: () async {
                                                      Map userFine = {
                                                        "email": transaction[
                                                            'borrower'],
                                                        "fineAmount": int.parse(
                                                            fineAmountController
                                                                .text)
                                                      };

                                                      Map notificationFine = {
                                                        "email": transaction['borrower'],
                                                        "fineAmount": int.parse(
                                                            fineAmountController
                                                                .text),
                                                        "title": transaction['title']
                                                      };

                                                      userServices.createFine(userFine, notificationFine);

                                                      Navigator.pop(context);
                                                      setState(() {});
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
                              },
                              child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          Padding(
                                            padding: EdgeInsets.all(20),
                                            child: Text(transaction['lender']),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(20),
                                            child: Text(transaction['borrower']),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(20),
                                            child: Text(transaction['title']),
                                          ),
                                          if (status == "0")
                                            Icon(Icons.access_time)
                                          else if (checkValidity(
                                              transaction["holdPeriod"],
                                              transaction["date"]))
                                            Icon(Icons.check,
                                                color: Colors.green)
                                          else if (status == "-1")
                                            Icon(Icons.close, color: Colors.red)
                                          else
                                            Icon(Icons.warning,
                                                color: Colors.red),
                                        ]),
                                        // Text("Fine amount to pay : "+json.decode(data[index])['fineAmount'].toString())
                                      ]))));
                    },
                  );
                } else {
                  return const Text('Empty data');
                }
              } else {
                return Text('State: ${snapshot.connectionState}');
              }
            },
          ),
        ));
  }
}
