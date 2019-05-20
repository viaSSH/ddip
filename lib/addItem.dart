import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

final itemCategoryController =  TextEditingController();
final itemNameController =  TextEditingController();
final itemPriceController =  TextEditingController();
final itemLocationController =  TextEditingController();
final itemDateController =  TextEditingController();
final itemContentController =  TextEditingController();
List<dynamic> stime = [];
List<dynamic> etime = [];
class AddItemPage extends StatefulWidget {

  @override
  _AddItemPageState createState() => _AddItemPageState();

}

class _AddItemPageState extends State<AddItemPage> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
//        title: Text("asd"),
        backgroundColor: Color.fromARGB(255, 25, 14, 78),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0,20,8.0,10),
        child: ListView(
          children: <Widget>[
            Center(child: Text("물건 대여 신청",style: TextStyle(fontSize: 25))),
            _AddItemFormSection()
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 25, 14, 78),
    );
  }
}


class _AddItemFormSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddItemFormSectionState();
}

class _AddItemFormSectionState extends State<_AddItemFormSection> {

  FirebaseStorage _storage = FirebaseStorage.instance;

  final _addItemFormKey = GlobalKey<FormState>();
  String imageUrl;

  File _image;

  void uploadItem() {
    DocumentReference docR = Firestore.instance.collection('Items').document();

    docR.setData({
      'category': _SelectedCategory,
      'name': itemNameController.text,
      'price': itemPriceController.text,
      'location': itemLocationController.text,
      'description': itemContentController.text,
      'imageUrl': imageUrl,
      'stime' : stime,
      'etime' : etime,
    }
    );

    itemNameController.clear();
    itemPriceController.clear();
    itemLocationController.clear();
    itemContentController.clear();

  }

  void uploadPic() async {

    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
    //Create a reference to the location you want to upload to in firebase
    StorageReference reference = _storage.ref().child("/items/"+DateTime.now().toString() + ".jpg");

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

  List<String> _categories = <String>['물건', '사람', '공간', '노하우'];
//  List _myCategories = [{'kor': '물건', 'en': 'goods'}, {'kor': '사람', 'id': 'manpower'}];
  String _SelectedCategory = '물건';

  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.fromLTRB(16.0,50,16.0,10),
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(10.0),
          color: Color.fromARGB(50, 0, 0, 0),
        ),
        child: Form(
          key: _addItemFormKey,
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
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("물품종류")
                    ),

                    Flexible(
                      child: FormField(
                        builder: (FormFieldState state) {
                          return Container(
                            margin: EdgeInsets.only(left: 12.0),
                            child: Theme(
                              data: Theme.of(context).copyWith(canvasColor: Colors.orangeAccent),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(

                                  value: _SelectedCategory,
//                                  style: TextStyle(color: Colors.red),
                                  isDense: true,

                                  onChanged: (String newValue) {
                                    setState(() {
//                                  newContact.favoriteColor = newValue;
                                      _SelectedCategory = newValue;
                                      state.didChange(newValue);
                                    });
                                  },
                                  items: _categories.map((String value) {
//                                  items: _myCategories.map( {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Container(
//                                        color: Colors.blue,
                                        width: 200,
                                        child: Text(
                                          value,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),

                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

//                    Flexible(
//                      child: Container(
//                        margin: EdgeInsets.symmetric(horizontal: 8.0),
//                        child: TextFormField(
//                          style: new TextStyle(color: Colors.white),
//                          controller: itemCategoryController,
//                          validator: (value) {
//                            if(value.isEmpty) {
//                              return 'Please enter some text';
//                            }
//                          },
//                        ),
//                      ),
//                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: <Widget>[
                    Container(
                        width: 60,
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("물품명")
                    ),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          style: new TextStyle(color: Colors.white),
                          controller: itemNameController,
                          validator: (value) {
                            if(value.isEmpty) {
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
                        child: Text("거래가격")
                    ),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          style: new TextStyle(color: Colors.white),
                          controller: itemPriceController,
                          validator: (value) {
                            if(value.isEmpty) {
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
                        child: Text("거래장소")
                    ),
                    Flexible(

                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          style: new TextStyle(color: Colors.white),
                          controller: itemLocationController,
                          validator: (value) {
                            if(value.isEmpty) {
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
                        child: Text("대여가능기간")
                    ),
                    Flexible(

                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          style: new TextStyle(color: Colors.white),
                          controller: itemDateController,
                          validator: (value) {
                            if(value.isEmpty) {
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
                        child: Text("물품설명")
                    ),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          style: new TextStyle(color: Colors.white),
                          controller: itemContentController,
                          maxLines: null, //grow automatically
                          validator: (value) {
                            if(value.isEmpty) {
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
                        child: Text("사진첨부")
                    ),
                    IconButton(
                      icon: Icon(Icons.camera_alt,color: Colors.white),
                      onPressed: uploadPic,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                        child: _image == null
                            ? Text("이미지를 선택해주세요", style: TextStyle(fontSize: 12.0),)
                            : Container(
                          height: 100,
                          width:  160,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(_image),
                                  fit: BoxFit.fitHeight
                              )
                          ),
                        )
                    ),
//                  Image.file(_image)
                  ],
                ),
                MaterialButton(
                  child: Text('대여등록',style: TextStyle(color: Colors.white)),
                  color: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  onPressed: uploadItem,
                ),

              ],
            ),
          ),
        )
    );
  }
}