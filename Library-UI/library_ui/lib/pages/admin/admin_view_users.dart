import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:library_ui/services/user_service.dart';

class AdminUser extends StatefulWidget {
  const AdminUser({Key? key}) : super(key: key);

  @override
  _AdminUser createState() => _AdminUser();
}

class _AdminUser extends State<AdminUser> {
  List data = [];
  UserServices userServices = UserServices.instance;

  Future<String> getData() async {
    var response = await http.get(Uri.parse("http://localhost:5000/viewuser"),
        headers: {"Accept": "application/json"});

    data = json.decode(response.body);
    return "SUCCESS";
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
            title: new Text("Users"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pushNamed("adminchoice"),
            ),
          ),
          body: FutureBuilder<String>(
            future: getData(),
            builder: (
              BuildContext context,
              AsyncSnapshot<String> snapshot,
            ) {
              print(snapshot.connectionState);
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Text('Error');
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new Card(
                        child: InkWell(
                          onTap: () async {
                            Map requestBody = {
                              "email": json.decode(data[index])['email']
                            };
                            userServices.setRequestBody = requestBody;
                            userServices.getDeleteFunction;

                          },
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                      json.decode(data[index])['userName'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child:
                                      Text(json.decode(data[index])['email']),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                      json.decode(data[index])['phoneNumber']),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
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
