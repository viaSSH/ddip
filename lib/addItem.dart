import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'detail.dart';
import 'map.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter/services.dart';

final itemCategoryController =  TextEditingController();
final itemSubCategoryController =  TextEditingController();
final itemNameController =  TextEditingController();
final itemPriceController =  TextEditingController();
final itemLocationController =  TextEditingController();
final itemDateController =  TextEditingController();
final itemContentController =  TextEditingController();

final FirebaseAuth _auth = FirebaseAuth.instance;
double lattitude = 0;
double longitude = 0;
List<dynamic> stime = [];
List<dynamic> etime = [];
var formatDate = DateFormat('yyyy.MM.dd');
class AddItemPage extends StatefulWidget {

  @override
  _AddItemPageState createState() => _AddItemPageState();

}

class _AddItemPageState extends State<AddItemPage> {

  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(36.103079, 129.3880255);
  LatLng _lastMapPosition = _center;



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
            Center(child: Text("물건 대여 신청",style: TextStyle(fontSize: 25,color:Colors.white))),
            _AddItemFormSection(),
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

  var imageUrls = [];

  File _image;

  void goToMapScreen() async {
    LatLng result = await Navigator.push(context, new MaterialPageRoute(
      builder: (BuildContext context) => MapPage(),
      fullscreenDialog: true,)
    );

    lattitude = result.latitude;
    longitude = result.longitude;

//    Scaffold.of(context).showSnackBar(
//        SnackBar(content: Text("$result"), duration: Duration(seconds: 3),));
  }

  void uploadItem() async{
    DocumentReference docR = Firestore.instance.collection('Items').document();
    final FirebaseUser user = await _auth.currentUser();
    docR.setData({
      'category': _SelectedCategory,
      'name': itemNameController.text,
      'price': itemPriceController.text,
      'location': itemLocationController.text,
      'subCategory' :itemSubCategoryController.text,
      'seller': user.uid,
      'description': itemContentController.text,
//      'imageUrl': imageUrl,
      'imageUrl': imageUrls,
      'stime' : stime,
      'etime' : etime,
      'latitude': lattitude,
      'longitude': longitude,
      'like': 0,
      'likedUser': [],
      'reply': []
    }
    );

    itemNameController.clear();
    itemPriceController.clear();
    itemLocationController.clear();
    itemContentController.clear();
    itemDateController.clear();
//    stime.clear();
//    etime.clear();
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

  void _getImageList() async {
    var resultList = await MultiImagePicker.pickImages(
      maxImages :  10 ,
      enableCamera: false,
    );

    // The data selected here comes back in the list
    print(resultList);
    for ( var imageFile in resultList) {
      postImage(imageFile).then((downloadUrl) {
        // Get the download URL
        print(downloadUrl.toString());
        imageUrls.add(downloadUrl.toString());
      }).catchError((err) {
        print(err);
      });
    }
    print(imageUrls);
  }

  Future<dynamic> postImage(Asset asset) async {
////    await imageFile.requestOriginal();
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
////    StorageReference reference = _storage.ref().child("/items/"+DateTime.now().toString() + ".jpg");
//    StorageReference reference = FirebaseStorage.instance.ref().child("/items/"+ fileName + ".jpg");
////    StorageUploadTask uploadTask = reference.putData(imageFile.imageData.buffer.asUint8List());
////    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
////    return storageTaskSnapshot.ref.getDownloadURL();

    ByteData byteData = await asset.requestOriginal();
    List<int> imageData = byteData.buffer.asUint8List();
    StorageReference ref = FirebaseStorage.instance.ref().child("/items/"+ fileName + ".jpg");
    StorageUploadTask uploadTask = ref.putData(imageData);

    return await (await uploadTask.onComplete).ref.getDownloadURL();
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
                        child: Text("물품종류",style:TextStyle(color:Colors.white))
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
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: <Widget>[
                    Container(
                        width: 60,
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("물품명",style:TextStyle(color:Colors.white))
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
                        child: Text("세부항목",style:TextStyle(color:Colors.white))
                    ),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          style: new TextStyle(color: Colors.white),
                          controller: itemSubCategoryController,
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
                        child: Text("거래가격",style:TextStyle(color:Colors.white))
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
                        child: Text("거래장소",style:TextStyle(color:Colors.white))
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
                    IconButton(
                      icon: Icon(Icons.map,color:Colors.white),
                      onPressed: () {
//                        Navigator.pushNamed(context,'/map');
                        goToMapScreen();
                      },
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: 60,
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("대여가능기간",style:TextStyle(color:Colors.white))
                    ),
              SizedBox(width:10),
              stime.isEmpty?  Text(formatDate.format(DateTime.now())+" - ",style:TextStyle(color:Colors.white) ):
              Text(formatDate.format(stime[0])+" - ",style:TextStyle(color:Colors.white) ),
                    etime.isEmpty?  Text(formatDate.format(DateTime.now()),style:TextStyle(color:Colors.white)):
              Text(formatDate.format(etime[0]),style:TextStyle(color:Colors.white)),
                IconButton(
                color: Colors.white,
                icon: Icon(Icons.calendar_today),
                onPressed: () async {
                  final List<DateTime> picked = await DateRagePicker
                      .showDatePicker(
                    context: context,
                    initialFirstDate: new DateTime.now(),
                    initialLastDate: new DateTime.now(),
                    firstDate: new DateTime(2015),
                    lastDate: new DateTime(2020),
                  );

                  if (picked != null && picked.length == 2) {
                    setState(() {
                      stime[0] = picked[0];
                      etime[0] = picked[1];
                    });


                    print(stime[0].toString() + "end days:" +
                        etime[0].toString());
                  }
                  if (picked != null && picked.length == 1) {
                    setState(() {
                      stime[0] = picked[0];
                      etime[0] = picked[0];
                    });
                  }

                },
              ),

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: <Widget>[
                    Container(
                        width: 60,
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("물품설명",style:TextStyle(color:Colors.white))
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
                        child: Text("사진첨부",style:TextStyle(color:Colors.white))
                    ),
                    IconButton(
                      icon: Icon(Icons.camera_alt,color: Colors.white),
//                      onPressed: uploadPic,
                      onPressed: _getImageList,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                        child: _image == null
                            ? Text("이미지를 선택해주세요", style: TextStyle(fontSize: 12.0,color:Colors.white),)
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(160,8,8,8),
                  child: MaterialButton(
                    child: Text('대여등록',style: TextStyle(color: Colors.white)),
                    color: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    onPressed: uploadItem,
                  ),
                ),

              ],
            ),
          ),
        )
    );
  }
}