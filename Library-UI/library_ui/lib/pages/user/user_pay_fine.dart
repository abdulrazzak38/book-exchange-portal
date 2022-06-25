import 'package:flutter/material.dart';
import 'package:library_ui/services/user_service.dart';
import 'package:provider/provider.dart';

class PayFine extends StatelessWidget {
  PayFine({Key? key}) : super(key: key);

  final UserServices userServices = UserServices.instance;

  @override
  Widget build(BuildContext context) {
    // waitData();
    return FutureProvider(
      create: (context) => userServices.getUserDetails(),
      initialData: {},
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/register.png'), fit: BoxFit.fill),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: new AppBar(
            title: new Text("Pay Fine"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pushNamed("choice");
              },
            ),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                displayFine(),
                SizedBox(
                  height: 40,
                ),
                payFine(),
                SizedBox(
                  height: 40,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[])
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget displayFine() {
    return Consumer<Map>(builder: (_, userDetails, __) {
      if (userDetails["fineAmount"] == null)
        return Container(
          margin: EdgeInsets.all(25),
          child: CircularProgressIndicator(),
        );
      else
        return Container(
          margin: EdgeInsets.all(25),
          child: Text(
            "Fine amount " + userDetails["fineAmount"].toString(),
            style: TextStyle(fontSize: 30, color: Color(0xFFFFFFFF)),
          ),
        );
    });
  }

  Widget payFine() {
    return Consumer<Map>(builder: (_, userDetails, __) {
      Provider.of<Map>(_, listen: false);
      return Container(
        margin: EdgeInsets.all(25),
        child: ElevatedButton(
          child: Text('Pay', style: TextStyle(fontSize: 20.0)),
          onPressed: () async {
            int balance = userDetails["balance"];
            int fineAmount = userDetails["fineAmount"];

            if (balance < fineAmount) {
              final snackBar = SnackBar(
                content: Text("Balance low " +
                    (fineAmount - balance).toString() +
                    " more needed"),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {},
                ),
              );
              ScaffoldMessenger.of(_).showSnackBar(snackBar);
            } else {
              await userServices.payFine(fineAmount);
              await userServices.addBalance(-fineAmount);

              final snackBar = SnackBar(
                content: Text("Fine paid successfully"),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {},
                ),
              );
              ScaffoldMessenger.of(_).showSnackBar(snackBar);
            }
          },
        ),
      );
    });
  }
}
