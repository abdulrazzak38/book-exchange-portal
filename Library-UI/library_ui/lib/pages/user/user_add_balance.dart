import 'package:flutter/material.dart';
import 'package:library_ui/services/user_service.dart';
import 'package:provider/provider.dart';

class AddBalance extends StatelessWidget {

   AddBalance({Key? key}) : super(key: key);

   final UserServices userServices = UserServices.instance;

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
              title: new Text("Wallet"),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pushNamed("choice"),
              ),
            ),
            body: Center(
                child: Column(children: <Widget>[
              MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (context) => userServices,
                  ),
                  FutureProvider(
                      create: (context) => userServices.getUserDetails(),
                      initialData: {})
                ],
                child: Consumer2<UserServices, Map>(
                  builder: (context, __, userDetailsMap, _) {
                    String balance =
                        userServices.getUserMap['balance'].toString();
                    return Container(
                      margin: EdgeInsets.all(25),
                      child: (balance != 'null')
                          ? Text(
                              "Current balance : " + balance,
                              style: TextStyle(
                                  fontSize: 30, color: Color(0xFFFFFFFF)),
                            )
                          : Text(
                              "Current balance : " +
                                  userDetailsMap['balance'].toString(),
                              style: TextStyle(
                                  fontSize: 30, color: Color(0xFFFFFFFF)),
                            ),
                    );
                    // return
                  },
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                margin: EdgeInsets.all(25),
                child: ElevatedButton(
                  child: Text('Add Balance', style: TextStyle(fontSize: 20.0)),
                  onPressed: () async {
                    TextEditingController _textFieldController =
                        new TextEditingController();
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Enter top up amount'),
                            content: TextField(
                              onChanged: (value) {},
                              controller: _textFieldController,
                              decoration: InputDecoration(hintText: "Amount"),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    await userServices.addBalance(
                                        int.parse(_textFieldController.text));
                                    userServices.getUserDetails();
                                    Navigator.pop(context);
                                  },
                                  child: Text('Ok')),
                              TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel')),
                            ],
                          );
                        });
                  },
                ),
              ),
            ]))));
  }
}
