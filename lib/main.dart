import 'package:flutter/material.dart';
import 'package:flutter_manager/initializefirebase/initfailed.dart';
import 'package:flutter_manager/initializefirebase/initloading.dart';
import 'package:flutter_manager/login/accountauth.dart';
import 'package:flutter_manager/login/phoneauth.dart';
import 'package:flutter_manager/profile/settings.dart';
import 'package:flutter_manager/screens/dataDelete.dart';
import 'package:flutter_manager/screens/dataEdit.dart';
import 'package:flutter_manager/screens/dataRetrieve.dart';
import 'package:flutter_manager/screens/dataUpload.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_manager/services/FirebaseMessagingDemo.dart';
import 'package:flutter_manager/services/authservice.dart';
import 'package:flutter_manager/services/loadingapp.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter_manager/services/splashScreen.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => new ThemeData(
        primarySwatch: Colors.grey,
        buttonColor: Colors.grey,
        brightness: brightness,
      ),
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          title: 'Flutter Demo',
          //theme: ThemeData.dark(),
          theme: theme,
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
            '/seventh': (context) => UserProfile(),

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
                  return SplashApp();

                }
                //otherwise show something as we wait for initialization
                return LoadingApp();
              }

          ),
        );
      },
    );

  }
}
