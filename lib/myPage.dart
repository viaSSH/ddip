import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {

  @override
  _MyPageState createState() => _MyPageState();

}

class _MyPageState extends State<MyPage> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Text("my page",style:TextStyle(color:Colors.white)),
          RaisedButton(
            child: Text("move to main page",style:TextStyle(color:Colors.white)),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
        ],
      ),
      backgroundColor: Colors.indigo,
    );
  }
}