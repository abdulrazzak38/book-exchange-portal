import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  _AdminHome createState() => _AdminHome();
}

class _AdminHome extends State<AdminHome> {
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
            Container(),
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
              child: IconButton(
                  icon: Icon(Icons.logout_outlined,
                      color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'login');
                  }),
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
                          child: const Text('View Books'),
                          onPressed: () {
                            Navigator.pushNamed(context, 'adminbook');
                          },
                        )),
                    Container(
                        height: 100,
                        padding: const EdgeInsets.fromLTRB(200, 50, 10, 0),
                        child: ElevatedButton(
                          child: const Text('View Users'),
                          onPressed: () {
                            Navigator.pushNamed(context, 'adminuser');
                          },
                        )),
                    Container(
                        height: 100,
                        padding: const EdgeInsets.fromLTRB(200, 50, 10, 0),
                        child: ElevatedButton(
                          child: const Text('View Transactions'),
                          onPressed: () {
                            Navigator.pushNamed(context, 'admintransactions');
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
}
