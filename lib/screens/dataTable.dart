import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';


class InfoTable extends StatefulWidget {
  InfoTable({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _InfoTableState createState() => _InfoTableState();
}

class _InfoTableState extends State<InfoTable> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int penOrders, comOrders, allOrders = 0;

//get value of PENDING ORDERS
  Future pendingOrders( BuildContext context) async {
    await firestore
        .collection('newReceipts')
        .where("checkedOut", isEqualTo: false)
        .get()
        .then((res) {
      print('total Is: ${res.size}');
      setState(() {
        penOrders = res.size;
      });
    });
  }

  ///get value of COMPLETE ORDERS
  Future completeOrders( BuildContext context) async {
    await firestore
        .collection('newReceipts')
        .where("checkedOut", isEqualTo: true)
        .get()
        .then((res) {
      print('total Is: ${res.size}');
      setState(() {
        comOrders = res.size;
      });
    });
  }

  ///get value of ALL ORDERS
  Future allOrdersSum( BuildContext context) async {
    setState(() {
      allOrders = comOrders + penOrders;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('InfoGram'),
      ),
      body: Center(
        child: Container(
          height: MediaQuery
              .of(context)
              .size
              .height - 60.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Color(0xff5a348b),
                    gradient: LinearGradient(
                        colors: [Color(0xff8d70fe), Color(0xff2da9ef)],
                        begin: Alignment.centerRight,
                        end: Alignment(-1.0, -1.0)
                    ), //Gradient
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //Text
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          child: Text('Orders Today', style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
                      ),
                      //subText
                      Container(
                        child: Text(
                          '<< the instutions name>>',
                          style: TextStyle(
                            color: Colors.white54,
                            //fontSize: 20.0,
                          ),),
                      ),
                      //Circle Avatar
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                            width: 150.0,
                            height: 130.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: (allOrders > 0)
                                      ?Text(
                                  //  '\u00243.99',
                                     "$allOrders", style: TextStyle(
                                    fontSize: 30.0,
                                    color: Color(0xff8d70fe),
                                    fontWeight: FontWeight.bold,
                                  ),)
                                      :Text(
                                    //  '\u00243.99',
                                    '<Orders>', style: TextStyle(
                                    fontSize: 30.0,
                                    color: Color(0xff8d70fe),
                                    fontWeight: FontWeight.bold,
                                  ),)
                                ),
                                Container(
                                  child: (allOrders > 0)
                                  ?Text('orders/day', style: TextStyle(
                                    fontSize: 15.0,
                                    color: Color(0xff8d70fe),
                                  ),)
                                      :Text('/day', style: TextStyle(
                                    fontSize: 20.0,
                                    color: Color(0xff8d70fe),
                                  ),),
                                ),
                              ],)
                        ),
                      ),

                      //Two Column Table
                      DataTable(
                        columns: <DataColumn>[
                          DataColumn(
                            label: Text(''),
                          ),
                          DataColumn(
                            label: Text(''),
                          ),
                        ],
                        rows: <DataRow>[
                          DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  myRowDataIcon(
                                      FontAwesomeIcons.times, "Pending Orders "),
                                ),
                                DataCell(
                                  Text('$penOrders',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),),
                                ),
                              ]
                          ),
                          DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  myRowDataIcon(
                                      FontAwesomeIcons.check,"Complete Orders"),
                                ),
                                DataCell(
                                  Text('$comOrders', style: TextStyle(
                                    color: Colors.white,
                                  ),),
                                ),
                              ]
                          ),
                          DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  myRowDataIcon(
                                      FontAwesomeIcons.userClock,"Weekly Orders"),
                                ),
                                DataCell(
                                  Text('$allOrders', style: TextStyle(
                                    color: Colors.white,
                                  ),),
                                ),
                              ]
                          ),
                          DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  myRowDataIcon(
                                      FontAwesomeIcons.calendarWeek,
                                      "Monthly Orders"),
                                ),
                                DataCell(
                                  Text('$allOrders', style: TextStyle(
                                    color: Colors.white,
                                  ),),
                                ),
                              ]
                          ),
                          DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  myRowDataIcon(
                                      FontAwesomeIcons.database,
                                      "Annual Orders"),
                                ),
                                DataCell(
                                  Text('$allOrders', style: TextStyle(
                                    color: Colors.white,
                                  ),),
                                ),
                              ]
                          ),

                        ],
                      ),

                      //Button
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: RaisedButton(
                            color: new Color(0xffffffff),
                            child: Text('Refresh',
                              style: TextStyle(
                                color: new Color(0xff6200ee),
                              ),),
                            onPressed: () async {
                              await pendingOrders(context);
                              await completeOrders(context);
                              await allOrdersSum(context);
                              },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  30.0),)
                        ),
                      ),

                    ],),
                ),
              ),
              //Second ListView
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Color(0xff5a348b),
                    gradient: LinearGradient(
                        colors: [ Color(0xffebac38), Color(0xffde4d2a)],
                        begin: Alignment.centerRight,
                        end: Alignment(-1.0, -2.0)
                    ), //Gradient
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //Text
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: Icon(FontAwesomeIcons.dropbox,
                                          color: new Color(0xffffffff),
                                          size: 40.0,),),
                                    ),
                                    Container(
                                      child: Text(
                                        'KSH', style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30.0,
                                      ),),),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: Text(
                                          '<null>/today', style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30.0
                                        ),),),
                                    ),
                                  ],),
                              ),
                            ],

                          ),
                        ),
                      ),

                      //Two Column Table
                      DataTable(
                        columns: <DataColumn>[
                          DataColumn(
                            label: Text('Period', style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),),
                          ),
                          DataColumn(
                            label: Text('Ksh', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16.0,
                            ),),
                          ),
                        ],
                        rows: <DataRow>[
                          DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  Text('<Date>',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),),
                                ),
                                DataCell(
                                  Text('<null>',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),),
                                ),
                              ]
                          ),
                          DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  Text('Weekly',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),),
                                ),
                                DataCell(
                                  Text('<null>',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),),
                                ),
                              ]
                          ),
                          DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  Text(
                                    'Monthly', style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),),
                                ),
                                DataCell(
                                  Text('<null>',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),),
                                ),
                              ]
                          ),
                          DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  Text('Annual',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),),
                                ),
                                DataCell(
                                  Text('<null>',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),),
                                ),
                              ]
                          ),
                        ],
                      ),

                      //Button
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                            color: new Color(0xffffffff),
                            child: Text('Refresh',
                              style: TextStyle(
                                color: new Color(0xffde4d2a),
                              ),),
                            onPressed: () {},
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  30.0),)
                        ),
                      ),

                    ],),

                ),
              ),
              //Third ListView
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Color(0xff5a348b),
                    gradient: LinearGradient(
                        colors: [ Color(0xffcb3a57), Color(0xffcb3a57)],
                        begin: Alignment.centerRight,
                        end: Alignment(-1.0, -1.0)
                    ), //Gradient
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //Text
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: Icon(FontAwesomeIcons.soundcloud,
                                          color: new Color(0xffffffff),
                                          size: 40.0,),),
                                    ),
                                   /* Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: Text(
                                          'Client', style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30.0,
                                        ),),),
                                    ),*/
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: Text(
                                          'Top Purchases', style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30.0
                                        ),),),
                                    ),
                                  ],),
                              ),
                            ],

                          ),
                        ),
                      ),

                      //Two Column Table
                      DataTable(
                        columns: <DataColumn>[
                          DataColumn(
                            label: Text(''),
                          ),
                          DataColumn(
                            label: Text(''),
                          ),
                        ],
                        rows: <DataRow>[
                          DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  Text('<null>',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),),
                                ),
                                DataCell(
                                  Text('<Top Dish>',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),),
                                ),

                              ]
                          ),
                          DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  Text('<null>',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),),
                                ),
                                DataCell(
                                  Text('<Top Dish>',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),),
                                ),

                              ]
                          ),
                          DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  Text('<null>',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),),
                                ),
                                DataCell(
                                  Text('<Top Dish>',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),),
                                ),

                              ]
                          ),
                          DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  Text('<null>',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),),
                                ),
                                DataCell(
                                  Text('<Top Dish>',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),),
                                ),

                              ]
                          ),
                        ],
                      ),

                      //Button
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                            color: new Color(0xffffffff),
                            child: Text('Refresh',
                              style: TextStyle(
                                color: new Color(0xffcb3a57),
                              ),),
                            onPressed: () {},
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  30.0),)
                        ),
                      ),

                    ],),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

ListTile myRowDataIcon(IconData iconVal, String rowVal) {
  return ListTile(
    leading: Icon(iconVal,
        color: new Color(0xffffffff)),
    title: Text(rowVal, style: TextStyle(
      color: Colors.white,
    ),),
  );
}