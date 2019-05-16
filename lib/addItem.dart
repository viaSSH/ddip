import 'package:flutter/material.dart';

final itemCategoryController =  TextEditingController();
final itemPriceController =  TextEditingController();
final itemLocationController =  TextEditingController();
final itemDateController =  TextEditingController();
final itemContentController =  TextEditingController();
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

  final _addItemFormKey = GlobalKey<FormState>();

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
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          style: new TextStyle(color: Colors.white),
                          controller: itemCategoryController,
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
                  IconButton(icon: Icon(Icons.camera_alt,color: Colors.white))
                ],
              ),
              MaterialButton(
                child: Text('대여등록',style: TextStyle(color: Colors.white)),
                color: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/search',
                      arguments: 'item'
                  );
                },
              ),
            ],
          ),
        ),
      )
    );
  }
}