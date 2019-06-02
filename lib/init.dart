import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'register.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class InitPage extends StatefulWidget {
  @override
  _InitPageState createState() => _InitPageState();
}
final String defUrl = 'https://firebasestorage.googleapis.com/v0/b/ddip-d0dc1.appspot.com/o/logo.png?alt=media&token=887a586e-5cba-4807-8339-c4dc130142d2';

class _InitPageState extends State<InitPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: ListView(
          children: <Widget>[
            RaisedButton(
              child: Text("move to main page"),
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            SizedBox(height: 100.0),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Container(
                  width: 250,
                  height: 120,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(defUrl),
                        fit: BoxFit.cover
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height:50),

            Center(
              child: Container(
                child:MaterialButton(
                  minWidth: 200,
                  height: 40,
                  child:
                  Text('구글 로그인', style: TextStyle(color: Colors.white)),
//                  color: Color.fromARGB(255, 25, 14, 78),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.white, width: 1.0),
                  ),
                  onPressed: () => _signInWithGoogle(),
                ),
              ),
            ),
            SizedBox(height:10),
//            Center(
//              child: Container(
//                  child: MaterialButton(
//                    minWidth: 200,
//                    height: 40,
//                    child: Text('익명 로그인',
//                        style: TextStyle(color: Colors.white)),
//                    shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(5),
//                      side: BorderSide(color: Colors.white, width: 1.0),
//                    ),
//                    onPressed: () => _signInAnonymously(),
//                  )
//              ),
//            ),
          ]
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

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);

    final FirebaseUser signedInUser = await _auth.currentUser();
    assert(user.uid == signedInUser.uid);

    print('Signed in as ${signedInUser.uid}');

    Firestore.instance
        .collection('Users')
        .document(signedInUser.uid)
        .get()
        .then((value) {
      print("data: ${value.data}");
      if (value.data != null) {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new HomePage(
                    user: signedInUser,
                    auth: _auth,
                    googleSignIn: _googleSignIn)));
      } else {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new RegisterPage(
                    user: signedInUser,
                    auth: _auth,
                    googleSignIn: _googleSignIn)));
      }
    });
//    var docId = Firestore.instance
//        .collection('Users').getDocuments() ;

//    final DocumentReference documentReference = Firestore.instance.document("myData/dummy");

//    Navigator.pushNamed(context, '/home', arguments: signedInUser);

    setState(() {});
  }

  void _signInAnonymously() async {
    final FirebaseUser user = await _auth.signInAnonymously();
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    Navigator.of(context).pushNamed('/home');
    setState(() {});
  }

  void _signOut() async {
    await _auth.signOut().then((value) {
      _googleSignIn.signOut();
//      final String uid = user.uid;
//      print(uid + ' has successfully signed out.');
//      print(user.displayName);
      Navigator.pushNamed(context, '/init');
    });
  }
}

// class that contains both a customizable title and message.