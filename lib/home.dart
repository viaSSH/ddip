import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:async/async.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {





  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 25, 14, 78),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.all(8.0),
            child: FlatButton(
              padding: EdgeInsets.all(4.0),
              child: Text("물건올리기", style: TextStyle(color: Colors.white)),
              onPressed: (){
                Navigator.pushNamed(context, '/addItem');
              },
            ),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          _BannerSection(),
          _CategorySection(),
          _TopCategorySection(),
//          Text("first page"),
//          RaisedButton(
//            child: Text("move to main page"),
//            onPressed: () {
//
//            },
//          ),
        ],
      ),
      drawer: Drawer(

        child: Container(
          color: Colors.indigo,
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Text("aaa"),
                decoration: BoxDecoration(
                  color: Colors.blue
                ),
              ),
              ListTile(
                title: Text("마이페이지"),

                onTap: () {
                  Navigator.pushNamed(context, '/myPage');

                },
              ),
              ListTile(
                title: Text("로그아웃"),
                onTap: () {
                  Navigator.pushNamed(context, '/init');

                },
              )
            ],
          ),
        ),
      ),

      backgroundColor: Color.fromARGB(255, 25, 14, 78),
    );
  }
}

// 배너 부분 시작
class _BannerSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BannerSectionState();
}

class _BannerSectionState extends State<_BannerSection> {

  Widget build(BuildContext context) {
    return Image.network(
        'https://firebasestorage.googleapis.com/v0/b/ddip-d0dc1.appspot.com/o/ddip_logo_navy.png?alt=media&token=418b7f31-8905-469b-9cbd-c520f86bd038',
        height: 150.0,width:150.0);
  }
}

// 배너부분 끝


// 카테고리 이동부분 시작
class _CategorySection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<_CategorySection> {

  DocumentReference docR = Firestore.instance.collection('Items').document();

  var _category = ['물건', '사람', '공간', '노하우'];

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          for(var category in _category)
          MaterialButton(
            child: Text(category,style: TextStyle(color: Colors.white)),
            color: Colors.orangeAccent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/search',
                arguments: category
              );
            },
          ),
//          MaterialButton(
//            child: Text('사람',style: TextStyle(color: Colors.white)),
//            color: Colors.orangeAccent,
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(10)
//            ),
//            onPressed: () {
//            },
//          ),
//          MaterialButton(
//            child: Text('공간',style: TextStyle(color: Colors.white)),
//            color: Colors.orangeAccent,
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(10)
//            ),
//            onPressed: () {
//
//            },
//          ),
//          MaterialButton(
//            child: Text('노하우',style: TextStyle(color: Colors.white)),
//            color: Colors.orangeAccent,
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(10)
//            ),
//            onPressed: () {
//
//            },
//          ),
        ],
      ),
    );
  }
}

// 카테고리 이동부분 끝

// 카테고리 인기리스트 시작
class _TopCategorySection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TopCategorySectionState();
}

Stream<QuerySnapshot> stream1 = Firestore.instance.collection('Items').where('category', isEqualTo: 'goods').snapshots();
Stream<QuerySnapshot> stream2 = Firestore.instance.collection('Items').where('category', isEqualTo: 'goods').snapshots();
var mygroup = StreamZip([stream1, stream2]);

//var mygroup = StreamGroup();

class _TopCategorySectionState extends State<_TopCategorySection> {

  var itemCate = ['goods', 'manpower', 'place', 'knowhow'];


  StreamZip bothStreams = StreamZip([stream1, stream2]);


//  mygroup.add(stream1);
//  test.add(stream2);


//    var mygroup = StreamGroup.merge([stream1, stream2]);


//  StreamGroup streamGroup = StreamGroup([stream1, stream2]);
//  Firestore.instance.collection('Items').snapshots();

  Widget build(BuildContext context) {
    final double cardWidth = 100.0;
    final double cardHeight = 100.0;



//    bothStreams.listen((snaps) {
//      DocumentSnapshot snapshot1 = snaps[0];
//      DocumentSnapshot snapshot2 = snaps[1];
//
//
//
//
//      print(snapshot1['name']);
////      return Text(snapshot1['name']);
//    });

//    return Text("asd");

//      return StreamBuilder<List<QuerySnapshot>>(
//        stream: mygroup,
//        builder: (BuildContext context, AsyncSnapshot<List<QuerySnapshot>> snapshot) {
//          print(snapshot);
//          if(snapshot.hasData) print("have");
//          else print("not");
//          return Text("aa");
//        },
//
//      );

//      return StreamBuilder<QuerySnapshot>(
//        stream: bothStreams,
////      stream:  Firestore.instance.collection('Items').snapshots(),
//        builder: (context, snapshot) {
////          print(snapshot.data);
//          var userD = snapshot.data;
//
//          var test = userD.documents;
//
//          return Column(
//            children: snapshot.data.documents.map((document) => Text(document['name']) ).toList(),
//          );
//
//          return Text("asdasdasd");
//        },
//      );

  return Text("어케짜야될지모르겟다 ㅜㅜ");



//    return StreamBuilder<List<QuerySnapshot>>(
//      stream: Firestore.instance.collection('Items').snapshots(),
//      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//        if (!snapshot.hasData) return new Text('Loading...');
//        return new Column(
//          children: snapshot.data.documents.map((document) {
//            return  Text(document['name']);
//          }).toList(),
//        );
//      },
//    );
//      return StreamBuilder<List<QuerySnapshot>>(
//        stream: streamGroup,
//        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshotList) {
////          DocumentSnapshot snapshot1 = snapshotList[0];
//
//        },
//      );
//
//    return Padding(
//      padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
//      child: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          Text("물건"),
//          Container(
//            height: cardHeight,
//            margin: EdgeInsets.symmetric(vertical: 20.0),
//            child: ListView(
//              shrinkWrap: true,
//              scrollDirection: Axis.horizontal,
//              children: <Widget>[
//                Container(
//                  width: cardWidth,
//                  margin: EdgeInsets.symmetric(horizontal: 8.0),
//                  color: Colors.white,
//                  child: Text("item"),
//                ),
//                Container(
//                  width: cardWidth,
//                  margin: EdgeInsets.symmetric(horizontal: 8.0),
//                  color: Colors.white,
//                  child: Text("item"),
//                ),
//                Container(
//                  width: cardWidth,
//                  margin: EdgeInsets.symmetric(horizontal: 8.0),
//                  color: Colors.white,
//                  child: Text("item"),
//                ),
//                Container(
//                  width: cardWidth,
//                  margin: EdgeInsets.symmetric(horizontal: 8.0),
//                  color: Colors.white,
//                  child: Text("item"),
//                ),
//
//              ],
//            ),
//          ),
//
//          Text("사람"),
//          Container(
//            height: cardHeight,
//            margin: EdgeInsets.symmetric(vertical: 20.0),
//            child: ListView(
//              shrinkWrap: true,
//              scrollDirection: Axis.horizontal,
//              children: <Widget>[
//                Container(
//                  width: cardWidth,
//                  margin: EdgeInsets.symmetric(horizontal: 8.0),
//                  color: Colors.white,
//                  child: Text("item"),
//                ),
//                Container(
//                  width: cardWidth,
//                  margin: EdgeInsets.symmetric(horizontal: 8.0),
//                  color: Colors.white,
//                  child: Text("item"),
//                ),
//                Container(
//                  width: cardWidth,
//                  margin: EdgeInsets.symmetric(horizontal: 8.0),
//                  color: Colors.white,
//                  child: Text("item"),
//                ),
//                Container(
//                  width: cardWidth,
//                  margin: EdgeInsets.symmetric(horizontal: 8.0),
//                  color: Colors.white,
//                  child: Text("item"),
//                ),
//
//              ],
//            ),
//          ),
//
//          Text("공간"),
//          Container(
//            height: cardHeight,
//            margin: EdgeInsets.symmetric(vertical: 20.0),
//            child: ListView(
//              shrinkWrap: true,
//              scrollDirection: Axis.horizontal,
//              children: <Widget>[
//                Container(
//                  width: cardWidth,
//                  margin: EdgeInsets.symmetric(horizontal: 8.0),
//                  color: Colors.white,
//                  child: Text("item"),
//                ),
//                Container(
//                  width: cardWidth,
//                  margin: EdgeInsets.symmetric(horizontal: 8.0),
//                  color: Colors.white,
//                  child: Text("item"),
//                ),
//                Container(
//                  width: cardWidth,
//                  margin: EdgeInsets.symmetric(horizontal: 8.0),
//                  color: Colors.white,
//                  child: Text("item"),
//                ),
//                Container(
//                  width: cardWidth,
//                  margin: EdgeInsets.symmetric(horizontal: 8.0),
//                  color: Colors.white,
//                  child: Text("item"),
//                ),
//
//              ],
//            ),
//          ),
//
//
//        ],
//      ),
//    );

  }
}

// 배너부분 끝
