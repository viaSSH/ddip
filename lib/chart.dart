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

class ChartPage extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  ChartPage(this.seriesList, {this.animate});

  /// Creates a [PieChart] with sample data and no transition.
  factory ChartPage.withSampleData() {
    return new ChartPage(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Color.fromARGB(255, 25, 14, 78),
            title: Text("판매통계"),
        ),
        body: charts.PieChart(seriesList,
        animate: animate,
        // Configure the width of the pie slices to 60px. The remaining space in
        // the chart will be left as a hole in the center.
        defaultRenderer: new charts.ArcRendererConfig(arcWidth: 60))
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      new LinearSales(0, 100),
      new LinearSales(1, 75),
      new LinearSales(2, 25),
      new LinearSales(3, 5),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}