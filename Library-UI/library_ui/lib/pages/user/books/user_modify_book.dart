import 'package:flutter/material.dart';
import 'package:library_ui/services/user_service.dart';

class ModifyBook extends StatefulWidget {
  final Map book;

  const ModifyBook({Key? key, required this.book}) : super(key: key);

  @override
  _ModifyBookState createState() => _ModifyBookState();
}

 class _ModifyBookState extends State<ModifyBook>  {
  Map book = {};
  UserServices userServices = UserServices.instance;


  @override
  Widget build(BuildContext context) {

    book = widget.book;
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/register.png'), fit: BoxFit.fill),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: new AppBar(
              title: new Text("Modify a book"),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pushNamed("userbooks"),
              ),
            ),
            body: Center(
                child: Column(children: <Widget>[
              Container(
                margin: EdgeInsets.all(25),
                child: Text(
                  book['title'],
                  style: TextStyle(fontSize: 30, color: Color(0xFFFFFFFF)),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                margin: EdgeInsets.all(25),
                child: ElevatedButton(
                  child: Text('Delete', style: TextStyle(fontSize: 20.0)),
                  onPressed: () async {
                    Map requestBody = {
                      "bookTitle": book["title"],
                      "author": book["author"],
                      "email": book["email"]
                    };
                    await userServices.deleteBook(requestBody);
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("Availability",
                            style: TextStyle(
                                fontSize: 25.0, color: Colors.white))),
                    Checkbox(
                      checkColor: Colors.white,
                      value: book["availability"] == "1",
                      onChanged: (bool? value) async {
                        if (value!) {
                          book["availability"] = "1";
                        } else {
                          book["availability"] = "0";
                        }
                        Map requestBody = {
                          "bookTitle": book["title"],
                          "author": book["author"],
                          "email": book["email"],
                          "availability": book["availability"],
                        };
                        await userServices.updateBookAvailability(requestBody);
                        setState(() {});
                      },
                    )
                  ])
            ]))));
  }
}
