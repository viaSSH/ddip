import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyPage extends StatefulWidget {

  final FirebaseUser user;
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;

  MyPage({Key key,
    @required this.user,
    @required this.auth,
    @required this.googleSignIn,
  });

  @override
  _MyPageState createState() {
    print(user.displayName);

    return _MyPageState(
      user: user,
      auth: auth,
      googleSignIn: googleSignIn,
    );
  }

}

class _MyPageState extends State<MyPage> {

  final FirebaseUser user;
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;

  _MyPageState({
    Key key,
    @required this.user,
    @required this.auth,
    @required this.googleSignIn,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Text("my page"),
          RaisedButton(
            child: Text("move to main page"),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          Text("MYPAGE", style: TextStyle(fontSize: 50), ),
        ],
      ),
      backgroundColor: Colors.indigo,
    );
  }
}