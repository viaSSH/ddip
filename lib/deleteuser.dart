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
    DocumentReference docR =
        Firestore.instance.collection('Users').document(user.uid);

    docR.setData({
      'uid': user.uid,
      'name': userNameController.text,
      'email': userEmailController.text,
      'nick': userNickController.text,
      'psswd': userPsswdController.text,
      'location': userLocationController.text,
      'phone': userPhoneController.text,
    });

    userNameController.clear();
    userEmailController.clear();
    userNickController.clear();
    userPsswdController.clear();
    userLocationController.clear();
    userPhoneController.clear();
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new HomePage(
                user: user, auth: auth, googleSignIn: googleSignIn)));
  }

  void uploadPic() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
    //Create a reference to the location you want to upload to in firebase
    StorageReference reference =
        _storage.ref().child("/items/" + DateTime.now().toString() + ".jpg");

    //Upload the file to firebase
    StorageUploadTask uploadTask = reference.putFile(image);

    // Waits till the file is uploaded then stores the download url
//    var downUrl = (await uploadTask.onComplete).ref.getDownloadURL();
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
//    return downUrl.toString();

    imageUrl = url.toString();
//    setState(() {
//      _test = url.toString();
//    });
//    print("this" + url);
  }

  Widget build(BuildContext context) {

    bool pwdmatch = false ;

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
                        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                        child:
                            Text("이름", style: TextStyle(color: Colors.white))),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(user.displayName, style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: 60,
                        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                        child:
                            Text("이메일", style: TextStyle(color: Colors.white))),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                        child: Text(user.email, style: TextStyle(color: Colors.white)),

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
                          validator: (value) {
                            Firestore.instance.collection('Users').document(user.uid).get().then((value){
                              if(value.data[5] !=userPsswdController.text){
                                print(value.data[5]) ;
                                pwdmatch = false ;
                                return 'Password not matching';
                              } else {
                                pwdmatch = true ;
                              }

                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
// 사진첨부기능
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//
//                  children: <Widget>[
//                    Container(
//                        width: 60,
//                        margin: EdgeInsets.symmetric(horizontal: 8.0),
//                        child: Text("사진첨부")
//                    ),
//                    IconButton(
//                      icon: Icon(Icons.camera_alt,color: Colors.white),
//                      onPressed: uploadPic,
//                    )
//                  ],
//                ),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Center(
//                        child: _image == null
//                            ? Text("이미지를 선택해주세요", style: TextStyle(fontSize: 12.0),)
//                            : Container(
//                          height: 100,
//                          width:  160,
//                          decoration: BoxDecoration(
//                              image: DecorationImage(
//                                  image: FileImage(_image),
//                                  fit: BoxFit.fitHeight
//                              )
//                          ),
//                        )
//                    ),
////                  Image.file(_image)
//                  ],
//                ),
                MaterialButton(

                  child: Text('탈퇴', style: TextStyle(color: Colors.white)),
                  color: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    if (pwdmatch)
                      userDelete();
                  }

                ),
              ],
            ),
          ),
        ));
  }
}
