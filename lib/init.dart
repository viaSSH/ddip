import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class InitPage extends StatefulWidget {
  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {

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
//                    onPressed: () => _pushPage(context, SignInPage()),
                    onPressed: () => _signInWithGoogle(),
                  ),
                  MaterialButton(
                    child: Text('anonymous',
                        style: TextStyle(color: Colors.white)),
                    color: Color.fromARGB(255, 25, 14, 78),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () => _signInAnonymously(),
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

//  void _pushPage(BuildContext context, Widget page) {
//    Navigator.of(context).push(
//      MaterialPageRoute<void>(builder: (_) => page),
//    );
//  }

  void _signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    _googleSignIn.signIn().then((result) {
      result.authentication.then((googleKey) {
        FirebaseAuth.instance
            .signInWithCredential(
            GoogleAuthProvider.getCredential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            )).then((signedInUser) {
          print('Signed in as ${signedInUser.displayName}');
          Navigator.of(context).pushNamed('/home');
        }).catchError((e) {
          print(e);
        });
      }).catchError((e) {
        print(e);
      });
    }).catchError((e) {
      print(e);
    });
  }

  void _signInAnonymously() async {
    final FirebaseUser user = await _auth.signInAnonymously();


    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    Navigator.of(context).pushNamed('/home');
    setState(() {

    });
  }
}








