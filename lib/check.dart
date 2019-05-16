import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class InitPage extends StatefulWidget {

  @override
  _CheckPageState createState() => _CheckPageState();

}

class _CheckPageState extends State<InitPage> {

  @override
  Widget build(BuildContext context) {
    DateTime _date = new DateTime.now();
    DateTime _date2 = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd(EEE)');
    Future<Null> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: _date,
          firstDate: new DateTime(2016),
          lastDate: new DateTime(2020)
      );

      if(picked != null && picked != _date){
        print("Date selected: ${_date.toString()}");
        setState((){
          _date = picked;
        });
      }
    }
    // TODO: implement build
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Text("check page"),
        Row(
          children:[
            Column(
              children:[
                Row(
                    children:[
                      SizedBox(width:50.0),
                      Icon(Icons.calendar_today),
                      Text("대여기간",style:TextStyle(fontSize:17.0)),
                      SizedBox(width:100.0),
                      RaisedButton(
                        child: Text("Select Date"),
                        onPressed:(){
                          _selectDate(context);
                        },
                      )
                    ]
                ),
                Row(
                  children:[
                    SizedBox(width:54.0),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          Text(formatter.format(_date),style:TextStyle(fontSize: 12.0)),
                        ]
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
          RaisedButton(
            child: Text("move to 대여"),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
        ],
      ),
    );
  }
}