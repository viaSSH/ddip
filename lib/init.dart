import 'package:flutter/material.dart';

class InitPage extends StatefulWidget {

  @override
  _InitPageState createState() => _InitPageState();

}

class _InitPageState extends State<InitPage> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Text("second page"),
          RaisedButton(
            child: Text("move to main page"),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
        ],
      ),
    );
  }
}