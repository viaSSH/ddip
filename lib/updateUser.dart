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
final String defUrl = 'https://firebasestorage.googleapis.com/v0/b/ddip-d0dc1.appspot.com/o/logo.png?alt=media&token=887a586e-5cba-4807-8339-c4dc130142d2';

List<dynamic> stime = [];
List<dynamic> etime = [];

class UpdateUserPage extends StatefulWidget {
  final FirebaseUser user;

  UpdateUserPage({
    Key key,
    @required this.user,
  });

  @override
  _UpdateUserPageState createState() {
    return _UpdateUserPageState(
      user: user,
    );
  }
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  final FirebaseUser user;


  _UpdateUserPageState({
    Key key,
    @required this.user,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title:  ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: Container(
            width: 70,
            height: 50,
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(defUrl),
                  fit: BoxFit.cover
              ),
            ),
          ),
        ),
        backgroundColor: Colors.orangeAccent
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 10),
        child: ListView(
          children: <Widget>[

            SizedBox(height:10),
            Center(
                child: Text("회원정보 수정",
                    style: TextStyle(color: Colors.white, fontSize: 30))),
            _UpdateFormSection(
              user: user,
            )
          ],
        ),
      ),
      backgroundColor: Colors.orangeAccent
    );
  }
}

class _UpdateFormSection extends StatefulWidget {
  final FirebaseUser user;

  _UpdateFormSection({
    Key key,
    @required this.user,

  });

  @override
  _UpdateFormSectionState createState() {
    return _UpdateFormSectionState(
      user: user,
    );
  }
}

class _UpdateFormSectionState extends State<_UpdateFormSection> {
  final FirebaseUser user;


  _UpdateFormSectionState({
    Key key,
    @required this.user,
  });

  FirebaseStorage _storage = FirebaseStorage.instance;

  final _registerFormKey = GlobalKey<FormState>();
  String imageUrl;
  bool pwdmatch ;

  File _image;

  void userUpdate() async {
    DocumentReference docR =
    Firestore.instance.collection('Users').document(user.uid);

    await docR.get().then((value){
      docR.setData({
      'uid': user.uid,
      'name': userNameController.text,
      'email': userEmailController.text,
      'nick': userNickController.text,
      'psswd': userPsswdController.text,
      'location': userLocationController.text,
      'phone': userPhoneController.text,
      });
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
                user: user,)));
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

    DocumentReference docR =
    Firestore.instance.collection('Users').document(user.uid);

    docR.get().then((value){
      userNameController.text = value.data.values.elementAt(3);
      userEmailController.text = value.data.values.elementAt(6);
      userNickController.text = value.data.values.elementAt(0);
      userLocationController.text = value.data.values.elementAt(4);
      userPhoneController.text = value.data.values.elementAt(2);
    });

    return Container(
//        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.fromLTRB(30.0, 40, 30.0, 10),
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(10.0),
          color: Color.fromARGB(10, 0, 0, 0),
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
                        width: 70,
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child:
                            Text("이름", style: TextStyle(color: Colors.white)),),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          style: new TextStyle(color: Colors.white),
                          controller: userNameController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: 70,
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child:
                            Text("이메일", style: TextStyle(color: Colors.white))),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          style: new TextStyle(color: Colors.white),
                          controller: userEmailController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: 70,
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "닉네임",
                          style: TextStyle(color: Colors.white),
                        )),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          style: new TextStyle(color: Colors.white),
                          controller: userNickController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: 70,
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("비밀번호",
                            style: TextStyle(color: Colors.white))),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          style: new TextStyle(color: Colors.white),
                          controller: userPsswdController,
                          obscureText: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                          },
                        ),
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
                        child: Text("비밀번호 확인",
                            style: TextStyle(color: Colors.white))),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          style: new TextStyle(color: Colors.white),
                          obscureText: true,
                          validator: (value) {
                            if (value != userPsswdController.text) {
                              pwdmatch = false ;
                              return 'Password is not matching';
                            }else{
                              pwdmatch = true ;
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: 70,
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("거래위치",
                            style: TextStyle(color: Colors.white))),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          style: new TextStyle(color: Colors.white),
                          controller: userLocationController,
                          maxLines: null, //grow automatically
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: 70,
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("휴대폰번호",
                            style: TextStyle(color: Colors.white))),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          style: new TextStyle(color: Colors.white),
                          controller: userPhoneController,
                          maxLines: null, //grow automatically
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(220,8,0,8),
                  child: MaterialButton(
                    child: Text('수정완료', style: TextStyle(color: Colors.white)),
                    color: Color.fromARGB(255, 25, 14, 78),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: (){
                      if(pwdmatch){
                        userUpdate();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
