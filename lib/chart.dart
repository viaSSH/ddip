import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'detail.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;

String defimg = "https://firebasestorage.googleapis.com/v0/b/final-4575e.appspot.com/o/logo.png?alt=media&token=8be50df6-ef03-4c85-90e6-856ea9d6cb5e";
Map<String, double> dataMap = new Map();
Map<String, double> dataMap1 = new Map();
class ChartPage extends StatefulWidget {
  FirebaseUser user;
  DocumentSnapshot document;
  @override
  ChartPage ({Key key, @required this.document, @required this.user});
  _ChartPageState createState() => new _ChartPageState(user:user);
}
  class _ChartPageState extends State<ChartPage> {
    DocumentSnapshot document;
    FirebaseUser user;
    double goodslen;
    double personlen;
    double knowhowlen;
    double spacelen;
    bool getOnce = false;
    _ChartPageState({Key key, @required this.user});
    void totalItem() async {

      var respectsQuery = Firestore.instance
          .collection('Items')
          .where('category', isEqualTo: "물건");
      var querySnapshot = await respectsQuery.getDocuments();
      var totalEquals = querySnapshot.documents.length;
      goodslen = totalEquals+.0;
      print(goodslen);
      var respectsQuery1 = Firestore.instance
          .collection('Items')
          .where('category', isEqualTo: "사람");
      var querySnapshot1 = await respectsQuery1.getDocuments();
      var totalEquals1 = querySnapshot1.documents.length;
      personlen = totalEquals1+.0;
      print(personlen);

      var respectsQuery2 = Firestore.instance
          .collection('Items')
          .where('category', isEqualTo: "노하우");
      var querySnapshot2 = await respectsQuery2.getDocuments();
      var totalEquals2 = querySnapshot2.documents.length;
      knowhowlen = totalEquals2+.0;
      print(knowhowlen);

      var respectsQuery3 = Firestore.instance
          .collection('Items')
          .where('category', isEqualTo: "공간");
      var querySnapshot3 = await respectsQuery3.getDocuments();
      var totalEquals3 = querySnapshot3.documents.length;
      if(totalEquals3 == null){
        spacelen=0;
      }
      spacelen = totalEquals3+0.0;
      print(spacelen);


      dataMap.putIfAbsent("물건", () => goodslen);
      dataMap.putIfAbsent("사람", () => personlen);
      dataMap.putIfAbsent("공간", () => spacelen);
      dataMap.putIfAbsent("노하우", () => knowhowlen);


    }

    @override
    Widget build(BuildContext context) {
      totalItem();
      if(!getOnce)totalItem();


//Simple Usage
//    PieChart(dataMap: dataMap);
//    if(getOnce)
    return Scaffold(
    appBar: AppBar(
    centerTitle: true,
    backgroundColor: Color.fromARGB(255, 25, 14, 78),
    title: Text("판매통계"),
    ),
    body: //Full Configuration

    Column(
      children:<Widget> [
    PieChart(
    dataMap: dataMap, //Required parameter
    legendFontColor: Colors.blueGrey[900],
    legendFontSize: 14.0,
    legendFontWeight: FontWeight.w500,
    animationDuration: Duration(milliseconds: 800),
    chartLegendSpacing: 32.0,
    chartRadius: MediaQuery
        .of(context)
        .size
        .width / 2.7,
    showChartValuesInPercentage: true,
    showChartValues: true,
    chartValuesColor: Colors.blueGrey[900].withOpacity(0.9),
//        colorList: colorList,
    showLegends: true,
    ),
      ]
    )
    );
    }
  }


