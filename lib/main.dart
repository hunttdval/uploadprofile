import 'package:flutter/material.dart';
import 'package:flutter_manager/initializefirebase/initfailed.dart';
import 'package:flutter_manager/initializefirebase/initloading.dart';
import 'package:flutter_manager/login/accountauth.dart';
import 'package:flutter_manager/login/phoneauth.dart';
import 'package:flutter_manager/login/verifyuser.dart';
import 'package:flutter_manager/profile/theme.dart';
import 'package:flutter_manager/screens/dataDelete.dart';
import 'package:flutter_manager/screens/dataEdit.dart';
import 'package:flutter_manager/screens/dataRetrieve.dart';
import 'package:flutter_manager/screens/dataTable.dart';
import 'package:flutter_manager/screens/dataUpload.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_manager/screens/dialogUpload.dart';
import 'package:flutter_manager/services/FirebaseMessagingDemo.dart';
import 'package:flutter_manager/services/analysis.dart';
import 'package:flutter_manager/services/authservice.dart';
import 'package:flutter_manager/services/dialog.dart';
import 'package:flutter_manager/services/loadingapp.dart';
import 'package:flutter_manager/services/splashScreen.dart';
import 'package:flutter/services.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';



void main() => runApp(EasyDynamicThemeWidget(child: MyApp()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {

        return MaterialApp(
          title: 'Eatz Manager',
          // theme: ThemeData.light(),
          // darkTheme: ThemeData.dark(),
          theme: lightThemeData,
          darkTheme: darkThemeData,
          themeMode: EasyDynamicTheme.of(context).themeMode,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            // When navigating to the "/" route, build the FirstScreen widget.
            //'/': (context) => ProfileExisting(),
            // When navigating to the "/second" route, build the SecondScreen widget.
            '/second': (context) => ProfileCreate(),
            '/third': (context) => ProfileEdit(),
            '/fourth': (context) => ProfileDelete(),
            '/fifth': (context) => ProfileExisting(),
            '/sixth': (context) => UserDetails(),
            '/seventh': (context) => Analysis(),
            '/eighth': (context) => InfoTable(),
          },
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
                  //return AuthService().handleAuth();
                  //return VerifyUser();
                  return SplashApp();
                }
                //otherwise show something as we wait for initialization
                return LoadingApp();
              }
          ),
        );
  }
}
