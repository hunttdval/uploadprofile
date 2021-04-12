
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_manager/main.dart';
import 'package:flutter_manager/screens/dataRetrieve.dart';

class Messages extends StatefulWidget {
  Messages() : super();
  final String title = 'firebase messaging';
  @override
  _MessagesState createState() => _MessagesState();
}

class Message {
  String title;
  String body;
  String message;
  Message(title, body, message) {
    this.title = title;
    this.body = body;
    this.message = message;
  }
}

class _MessagesState extends State<Messages> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<Message> _messages;

  _getToken() {
    _firebaseMessaging.getToken().then((deviceToken) {
      print('device token: $deviceToken');
    });
  }

  _configureFirebaseListeners() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('onMessage: $message');
          _setMessage(message);
        }, onLaunch: (Map<String, dynamic> message) async {
          print('onLaunch: $message');
          _setMessage(message);

      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => Messages()));
    }, onResume: (Map<String, dynamic> message) async {
      print('onResume: $message');
      _setMessage(message);

      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => Messages()));
    });
  }

  _setMessage(Map<String, dynamic> message) {
    final notification = message['notification'];
    final data = message['data'];
    final String title = notification['title'];
    final String body = notification['body'];
    final String mMessage = data['message'];
    setState(() {
      Message m = Message(title, body, mMessage);
      _messages.add(m);
    });
  }

  @override
  void initState() {
    super.initState();
    _messages = List<Message>.empty(growable: true);
    _getToken();
    _configureFirebaseListeners();
  }

  @override
  Widget build(BuildContext context) {
    if (_messages.isEmpty) {
      return Center(
        child: Text(
          'No messages for you today.😁',
          style: TextStyle(
              fontSize: 16.0, color: Colors.white38,
              fontFamily: 'Chococooky'
          ),
        ),
      );
    }
    return Stack(
      children: [
        Center(
          child: Container(
            child: Image.asset('assets/Donuts-PNG-File.png'),
            //color: Colors.white,
          ),
        ),
        Container(
          color: Colors.white.withOpacity(0.5),
          height: MediaQuery.of(context).size.height,
          child: ListView.separated(
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(5.0),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              itemCount: null == _messages ? 0 : _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    final snackBar = SnackBar(
                      duration: Duration(seconds: 10),
                      content: Text(_messages[index].message),
                      action: SnackBarAction(
                        label: 'Okay',
                        onPressed: () {},
                      ),
                    );
                    Scaffold.of(context).showSnackBar(snackBar);
                  },
                  title: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        _messages[index].message,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontFamily: 'Chococooky'),
                      )),
                );
              }),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(50)),
              color: Colors.blueGrey.withOpacity(0.7),
            ),
            width: 100,
            height: 50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileExisting()),
                    );
                  },
                ),
                Text(
                  'Home',
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
