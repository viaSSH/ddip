import 'package:flutter/material.dart';

final itemCategoryController =  TextEditingController();
final itemPriceController =  TextEditingController();
final itemLocationController =  TextEditingController();

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
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Text("물건 대여 신청"),
            _AddItemFormSection()
          ],
        ),
      ),
      backgroundColor: Colors.orangeAccent,
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
      margin: EdgeInsets.all(16.0),
      color: Colors.orangeAccent[100],
      child: Form(
        key: _addItemFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,

              children: <Widget>[
                  Container(
                      width: 50,
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("물품종류")
                  ),
                  Flexible(

                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
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
                    width: 50,
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("금액")
                ),
                Flexible(

                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextFormField(
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
                    width: 50,
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("거래장소")
                ),
                Flexible(

                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextFormField(
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

          ],
        )
      )
    );
  }
}