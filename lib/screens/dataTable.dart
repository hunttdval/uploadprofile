import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InfoTable extends StatefulWidget {
  @override
  _InfoTableState createState() => _InfoTableState();
}

class _InfoTableState extends State<InfoTable> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  int Value;

  void countDocuments() async {
    QuerySnapshot _myDoc = await db.collection('instReceipts').get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    print(_myDocCount.length.toString());// Count of Documents in Collection
    Value = _myDocCount.length.toInt();
     }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Center(
            child: Row(
              children: [
                Text(
                  '$Value'
                ),
                ElevatedButton(onPressed: () {countDocuments();} , child: Text('press'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}