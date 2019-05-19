import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'detail.dart';
class SearchPage extends StatefulWidget {
  final FirebaseUser user;
  SearchPage ({Key key, @required this.user});
  @override
  _SearchPageState createState() => _SearchPageState();

}

class _SearchPageState extends State<SearchPage> {
  final FirebaseUser user;
  _SearchPageState({Key key, @required this.user});
  final TextEditingController _searchQuery = TextEditingController();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor:Color.fromARGB(255, 25, 14, 78),
          title: TextField(
            controller: _searchQuery,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white) //색이 왜 안바뀌냐 ㅡ.ㅡ 어케하는지 모르겟네

                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 3.0),
                ),
                contentPadding: EdgeInsets.all(8.0),
//            fillColor: Colors.red, //색이 왜 안바뀌냐 ㅡ.ㅡ
                hintText: "검색하기"
            ),
            style: TextStyle(
                color: Colors.purple
            ),
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.all(8.0),
              child: Row(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                            Icons.search,
                            semanticLabel: 'search',
                            color: Colors.white
                        )
                    ),
                    RaisedButton(
                      child: Text("대여날짜",style:TextStyle(color: Colors.white)),
                      padding: EdgeInsets.all(4.0),
                      color: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      onPressed: (){},
                    ),
                  ]
              ),
            ),
          ],

        ),
        backgroundColor: Color.fromARGB(255, 25, 14, 78),
        body: ListView(

          children: <Widget>[
            _QuickQuerySection(),
            _ItemSection()
          ],
        )
    );
  }
}

class _QuickQuerySection extends StatefulWidget {

  @override
//  State<StatefulWidget> createState() => _QuickQuerySectionState();
  _QuickQuerySectionState createState() => _QuickQuerySectionState();
}

class _QuickQuerySectionState extends State<_QuickQuerySection> {



  var _subCategory = ['공구', '옷', '가구'];

  @override

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
//      mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("물건찾기"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              for(var category in _subCategory)
                RaisedButton(
                  child: Text(category, style:TextStyle(color: Colors.white)),
                  color: Color.fromARGB(255, 25, 14, 78),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                    side: BorderSide(color: Colors.white, width: 1.0),
                  ),
                  onPressed: (){
                    print("tap: " + category);
//                    this.widget.callback(category);

                    setState(() {

      //                        _selectedSubCategory = category;
      //                        print(_selectedSubCategory);
                    });
                  },
                )

            ],
          ),

        ],
      ),
    );
  }
}

class _ItemSection extends StatefulWidget {

  @override
//  State<StatefulWidget> createState() => _ItemSectionState();
  _ItemSectionState createState() => new _ItemSectionState();
}

class _ItemSectionState extends State<_ItemSection> {
  // TODO: Add a variable for Category (104)
  final FirebaseUser user;
  _ItemSectionState({Key key, @required this.user});


  String query = "공구";
  callback(newQuery) {
    setState(() {
      query = newQuery;
    });
  }

  @override

//  void initState() {
//    super.initState();
//    feedPage = _QuickQuerySection(this.callback);
//    curentPage = feedPage;
//  }
//
//  void callback(String nextPage) {
//    setState((){
//      this.testVal = nextPage;
//      print(this.testVal);
//    });
//  }


  Widget build(BuildContext context) {
    var _selectedCategory = '물건';
    var _selectedSubCategory = '공구';



    return StreamBuilder<QuerySnapshot>(
//      stream: Firestore.instance.collection('Items').where('category', isEqualTo: _selectedCategory).where('subCategory', isEqualTo: '공구').snapshots(),
        stream: Firestore.instance.collection('Items').where('category', isEqualTo: _selectedCategory).where('subCategory', isEqualTo: _selectedSubCategory).snapshots(),
        builder: (context, snapshot) {

          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("공구",style: TextStyle(fontSize: 20.0, color:Color.fromARGB(255,255,219,181))),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  childAspectRatio: 2/3,
                  physics: ScrollPhysics(), // 스크롤 가능하게 해줌
                  children: snapshot.data.documents.map((data) => _buildListItem(context, data)).toList(),
                )
              ],
            ),
          );
        }
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
//        ClipRRect(
//          borderRadius: BorderRadius.circular(20.0),
//          child: Container(
//            width: 180,
//            height: 100,
//            child: ConstrainedBox(
//              constraints: BoxConstraints.expand(),
//              child: Ink.image(
//                image: NetworkImage(document['imageUrl']),
////                  fit: BoxFit.fill,
//                fit: BoxFit.cover,
//                child: InkWell( onTap: (){
//                  Navigator.push(context,MaterialPageRoute(builder:(context)=>DetailPage(document:document,user:user)));
//                },
//                ),
//              ),
//            ),
//          ),
//        ),
        GestureDetector(
          onTap: (){
//            print(data.documentID);
            Navigator.push(context,MaterialPageRoute(builder:(context)=>DetailPage(document:document,user:user)));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              width: 180,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(document['imageUrl']),
                    fit: BoxFit.cover
                ),
              ),
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.all(8.0),
            child: Text(document['name'])
        ),
        Container(
          margin: EdgeInsets.all(8.0),
          child: document['available'] ? Text("대여가능") : Text("대여중"),
        )

      ],
    );
//    return Padding(
//      padding: const EdgeInsets.all(5.0),
//      child: Column(
//        children: <Widget>[
//          Card(
//            child: InkWell(
//              splashColor: Colors.blue.withAlpha(30),
////          onTap: () {
////            Navigator.pushNamed(context, '/detail',
////                arguments: index
////            );
////          },
//              child: Container(
//                decoration: BoxDecoration(
//                  borderRadius: new BorderRadius.circular(10.0),
//                ),
//                width: 180,
//                height: 100,
//                child: Text("card"),
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
  }
}