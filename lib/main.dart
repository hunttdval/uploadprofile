import 'package:flutter/material.dart';
import 'package:flutter_manager/initializefirebase/initfailed.dart';
import 'package:flutter_manager/initializefirebase/initloading.dart';
import 'package:flutter_manager/screens/dataUpload.dart';
import 'package:firebase_core/firebase_core.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      home:  FutureBuilder(
        //initialize flutter fire
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            //check for errors
            if(snapshot.hasError) {
              return SomethingWentWrong();
            }
            //once complete show my application
            if(snapshot.connectionState == ConnectionState.done) {
              return ProfileCreate();
            }
            //otherwise show something as we wait for initialization
            return LoadingApp();
          }

      ),
    );

  }
}