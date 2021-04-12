import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Sales.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart';


class Analysis extends StatefulWidget {

  @override
  _AnalysisState createState() {
    return _AnalysisState();
  }
}

class _AnalysisState extends State<Analysis> {
  List<charts.Series<Sales, String>> _seriesBarData;
  List<Sales> mydata;
  _generateData(mydata) {
    //_seriesBarData = List<charts.Series<Sales, String>>();
    _seriesBarData = [];
    _seriesBarData.add(
      charts.Series(
        domainFn: (Sales sales, _) => sales.name.toString(),
        measureFn: (Sales sales, _) => sales.quantity,
        colorFn: (Sales sales, _) =>
            charts.ColorUtil.fromDartColor(Color(int.parse(sales.colorVal))),
        id: 'Sales',
        data: mydata,
        labelAccessorFn: (Sales row, _) => "${row.name}",
      ),
    );
  }
  @override
  void initState(){
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }
  @override
  dispose(){
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // appBar: AppBar(title: Text('Charts')),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('inst').doc('mustOne').collection('items').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<Sales> sales = snapshot.data.docs
              .map((documentSnapshot) => Sales.fromMap(documentSnapshot.data()))
              .toList();
          return _buildChart(context, sales);
        }
      },
    );
  }
  Widget _buildChart(BuildContext context, List<Sales> saledata) {
    mydata = saledata;
    _generateData(mydata);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Quantity Available',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.BarChart(_seriesBarData,
                  animate: true,
                  animationDuration: Duration(seconds:3),
                  behaviors: [
                    new charts.DatumLegend(
                      entryTextStyle: charts.TextStyleSpec(
                          color: charts.MaterialPalette.blue.shadeDefault,
                          fontFamily: 'Georgia',
                          fontSize: 5),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
 }

