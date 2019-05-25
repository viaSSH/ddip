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

//  var _subCategory = ['공구', '옷', '가구'];
  var _subCategory = {'물건': ['공구', '옷', '가구'], '사람': ['사람1', '사람2', '사람3'], '공간': ['축구장', '농구장'], '노하우': ['노하우1', '노하우2'] };

  // 초기값
  String _selectedCategory;// = '물건';
  String _selectedSubCategory = null;// = '공구';

  @override
  Widget build(BuildContext context) {

    final String _thisCategory = ModalRoute.of(context).settings.arguments;
    _selectedCategory = _thisCategory;
//    _selectedSubCategory = _subCategory[_selectedCategory][0];
    if(_selectedSubCategory == null) _selectedSubCategory = _subCategory[_selectedCategory][0];
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
                hintText: "검색하기",
                hintStyle: TextStyle(color: Colors.white),
            ),
            style: TextStyle(
                color: Colors.white
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
                        ),
                      onPressed: () {
                          setState(() {
                            _selectedSubCategory = _searchQuery.text;
                          });

                          print(_selectedSubCategory);
                      },
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
            // 빠른 이동 부분
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
        //      mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("물건찾기",style:TextStyle(color:Colors.white)),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                  for(var category in _subCategory[_thisCategory])
                  RaisedButton(
                    child: Text(category, style:TextStyle(color: Colors.white)),
                    color: Color.fromARGB(255, 25, 14, 78),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                      side: BorderSide(color: Colors.white, width: 1.0),
                    ),
                    onPressed: (){
                      setState(() {

                        _selectedSubCategory = category;
                      });
                    },
                  )

                ],
              ),

              ],
            ),
            ),
            StreamBuilder<QuerySnapshot>(
          //      stream: Firestore.instance.collection('Items').where('category', isEqualTo: _selectedCategory).where('subCategory', isEqualTo: '공구').snapshots(),
              stream: Firestore.instance.collection('Items').where('category', isEqualTo: _selectedCategory).where('subCategory', isEqualTo: _selectedSubCategory).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();
                if(snapshot.data.documents.length == 0) return Text("찾으시는 검색결과가 없넹~",style:TextStyle(color:Colors.white));
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(_selectedSubCategory, style: TextStyle(fontSize: 20.0, color:Color.fromARGB(255,255,219,181))),
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
              ),
          ],
        )
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            width: 180,
            height: 100,
            child: ConstrainedBox(
              constraints: BoxConstraints.expand(),
              child: Ink.image(
                image: NetworkImage(document['imageUrl'][0]),
//                  fit: BoxFit.fill,
                fit: BoxFit.cover,
                child: InkWell( onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder:(context)=>DetailPage(document:document,user:user)));
                },
                ),
              ),
            ),
          ),
        ),
//        GestureDetector(
//          onTap: (){
////            print(data.documentID);
//            Navigator.push(context,MaterialPageRoute(builder:(context)=>DetailPage(document:document,user:user)));
//          },
//          child: ClipRRect(
//            borderRadius: BorderRadius.circular(10.0),
//            child: Container(
//              width: 180,
//              height: 100,
//              decoration: BoxDecoration(
//                image: DecorationImage(image: NetworkImage(document['imageUrl']),
//                    fit: BoxFit.cover
//                ),
//              ),
//            ),
//          ),
//        ),
        Container(
            margin: EdgeInsets.all(8.0),
            child: Text(document['name'],style:TextStyle(color:Colors.white))
        ),
        Container(
          margin: EdgeInsets.all(8.0),
          child: document['available'] ? Text("대여가능",style:TextStyle(color:Colors.white)) : Text("대여중",style:TextStyle(color:Colors.white)),
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

