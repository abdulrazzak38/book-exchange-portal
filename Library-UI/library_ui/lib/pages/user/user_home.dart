import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:library_ui/services/user_service.dart';
import 'package:provider/provider.dart';

enum Menu { Wallet, PayFine, Logout }

class UserHome extends StatelessWidget {
  UserHome({Key? key}) : super(key: key);

  final UserServices userServices = UserServices.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/login.png'), fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 35, top: 80),
              child: Text(
                'Library',
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 253, 253), fontSize: 30),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 1300, top: 80),
              child: Row(children: [
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: popUpMenuFines(),
                ),
                popUpMenuOptions(context),
              ]),
            ),
            Column(
              children: <Widget>[
                SizedBox(height: 350),
                Row(
                  children: [
                    Container(
                        height: 100,
                        padding: const EdgeInsets.fromLTRB(300, 50, 10, 0),
                        child: ElevatedButton(
                          child: const Text('Lend a Book'),
                          onPressed: () {
                            Navigator.pushNamed(context, 'lendbook');
                          },
                        )),
                    Container(
                        height: 100,
                        padding: const EdgeInsets.fromLTRB(200, 50, 10, 0),
                        child: ElevatedButton(
                          child: const Text('Borrow a Book'),
                          onPressed: () {
                            Navigator.pushNamed(context, 'borrowbook');
                          },
                        )),
                    Container(
                        height: 100,
                        padding: const EdgeInsets.fromLTRB(200, 50, 10, 0),
                        child: ElevatedButton(
                          child: const Text('My Books'),
                          onPressed: () {
                            Navigator.pushNamed(context, 'userbooks');
                          },
                        )),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget popUpMenuFines() {
    return FutureProvider(
      create: (_) => userServices.getUserFines(),
      initialData: [],
      child: Consumer<List>(
          builder: (_, finesList, __) => (PopupMenuButton<String>(
              offset: const Offset(0, 34),
              icon: Icon(Icons.notifications_rounded, color: Colors.white),
              color: Colors.white,
              onSelected: (item) {},
              itemBuilder: (BuildContext context) {
                if (finesList.length == 0)
                  return [
                    PopupMenuItem<String>(
                      value: "Empty",
                      child: Text("Empty"),
                    )
                  ];
                else
                  return buildFinesList(finesList);
              }))),
    );
  }

  List<PopupMenuItem<String>> buildFinesList(List finesList) {
    return finesList
        .map(
          (item) => PopupMenuItem<String>(
              value: json.decode(item)['title'],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 4, 0, 8),
                    child: Text(
                        "You were fined for " + json.decode(item)['title'],
                        style: TextStyle(fontSize: 15)),
                  ),
                  Text(
                      "Fine amount : " +
                          (json.decode(item)['fineAmount']).toString(),
                      style: TextStyle(fontSize: 15)),
                  Divider(
                    height: 20,
                    thickness: 2,
                    indent: 0,
                    endIndent: 0,
                    color: Colors.black,
                  ),
                ],
              )),
        )
        .toList();
  }

  Widget popUpMenuOptions(BuildContext context) {
    return PopupMenuButton<Menu>(
        offset: const Offset(0, 34),
        icon: Icon(Icons.menu, color: Colors.white),
        color: Colors.white,
        onSelected: (item) {
          if (item.name == "Logout") {
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushNamed(context, 'login');
          } else if (item.name == "PayFine") {
            Navigator.pushNamed(context, 'payfine');
          } else {
            Navigator.pushNamed(context, 'addbalance');
          }
        },
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem(
              value: Menu.Wallet,
              child: ListTile(
                leading: Icon(Icons.account_balance_wallet_rounded), // your icon
                title: Text("Wallet"),
              ),
            ),
            PopupMenuItem(
              value: Menu.PayFine,
              child: ListTile(
                leading: Icon(Icons.payments), // your icon
                title: Text("Pay fine"),
              ),
            ),
            PopupMenuItem(
              value: Menu.Logout,
              child: ListTile(
                leading: Icon(Icons.logout_outlined), // your icon
                title: Text("Logout"),
              ),
            ),
          ];
        });
  }
}
