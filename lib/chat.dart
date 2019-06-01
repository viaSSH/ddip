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



  Widget build(BuildContext context) {
      final Map args = ModalRoute.of(context).settings.arguments;
//      chatUid = args['uid'];
//      senderUid = args['buyer'];
      final buyer = args['buyer'];
      final seller = args['seller'];
      print(args['seller']);

      return Scaffold(
        appBar: AppBar(
          title: Text("chat test"),
          backgroundColor: Color.fromARGB(255, 25, 14, 78),
        ),
        body: Container(
          margin: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text("aaa", style: TextStyle(color: Colors.black),),
              Text("buyer : " + args['buyer'], style: TextStyle(color: Colors.black),),
              Text("seller : " + args['seller'], style: TextStyle(color: Colors.black),),
              Text("item : " + args['uid'], style: TextStyle(color: Colors.black),),
              Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('ChatRoom')
                      .where('seller', isEqualTo: seller)
//                      .where('buyer', isEqualTo: buyer).snapshots(),
                      .where('buyer', isEqualTo: buyer)
                      .where('itemUid', isEqualTo: args['uid']).snapshots(),
                  builder: (context, snapshot) {
//                    print(snapshot.data.documents.length);
//                  print(snapshot.requireData.documents[0]['messages']);
                    if(!snapshot.data.documents.isNotEmpty){
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
//                        return _message("a", "b");
                        DocumentSnapshot document = snapshot.data.documents[0];
                        chatUid = document.documentID;
                        var messageCnt = document['messages'].length;

                        bool isOwnMessage = false;
//                        print("db name : " + document['messages'][messageCnt - index - 1]['userUid']);
//                        print("select name : " + args['seller']);
                        if(document['messages'][messageCnt - index - 1]['userUid'] == args['seller']) isOwnMessage = true;
                        return isOwnMessage ?
                        _message(document['messages'][messageCnt - index - 1]['content'], document['messages'][messageCnt - index - 1]['name'])
                            :
                        _ownMessage(document['messages'][messageCnt - index - 1]['content'], document['messages'][messageCnt - index - 1]['name']);

                      },
//                      itemCount: 1,//snapshot.data.documents[0]['messages'][0].length
                        itemCount: snapshot.data.documents.isEmpty ? 0 : snapshot.data.documents.first['messages'].length,
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
}