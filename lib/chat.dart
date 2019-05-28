import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:io';

final FirebaseAuth _auth = FirebaseAuth.instance;
final replyController =  TextEditingController();



class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}


class _ChatPageState extends State<ChatPage> {



    Widget build(BuildContext context) {
//      final ScreenArguments args = ModalRoute.of(context).settings.arguments;

      return Scaffold(
        appBar: AppBar(
          title: Text("chat test"),
          backgroundColor: Color.fromARGB(255, 25, 14, 78),
        ),
        body: Container(
          margin: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('ChatRoom').where('userA', isEqualTo: "aaa").where('userB', isEqualTo: 'bbb').snapshots(),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData) return Container();
//                    DocumentSnapshot document = snapshot.data.documents;
//                    print(document['userA']);
                    return ListView.builder(
                      padding: EdgeInsets.all(8.0),
                      reverse: true,
                      itemBuilder: (_, int index) {
                        DocumentSnapshot document = snapshot.data.documents[0];
                        var messageCnt = document['messages'].length;

                        bool isOwnMessage = false;
                        if(document['messages'][messageCnt - index - 1]['name'] == "승수") isOwnMessage = true;
                        return isOwnMessage ?
                        _ownMessage(document['messages'][messageCnt - index - 1]['content'], document['messages'][messageCnt - index - 1]['name'])
                            :
                        _message(document['messages'][messageCnt - index - 1]['content'], document['messages'][messageCnt - index - 1]['name']);

                      },
//                      itemCount: 2,//snapshot.data.documents[0]['messages'][0].length
                      itemCount: snapshot.data.documents.first['messages'].length,
                    );
                  },
                ),
              )
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