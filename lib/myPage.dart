import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'detail.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;

String defimg = "https://firebasestorage.googleapis.com/v0/b/final-4575e.appspot.com/o/logo.png?alt=media&token=8be50df6-ef03-4c85-90e6-856ea9d6cb5e";

class MyPage extends StatefulWidget {
  FirebaseUser user;
  DocumentSnapshot document;
  MyPage ({Key key, @required this.document, @required this.user});
  @override
  _MyPageState createState() => _MyPageState();

}

class _MyPageState extends State<MyPage> {
  DocumentSnapshot document;
  FirebaseUser user;
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
            Center(child: Text("마이 페이지",style: TextStyle(fontSize: 25,color:Colors.white))),
            _UserInfoSection()
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 25, 14, 78),
    );
  }
}
class _UserInfoSection extends StatefulWidget {
  @override
  FirebaseUser user;
  DocumentSnapshot document;
  _UserInfoSection ({Key key, @required this.document, @required this.user});
  State<StatefulWidget> createState() => _UserInfoState();
}

class _UserInfoState extends State<_UserInfoSection> {
  List<Item> _data = generateItems(3);
  DocumentSnapshot document;
  double _bodyHeight=0.0;
  FirebaseUser user;
  String _selectedCategory='물건';// = '물건';
  String _selectedSubCategory = '공구';// = '공구';
//  String imageUrl="";
  String imageUrl = defimg;
  String phoneN = "";
  String myName = "";
  String userUID;
  bool isAnonymous = true;
  bool getOnce = false;
  void getUSer() async {
    getOnce = true;
    final FirebaseUser user = await _auth.currentUser();

    setState(() {
      user.displayName == null ? myName = "익명" : myName = user.displayName;
      userUID = user.uid;
      user.photoUrl == null ? imageUrl = defimg : imageUrl = user.photoUrl;
      isAnonymous = user.isAnonymous;
      phoneN = user.phoneNumber;
    });

//    print(imageUrl);
//    print(myName);
//    print(user.uid);
//    print(isAnonymous);
  }

  Widget build(BuildContext context) {
    if(!getOnce) getUSer();

    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
}
  Widget _buildPanel() {
    return Container(
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.fromLTRB(16.0, 50, 16.0, 10),
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(10.0),
          color: Color.fromARGB(50, 0, 0, 0),
        ),
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                child:
                  Row(
                      children:[
                        Image.network(imageUrl,width:100.0,height:100.0),
                        SizedBox(width:30),
                        Text(myName,style: TextStyle(fontSize: 20.0, color:Colors.white)),
                      ]
                  ),
                ),
                SizedBox(height:30),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                  ],
                ),
                    ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      print(index.toString() + ", " + isExpanded.toString());
                      setState(() {
                        _data[index].isExpanded = !isExpanded;
                        if(_data[0].isExpanded) {
                          _data[0].isExpanded = !_data[0].isExpanded;
                          _data[1].isExpanded = false;
                          _data[2].isExpanded = false;
                          if(!_data[0].isExpanded)
                            _data[0].isExpanded = !_data[0].isExpanded;
                        }
                        else if(_data[1].isExpanded){
                          _data[0].isExpanded = false;
                          _data[1].isExpanded = !_data[1].isExpanded;
                          _data[2].isExpanded = false;
                          if(!_data[1].isExpanded)
                            _data[1].isExpanded = !_data[1].isExpanded;
                        }
                        else if (_data[2].isExpanded) {
                          _data[0].isExpanded = false;
                          _data[1].isExpanded = false;
                          _data[2].isExpanded = true;
                          if(!_data[2].isExpanded)
                            _data[2].isExpanded = !_data[2].isExpanded;
                        }
                      });
                      },
                      children: _data.map<ExpansionPanel>((Item item) {
                      return ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text(item.headerValue),
                          );
                          },
                          body: ListTile(
//                          title: Text(item.expandedValue),
                          subtitle:  StreamBuilder<QuerySnapshot>(
                              stream:
                              item.expandedValue == 0?
                              Firestore.instance.collection('Transactions').where('buyer', isEqualTo: userUID).snapshots():
                              item.expandedValue == 1?
                              Firestore.instance.collection('Items').where('seller', isEqualTo: userUID).snapshots():
                              Firestore.instance.collection('Items').where('likedUser', arrayContains: userUID).snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) return LinearProgressIndicator();
                                if(snapshot.data.documents.length == 0) return Text("찾으시는 검색결과가 없넹~",style:TextStyle(color:Colors.white));
                                return Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      GridView.count(
                                        crossAxisCount: 4,
                                        shrinkWrap: true,
                                        childAspectRatio: 2/3,
                                        physics: ScrollPhysics(), // 스크롤 가능하게 해줌
                                        children: snapshot.data.documents.map((data) => _buildListItem(context, data, item.expandedValue)).toList(),
                                      )
                                    ],
                                  ),
                                );
                              }
                          ),
                         ),
                          isExpanded: item.isExpanded,
                        canTapOnHeader: true,
                          );
                          }).toList(),
                        ),
                    ]
    ),
    ),
    ),
    );

                    }
  Widget _buildListItem(BuildContext context, DocumentSnapshot document, int index) {

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            width: 60,
            height: 50,
            child: ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Ink.image(
            image: index == 0?
            NetworkImage(document['imageUrl']) : NetworkImage(document['imageUrl'][0]),
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

        Container(
        margin: EdgeInsets.all(8.0),
        child: Text(document['name'].toString(),style:TextStyle(color:Colors.black,fontSize: 7))
        ),

            ]
        );
                      }
  }
  class Item {
    Item({
      this.expandedValue,
      this.headerValue,
      this.isExpanded = false,
    });

    int expandedValue;
    String headerValue;
    bool isExpanded;
  }
List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return index == 0?
    Item(
      headerValue: '대여중인 상품',
      expandedValue: 0,
    ):
        index == 1?
        Item(
          headerValue: '내 상품',
          expandedValue: 1,
        ):
            Item(
              headerValue: '찜한상품',
              expandedValue: 2);


  });
}

