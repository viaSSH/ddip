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
final String defUrl = 'https://firebasestorage.googleapis.com/v0/b/ddip-d0dc1.appspot.com/o/logo.png?alt=media&token=887a586e-5cba-4807-8339-c4dc130142d2';


var formatDate = DateFormat('yyyy.MM.dd');
class EditItemPage extends StatefulWidget {

  @override
  _EditItemPageState createState() => _EditItemPageState();

}

class _EditItemPageState extends State<EditItemPage> {

  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(36.103079, 129.3880255);
  LatLng _lastMapPosition = _center;



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
//      appBar: AppBar(
////        title: Text("asd"),
//        backgroundColor: Color.fromARGB(255, 25, 14, 78),
//        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
////          getOnce = true;
//        }),
//      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0,20,8.0,10),
        child: ListView(
          children: <Widget>[
            Center(child: Text("물건 정보 수정",style: TextStyle(fontSize: 25,color:Colors.white))),
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
//  DateTime _stime = DateTime.now();
//  DateTime _etime = DateTime.now();
  List<dynamic> _stime = [DateTime.now()];
  List<dynamic> _etime = [DateTime.now()];
  FirebaseStorage _storage = FirebaseStorage.instance;

  final _addItemFormKey = GlobalKey<FormState>();
  String imageUrl;

  var imageUrls = [];

  File _image;

  bool getOnce = true;

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

  void uploadItem(id) async{
    DocumentReference docR = Firestore.instance.collection('Items').document(id);
//    final FirebaseUser user = await _auth.currentUser();
//    if(imageUrls.isEmpty){
//      imageUrls.add(defUrl);
//    }
    docR.updateData({
      'category': _SelectedCategory,
      'name': itemNameController.text,
      'price': itemPriceController.text,
      'location': itemLocationController.text,
      'subCategory' :itemSubCategoryController.text,
//      'seller': user.uid,
      'description': itemContentController.text,
//      'imageUrl': imageUrl,
      if(!imageUrls.isEmpty) 'imageUrl': imageUrls,
      'stime' : _stime,
      'etime' : _etime,
      'latitude': lattitude,
      'longitude': longitude,
//      'like': 0,
//      'likedUser': [],
//      'reply': []
    }
    );

    itemNameController.clear();
    itemPriceController.clear();
    itemLocationController.clear();
    itemSubCategoryController.clear();
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

  void updateScreen(data) {
    if(getOnce){
      itemCategoryController.text = data['category'];
      itemSubCategoryController.text = data['subCategory'];
      itemNameController.text = data['name'];
      itemPriceController.text = data['price'];
      itemLocationController.text = data['location'];
//    itemDateController =  TextEditingController();
      itemContentController.text = data['description'];

      _SelectedCategory = data['category'];
      int sLen = data['stime'].length;
      int eLen = data['etime'].length;
      print(data['stime'][sLen-1].seconds);
      _stime[0] = DateTime.fromMillisecondsSinceEpoch(data['stime'][sLen-1].seconds*1000);
      _etime[0] = DateTime.fromMillisecondsSinceEpoch(data['etime'][eLen-1].seconds*1000);

      getOnce = false;
    }

  }

  void deleteItem(id) {
    DocumentReference docR = Firestore.instance.collection('Items').document(id);

    docR.delete();
  }

  List<String> _categories = <String>['물건', '사람', '공간', '노하우'];
//  List _myCategories = [{'kor': '물건', 'en': 'goods'}, {'kor': '사람', 'id': 'manpower'}];
  String _SelectedCategory;// = '물건';



  Widget build(BuildContext context) {

    DocumentSnapshot data = ModalRoute.of(context).settings.arguments;
//    print(data.data['name']);
    updateScreen(data);



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
                    Text(formatDate.format(_stime[0])+" - ",style:TextStyle(color:Colors.white) ),
                    Text(formatDate.format(_etime[0]),style:TextStyle(color:Colors.white)),
// Text(etime.toString(),style:TextStyle(color:Colors.white)),

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
                            _stime[0] = picked[0];
                            _etime[0] = picked[1];
                          });


                          print(_stime[0]);
                          print(picked[0]);
                        }

                        if (picked != null && picked.length == 1) {
                          setState(() {
                            _stime[0] = picked[0];
                            _etime[0] = picked[0];
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
                            ? Image.network(
                                  data['imageUrl'][0],
                                width: 200,
                                height:120
                              )
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8,8,0,8),
                      child: MaterialButton(
                        child: Text('삭제',style: TextStyle(color: Colors.white)),
                        color: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        onPressed: () {
                          deleteItem(data.documentID);
                          getOnce = true;
                          Navigator.pop(context);
//                          Navigator.popUntil(context, ModalRoute.withName('/home'));
//                          Navigator.of(context).popUntil(ModalRoute.withName('/home'));

                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8,8,0,8),
                      child: MaterialButton(
                        child: Text('대여등록',style: TextStyle(color: Colors.white)),
                        color: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        onPressed: () {
                          uploadItem(data.documentID);
                          getOnce = true;
                          Navigator.of(context).pop();
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(8,8,0,8),
                      child: MaterialButton(
                        child: Text('취소',style: TextStyle(color: Colors.white)),
                        color: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        onPressed: () {
                          getOnce = true;
                          Navigator.of(context).pop();
                        },
                      ),
                    ),


                  ],
                )


              ],
            ),
          ),
        )
    );
  }
}