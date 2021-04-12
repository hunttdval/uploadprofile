
import 'package:flutter/material.dart';
import 'package:flutter_manager/login/phoneauth.dart';
import 'package:flutter_manager/services/authservice.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashApp extends StatefulWidget {
  @override
  _SplashAppState createState() => new _SplashAppState();
}

class _SplashAppState extends State<SplashApp> {
Future<Widget> loadFromFuture() async {
  // <fetch data from server. ex. login>

  //return Future.value(LoginPage());
  return AuthService().handleAuth();
}

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      //seconds: 5,
      //navigateAfterSeconds: LoginPage(),
      navigateAfterFuture: loadFromFuture(),
      title: Text(
        'Eatz  🍗',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0, color: Colors.white),
      ),
      gradientBackground: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.blueGrey, Colors.lightBlueAccent]
      ),
      loaderColor: Colors.white,
      loadingText: Text('Loading'),
    );
  }
}
