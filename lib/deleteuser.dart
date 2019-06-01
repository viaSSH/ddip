import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'home.dart';

final userNameController = TextEditingController();
final userEmailController = TextEditingController();
final userNickController = TextEditingController();
final userPsswdController = TextEditingController();
final userLocationController = TextEditingController();
final userPhoneController = TextEditingController();

List<dynamic> stime = [];
List<dynamic> etime = [];

class DeleteUserPage extends StatefulWidget {
  final FirebaseUser user;
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;

  DeleteUserPage({
    Key key,
    @required this.user,
    @required this.auth,
    @required this.googleSignIn,
  });

  @override
  _DeleteUserPageState createState() {
    return _DeleteUserPageState(
      user: user,
      auth: auth,
      googleSignIn: googleSignIn,
    );
  }
}

class _DeleteUserPageState extends State<DeleteUserPage> {
  final FirebaseUser user;
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;

  _DeleteUserPageState({
    Key key,
    @required this.user,
    @required this.auth,
    @required this.googleSignIn,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
//        title: Text("asd"),
        backgroundColor: Color.fromARGB(255, 25, 14, 78),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 10),
        child: ListView(
          children: <Widget>[
            Center(
                child: Text("회원 탈퇴",
                    style: TextStyle(color: Colors.white, fontSize: 25))),
            _RegisterFormSection(
              user: user,
              auth: auth,
              googleSignIn: googleSignIn,
            )
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 25, 14, 78),
    );
  }
}

class _RegisterFormSection extends StatefulWidget {
  final FirebaseUser user;
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;

  _RegisterFormSection({
    Key key,
    @required this.user,
    @required this.auth,
    @required this.googleSignIn,
  });

  @override
  _RegisterFormSectionState createState() {
    return _RegisterFormSectionState(
      user: user,
      auth: auth,
      googleSignIn: googleSignIn,
    );
  }
}

class _RegisterFormSectionState extends State<_RegisterFormSection> {
  final FirebaseUser user;
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;

  _RegisterFormSectionState({
    Key key,
    @required this.user,
    @required this.auth,
    @required this.googleSignIn,
  });

  FirebaseStorage _storage = FirebaseStorage.instance;

  final _registerFormKey = GlobalKey<FormState>();
  String imageUrl;

  File _image;

  void userDelete() {
    Firestore.instance
        .collection('Users')
        .document(user.uid)
        .delete()
        .catchError((e) {
      print(e);
    });
  }

  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.fromLTRB(16.0, 50, 16.0, 10),
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(10.0),
          color: Color.fromARGB(50, 0, 0, 0),
        ),
        child: Form(
          key: _registerFormKey,
          autovalidate: true,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: 60,
                        margin:
                            EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                        child:
                            Text("이름", style: TextStyle(color: Colors.white))),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(user.displayName,
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: 60,
                        margin:
                            EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                        child:
                            Text("이메일", style: TextStyle(color: Colors.white))),
                    Flexible(
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                        child: Text(user.email,
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: 60,
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("비밀번호",
                            style: TextStyle(color: Colors.white))),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          style: new TextStyle(color: Colors.white),
                          controller: userPsswdController,
                          obscureText: true,
                          validator: (value) {},
                        ),
                      ),
                    ),
                  ],
                ),
                MaterialButton(
                    child: Text('탈퇴', style: TextStyle(color: Colors.white)),
                    color: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () async {
                      await Firestore.instance
                          .collection('Users')
                          .document(user.uid)
                          .get()
                          .then((value) {
                        print("value.data: ${value.data.values.elementAt(5)}");
                        if (value.data.values.elementAt(5) ==
                            userPsswdController.text) userDelete();
                      });
                      await auth.signOut().then((value) {
                        FirebaseAuth.instance.signOut();
                        googleSignIn.signOut();
                        Navigator.pushNamed(context, '/init');
                      });
                    }),
              ],
            ),
          ),
        ));
  }
}
