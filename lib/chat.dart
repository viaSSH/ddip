import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:io';

final FirebaseAuth _auth = FirebaseAuth.instance;
final replyController =  TextEditingController();

String chatUid = "";
String senderUid = "";
String receiverUid = "";

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}


class _ChatPageState extends State<ChatPage> {

  final _sendMsgController = TextEditingController();


  void _handleSubmit(String message) async {
    final FirebaseUser user = await _auth.currentUser();

    _sendMsgController.text = "";
    var db = Firestore.instance;
    db.collection("ChatRoom").document(chatUid).updateData({
      'messages': FieldValue.arrayUnion([
        {
          'content': message,
          'userUid': user.uid,
          'name': user.displayName,
        }
      ])
    }
    );
  }

//  Future<String> getNickData(String uid) async {
//    return await Future(() => )
//  }

  Future<String> getNickName(uid) async {

//    return getNickData(uid);
    print("find : " + uid);
    final String thisNick = await

    Firestore.instance.collection('Users').document(uid).get().then((docSnap) async {
      var channelName = docSnap['nick'];
      print("return : " + channelName);
//      assert(channelName is String);
//      thisNick = docSnap['nick'];
      return channelName;
    });

    return thisNick;
  }

bool getFirst = false;
  String buyer = null;
  String seller = null;

  Widget build(BuildContext context) {
      final Map args = ModalRoute.of(context).settings.arguments;
//      chatUid = args['uid'];
//      senderUid = args['buyer'];
    if(buyer == null) buyer = args['buyer'];
    if(seller == null) seller = args['seller'];
//      String buyer = args['buyer'];
//
//      String seller = args['seller'];
//      print(args['seller'] + "  : " + args['uid']);

      return Scaffold(
        appBar: AppBar(
          title: Text("chat test"),
          backgroundColor: Color.fromARGB(255, 25, 14, 78),
          leading: IconButton(icon: Icon(Icons.keyboard_backspace), onPressed: (){
            buyer = null;
            seller = null;
            Navigator.pop(context);
          }),
        ),
        body: Container(
          margin: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
//              Text("buyer : " + args['buyer'], style: TextStyle(color: Colors.black),),
//              Text("seller : " + args['seller'], style: TextStyle(color: Colors.black),),
//              Text("item : " + args['uid'], style: TextStyle(color: Colors.black),),
              buyer == seller ? Flexible(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('ChatRoom')
                        .where('seller', isEqualTo: seller)
//                      .where('buyer', isEqualTo: buyer).snapshots(),
//                        .where('buyer', isEqualTo: buyer)
                        .where('itemUid', isEqualTo: args['uid']).snapshots(),
                    builder: (context, snapshot) {
//                      return Text("yes", style: TextStyle(color: Colors.black87));
                     print(snapshot.hasData);
                      if(snapshot.hasData && snapshot.data.documents.length == 0)
                      {
                        return Text("대화를 시작할 상대가 없습니다", style: TextStyle(color:Colors.black87),);
                      }


                      return ListView.builder(
                        padding: EdgeInsets.all(8.0),
                        reverse: true,
                        itemBuilder: (_, int index) {
//                          DocumentReference docR = await Firestore.instance.collection('Users').document((index+1).toString());
//                          Future<String> nickname = getNickName(snapshot.data.documents[index]['buyer']);
//                          var nickname = "";
//                          Firestore.instance.collection('Users').document(snapshot.data.documents[index]['buyer']).get().then((docSnap) {
//
//                            nickname = docSnap['nick'];
//                            print(nickname);
//                          });

                          return FutureBuilder(
                            future: getNickName(snapshot.data.documents[index]['buyer']),
                            initialData: "loading",
                            builder: (BuildContext context, AsyncSnapshot<String> text){
                              print(text.data);
                              return RaisedButton(
                                child: Text("구매자 " + (index+1).toString() + " : " + text.data.toString() + "의 대화방으로 이동하기", style: TextStyle(color: Colors.black87)),
                                onPressed: () {
                                  print("press" + index.toString());
                                  print(snapshot.data.documents[index]['seller']);
                                  print(snapshot.data.documents[index]['buyer']);

                                  setState(() {
                                    buyer = snapshot.data.documents[index]['buyer'];
                                  });


                                },
                              );
                            },
                          );
//                          _chatList("asdasd");
                        },
                        itemCount: !snapshot.hasData || snapshot.data?.documents.isEmpty  ? 0 : snapshot.data.documents.length,
//                        itemCount: snapshot.data.documents.length,
                      );

                    }
                  ),
              ) : Text("", style: TextStyle(color: Colors.black87),),
              Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('ChatRoom')
                      .where('seller', isEqualTo: seller)
//                      .where('buyer', isEqualTo: buyer).snapshots(),
                      .where('buyer', isEqualTo: buyer)
                      .where('itemUid', isEqualTo: args['uid']).snapshots(),
                  builder: (context, snapshot) {
                    print("display buyer: " + buyer);
                    print("display seller: " + seller);
//                  print(snapshot.requireData.documents[0]['messages']);
//                    if(seller != buyer && (!snapshot.hasData || !snapshot.data?.documents.isNotEmpty) ){ //&&
                    if(seller != buyer && (!snapshot.hasData ) ){ //&&
                      chatUid = 'chat_' + args['uid'];

                      print("no data! " + chatUid);

                      var db = Firestore.instance;
                      db.collection("ChatRoom").document(chatUid).setData({
                        'itemUid': args['uid'],
                        'buyer': buyer,
                        'seller': seller,
                        'messages': []
                      });

//                      return Container(child: Text("nothing"),);
                    }


//                    DocumentSnapshot document = snapshot.data.documents;
//                    print(document['userA']);
                    return ListView.builder(
                      padding: EdgeInsets.all(8.0),
                      reverse: true,
                      itemBuilder: (_, int index) {
//                        _message("a", "b");
//                        DocumentSnapshot document = snapshot.data.documents[0];
//                        DocumentSnapshot document = snapshot.data.documents.first;
                        DocumentSnapshot document = snapshot.data?.documents == null? null : snapshot.data.documents.first;




                        chatUid = document.documentID;
                        var messageCnt = document['messages'].length;

                        bool isOwnMessage = false;
//                        print("db name : " + document['messages'][messageCnt - index - 1]['userUid']);
//                        print("select name : " + args['seller']);
                        if(document['messages'][messageCnt - index - 1]['userUid'] == args['buyer']) isOwnMessage = true;
                        return isOwnMessage ?
                        _ownMessage(document['messages'][messageCnt - index - 1]['content'], document['messages'][messageCnt - index - 1]['name'])
                            :
                        _message(document['messages'][messageCnt - index - 1]['content'], document['messages'][messageCnt - index - 1]['name']);

                      },
//                      itemCount: 1,//snapshot.data.documents[0]['messages'][0].length
                        itemCount: !snapshot.hasData || snapshot.data?.documents.isEmpty  ? 0 : snapshot.data.documents.first['messages'].length,
//                      itemCount: snapshot.data.documents.first['messages'].length,
                    );
                  },
                ),
              ),
              Divider(height: 1.0),
              Container(
                margin: EdgeInsets.only(bottom: 20.0, right: 10.0, left: 10.0),
                child: Row(
                  children: <Widget>[
                    new Flexible(
                      child: new TextField(
                        controller: _sendMsgController,
                        onSubmitted: _handleSubmit,
                        decoration:
                        new InputDecoration.collapsed(hintText: "send message"),
                      ),
                    ),
                    new Container(
                      child: new IconButton(
                          icon: new Icon(
                            Icons.send,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            _handleSubmit(_sendMsgController.text);
                          }),
                    ),
                  ],
                ),
              ),

            ],
          ),
        )
      );
    }

    Widget _message(String message, String name) {
      return Row(
        children: <Widget>[
          Icon(Icons.person),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10.0),
              Text(name , style: TextStyle(color: Colors.black)),
              Text(message, style: TextStyle(color: Colors.black),)
            ],
          ),
        ],
      );
    }

    Widget _ownMessage(String message, String name) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              SizedBox(height: 10.0),
              Text(name , style: TextStyle(color: Colors.black)),
              Text(message, style: TextStyle(color: Colors.black),)
            ],
          ),
          Icon(Icons.person),
        ],
      );
    }


  Widget _chatList(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(height: 10.0),
            Text("zzzzzz", style: TextStyle(color: Colors.black)),
            Text(name , style: TextStyle(color: Colors.black)),
          ],
        ),
      ],
    );
  }
}