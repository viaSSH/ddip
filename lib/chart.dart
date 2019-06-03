import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;


String defimg = "https://firebasestorage.googleapis.com/v0/b/final-4575e.appspot.com/o/logo.png?alt=media&token=8be50df6-ef03-4c85-90e6-856ea9d6cb5e";
Map<String, double> dataMap = new Map();
Map<String, double> dataMap1 = new Map();
List<charts.Series> seriesList;
bool animate;
double goodslen;
double personlen;
double knowhowlen;
double spacelen;
var totalEquals;
var totalEquals1;
var totalEquals2;
var totalEquals3;
var mytotalEquals;
var mytotalEquals1;
var mytotalEquals2;
var mytotalEquals3;
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
    bool getOnce = false;
    bool getOnce1 = false;
    _ChartPageState({Key key, @required this.user});
    void totalItem() async {

      var respectsQuery = Firestore.instance
          .collection('Items')
          .where('category', isEqualTo: "물건");
      var querySnapshot = await respectsQuery.getDocuments();
          totalEquals = querySnapshot.documents.length;
      goodslen = totalEquals+.0;
      print("물건"+goodslen.toString());
      var respectsQuery1 = Firestore.instance
          .collection('Items')
          .where('category', isEqualTo: "사람");
      var querySnapshot1 = await respectsQuery1.getDocuments();
          totalEquals1 = querySnapshot1.documents.length;
      personlen = totalEquals1+.0;
      print("사람"+personlen.toString());

      var respectsQuery2 = Firestore.instance
          .collection('Items')
          .where('category', isEqualTo: "노하우");
      var querySnapshot2 = await respectsQuery2.getDocuments();
          totalEquals2 = querySnapshot2.documents.length;
      knowhowlen = totalEquals2+.0;
      print("노하우"+knowhowlen.toString());

      var respectsQuery3 = Firestore.instance
          .collection('Items')
          .where('category', isEqualTo: "공간");
      var querySnapshot3 = await respectsQuery3.getDocuments();
           totalEquals3 = querySnapshot3.documents.length;
      if(totalEquals3 == null){
        spacelen=0;
      }
      spacelen = totalEquals3+0.0;
      print("공간"+spacelen.toString());

      spacelen == totalEquals3+0.0 ?
          getOnce= true:
          getOnce= false;

      dataMap.putIfAbsent("노하우", () => knowhowlen);
      dataMap.putIfAbsent("물건", () => goodslen);
      dataMap.putIfAbsent("사람", () => personlen);
      dataMap.putIfAbsent("공간", () => spacelen);
    }
    void totalMyItem() async {

      var myQuery = Firestore.instance
          .collection('Items')
          .where('category', isEqualTo: "물건")
          .where('seller', isEqualTo: user.uid);
      var myquerySnapshot = await myQuery.getDocuments();
      mytotalEquals = myquerySnapshot.documents.length;
      print("내물건"+mytotalEquals.toString());

      var myQuery1 = Firestore.instance
          .collection('Items')
          .where('category', isEqualTo: "사람")
          .where('seller', isEqualTo: user.uid);
      var myquerySnapshot1 = await myQuery1.getDocuments();
      mytotalEquals1 = myquerySnapshot1.documents.length;
      print("내사람"+mytotalEquals1.toString());

      var myQuery2 =Firestore.instance
          .collection('Items')
          .where('category', isEqualTo: "노하우")
          .where('seller', isEqualTo: user.uid);
      var myquerySnapshot2 = await myQuery2.getDocuments();
      mytotalEquals2 = myquerySnapshot2.documents.length;
      print("내노하우"+mytotalEquals2.toString());

      var myQuery3 = Firestore.instance
          .collection('Items')
          .where('category', isEqualTo: "공간")
          .where('seller', isEqualTo: user.uid);
      var myquerySnapshot3 = await myQuery3.getDocuments();
      mytotalEquals3 = myquerySnapshot3.documents.length;
      print("내공간"+ mytotalEquals3.toString());

      getOnce=true;

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
    body:
        ListView(
        children: <Widget>[
        Column(
        children: [
          SizedBox(height:30),
          Text("전체 상품 비율"),
          PieChart(
            dataMap: dataMap,
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
          ),
          SizedBox(height:20),
          Text("내가 올린 상품"),
          Container(
            width:250,
            height:250,
            child: SimpleBarChart(
              _createSampleData(),
              // Disable animations for image tests.
              animate: true,
            ),
          )
        ],
      ),
      ]
    )
    );
    }
    /// Create one series with sample hard coded data.
     List<charts.Series<OrdinalSales, String>> _createSampleData() {
       totalMyItem();
       if(!getOnce)totalMyItem();
      final data = [
        new OrdinalSales('물건', mytotalEquals, Colors.blue[300]),
        new OrdinalSales('사람', mytotalEquals1, Colors. greenAccent),
        new OrdinalSales('공간', mytotalEquals3,Colors. yellow[200]),
        new OrdinalSales('노하우', mytotalEquals2,Colors. red[300]),
      ];

      return [
        new charts.Series<OrdinalSales, String>(
          id: 'Sales',
          colorFn: (OrdinalSales sales, _) => sales.color,
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.sales,
          data: data,
        )
      ];
    }
  }

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;
  final charts.Color color;

  OrdinalSales(this.year, this.sales, Color color)
      : this.color = new charts.Color(
  r: color.red, g: color.green, b: color.blue, a: color.alpha);
}



class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
    );
  }
}