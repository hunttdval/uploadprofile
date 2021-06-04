import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_manager/initializefirebase/initloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class VerifyUser extends StatefulWidget {
   @override
  _VerifyUserState createState() => _VerifyUserState();
}

class _VerifyUserState extends State<VerifyUser> {

  getPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String phoneValue = prefs.getString('phoneKey');
    return phoneValue;
  }
  //String value = await getPhone() ?? "";

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('manager');
    final _formKey = new GlobalKey<FormState>();
    TextEditingController _controller = TextEditingController();
    FirebaseAuth _auth = FirebaseAuth.instance;

    Future<void> _verifyDialog() async {
      return showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Incorrect Password'),
              content: Text('Kindly retry😢'),
              actions: <Widget>[
                ButtonBar(
                  children: <Widget>[
                    InkWell(
                      splashColor: Colors.blue,
                      child: FlatButton(
                        onPressed: () async {
                          await launch('sms:0722494071');
                        },
                        child: Text('Reset'),
                        //textColor: Colors.white38,
                        splashColor: Colors.blue,
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.red,
                      child: FlatButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Retry',
                          style: TextStyle(
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          }
      );
    }
    Future<void> _resetPasscode() async {
      return showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Passcode Reset'),
              content: Text('You are about to send an SMS to eatz incoporation requesting for a passcode reset'),
              actions: <Widget>[
                ButtonBar(
                  children: <Widget>[
                    InkWell(
                      splashColor: Colors.blue,
                      child: FlatButton(
                        onPressed: () async {
                          await launch('sms:0722494071');
                        },
                        child: Text('Reset'),
                        //textColor: Colors.white38,
                        splashColor: Colors.blue,
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.red,
                      child: FlatButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Retry',
                          style: TextStyle(
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          }
      );
    }
    Future<void> _nullPasscode() async {
      return showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Passcode cant be Empty'),
              content: Text('Input Passcode✍'),
              actions: <Widget>[
                ButtonBar(
                  children: <Widget>[
                    InkWell(
                      splashColor: Colors.blue,
                      child: FlatButton(
                        onPressed: () async {
                          await launch('sms:0722494071');
                        },
                        child: Text('Reset'),
                        //textColor: Colors.white38,
                        splashColor: Colors.blue,
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.red,
                      child: FlatButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Retry',
                          style: TextStyle(
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          }
      );
    }

       // Toggles the password show status

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(_auth.currentUser.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        else if (snapshot.hasData && !snapshot.data.exists) {
          return Text("Document does not exist");
        }

        else if (snapshot.connectionState == ConnectionState.done) {
          bool wrongPass = false;

          Map<String, dynamic> data = snapshot.data.data();
          //return Text("Full Name: ${data['passCode']}");
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.blueGrey, Colors.lightBlueAccent]
                )
              ),
              child: Form(
                key: _formKey,
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            // ignore: missing_return
                            decoration: InputDecoration(
                              //hintText: 'Name of Meal:',
                              labelText:'Passcode: ' ,
                              errorText: wrongPass ? 'Incorrect... Retry' : null,
                            ),
                            controller: _controller,
                            autofocus: false,
                            enableInteractiveSelection: true,
                            textAlign: TextAlign.center,
                            obscureText: true,

                          ),
                        ),
                        //SizedBox( width: 2,),

                       Expanded(
                         flex: 1,
                         child: IconButton(
                             onPressed: () async{
                               //get shared preference
                               String value = await getPhone() ?? "";
                               await FirebaseFirestore.instance
                                   .collection('manager')
                                   .where('phone', isEqualTo: value)
                                   .get()
                                   .then((QuerySnapshot querySnapshot) {
                                     if(_controller.text.isEmpty){
                                       print('null passcode');
                                       _nullPasscode();
                                     }
                                 else if("${data['passCode']}" == _controller.text) {
                                   Navigator.pushReplacementNamed(context, '/fifth');
                                   print('Good Job!!');
                                 }
                                 else if("${data['passCode']}" != _controller.text) {
                                   //Navigator.pushReplacementNamed(context, '/fifth');
                                   print('Incorrect password!');
                                   _verifyDialog();
                                 }
                                 else print('Error getting passcode');
                               });
                               /*if("${data['passCode']}" == _controller.text) {
                                 Navigator.pushReplacementNamed(context, '/fifth');
                               }
                               else print('Error getting passcode');*/
                             },
                             icon: Icon(Icons.send)

                         ),
                       ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return LoadingApp();
      },
    );
  }
}
