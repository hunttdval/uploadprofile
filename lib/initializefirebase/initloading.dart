import 'package:flutter/material.dart';

class LoadingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blueGrey, Colors.lightBlueAccent]
          )
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0),
            child: Row(
              children: [
                  RotatedBox(
                      quarterTurns: -1,
                      child: Text(
                        'Eatz',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 46,
                          fontWeight: FontWeight.w900,
                        ),
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, left: 10.0),
                    child: Container(
                      //color: Colors.green,
                      height: 300,
                      width: 200,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 60,
                          ),
                          Center(
                            //child: Image.asset('assets/clip.png'),
                            child: Text(
                              'Welcome to Eatz Your meals the smart way 🍗',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white38,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
            ),
          ),
        ),
      ),
    );
  }
}
