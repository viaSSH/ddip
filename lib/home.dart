import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:async/async.dart';
import 'detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'myPage.dart';
import 'chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:async';
import 'deleteuser.dart';
//

class HomePage extends StatefulWidget {
  final FirebaseUser user;
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;

  HomePage({
    Key key,
    @required this.user,
    @required this.auth,
    @required this.googleSignIn,
  });

  @override
  _HomePageState createState() {
    print(user.displayName);
    return new _HomePageState(
      user: user,
      auth: auth,
      googleSignIn: googleSignIn,
    );
  }
}

class _HomePageState extends State<HomePage> {
  final FirebaseUser user;
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;

  _HomePageState({
    Key key,
    @required this.user,
    @required this.auth,
    @required this.googleSignIn,
  });
  final String default_url =
      'https://firebasestorage.googleapis.com/v0/b/ddip-d0dc1.appspot.com/o/logo.png?alt=media&token=887a586e-5cba-4807-8339-c4dc130142d2';
  DocumentReference docR = Firestore.instance.collection('Items').document();
  var _category = ['물건', '사람', '공간', '노하우'];
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
              onPressed: () {
                Navigator.pushNamed(context, '/addItem');
              },
            ),
          )
        ],
      ),
      body: Column(children: [
        Image.network(
            'https://firebasestorage.googleapis.com/v0/b/ddip-d0dc1.appspot.com/o/logo_navy_ddip.png?alt=media&token=70f1d77e-bf9e-4c33-b370-d31fb59c6ffb',
            height: 200.0,
            width: 300.0),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            for (var category in _category)
              MaterialButton(
                child: Text(category, style: TextStyle(color: Colors.white)),
                color: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  Navigator.pushNamed(context, '/search', arguments: category);
                },
              ),
          ]),
        ),
        Flexible(
          child: StreamBuilder(
              stream: Firestore.instance.collection('Items').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text('Loading...');
                return Center(
                  child: SizedBox(
                      width: 390.0,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) => _buildGridCards(
                            context, snapshot.data.documents[index]),
                      )),
                );
              }),
        ),
      ]),
      drawer: Drawer(
        child: Container(
          color: Colors.orangeAccent,
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Text("${user.displayName} 회원님 반갑습네다",
                    style: TextStyle(color: Colors.white)),
                decoration: BoxDecoration(color: Colors.orange),
              ),
              ListTile(
                title: Text("마이페이지", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyPage(user: user)));
//                  Navigator.pushNamed(context, '/myPage');
                },
              ),
              ListTile(
                title: Text("판매통계", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChartPage(user: user)));
                  //                  Navigator.pushNamed(context, '/myPage');
                },
              ),
              ListTile(
                title: Text("로그아웃", style: TextStyle(color: Colors.white)),
                onTap: () {
                  _signOut();
                },
              ),
              ListTile(
                title: Text("탈퇴", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new DeleteUserPage(
                              user: user,
                              auth: auth,
                              googleSignIn: googleSignIn)));
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 25, 14, 78),
    );
  }

  void _signOut() async {
    await auth.signOut().then((value) {
      FirebaseAuth.instance.signOut();
      googleSignIn.signOut();
      Navigator.pushNamed(context, '/init');
    });
  }

  Widget _buildGridCards(BuildContext context, DocumentSnapshot document) {
    return Card(
      color: Color.fromARGB(255, 25, 14, 78),
      // TODO: Adjust card heights (103)
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // TODO: Center items on the card (103)
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
            child: Center(
              child: GestureDetector(
                onTap: () {
//            print(data.documentID);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailPage(document: document, user: user)));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Container(
                    width: 180,
                    height: 110,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(document['imageUrl'][0]),
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
              ),
            ),
          ),
//          AspectRatio(
//              aspectRatio: 23 / 11,
//              child: document['imgurl']==null? Image.network(default_url) : Image.network(document['imgurl'])
//          ),
          Expanded(
            child: Column(
              // TODO: Align labels to the bottom and center (103)
              crossAxisAlignment: CrossAxisAlignment.start,
              // TODO: Change innermost Column (103)
              children: <Widget>[
                // TODO: Handle overflowing labels (103)
                // TODO(larche): Make headline6 when available
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 3.0, 0),
                  child: Text("물품명: " + document['name'],
                      maxLines: 1,
                      style: TextStyle(fontSize: 14.0, color: Colors.white)),
                ),
                SizedBox(height: 2.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0, 3.0, 0),
                  child: Row(children: [
                    Text("가격: " + document['price'].toString() + "원",
                        style: TextStyle(fontSize: 14.0, color: Colors.white)),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 카테고리 인기리스트 시작
class _TopCategorySection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TopCategorySectionState();
}

Stream<QuerySnapshot> stream1 = Firestore.instance
    .collection('Items')
    .where('category', isEqualTo: 'goods')
    .snapshots();
Stream<QuerySnapshot> stream2 = Firestore.instance
    .collection('Items')
    .where('category', isEqualTo: 'goods')
    .snapshots();
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
