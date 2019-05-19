import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './signin_page.dart';

class InitPage extends StatefulWidget {
  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Text("second page"),
          RaisedButton(
            child: Text("move to main page"),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          SizedBox(height: 100.0),
          Image.network(
              'https://firebasestorage.googleapis.com/v0/b/ddip-d0dc1.appspot.com/o/logo.png?alt=media&token=887a586e-5cba-4807-8339-c4dc130142d2',
              height: 150.0,
              width: 150.0),
          SizedBox(height: 50.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: ButtonTheme(
              minWidth: 10.0,
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  MaterialButton(
                    child:
                        Text('sign in', style: TextStyle(color: Colors.white)),
                    color: Color.fromARGB(255, 25, 14, 78),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () => _pushPage(context, SignInPage()),
                  ),
                  MaterialButton(
                    child: Text('anonymous',
                        style: TextStyle(color: Colors.white)),
                    color: Color.fromARGB(255, 25, 14, 78),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () => null,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.orangeAccent,
    );
  }
  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
}
