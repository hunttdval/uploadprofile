import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_manager/initializefirebase/initloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

///TODO:set phone auth as phnNumber, confirm its working in the place of hardcoded phone number in the db query
///TODO:make sure to verify the shared preference from phone auth is working by saving PhoneNo to phoneKey then return phoneValue and access it at the db query as value
///TODO:confirm password change works just fine from the manager settings page

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

    bool wrongPass = false;
       // Toggles the password show status

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(_auth.currentUser.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {


          Map<String, dynamic> data = snapshot.data.data();
          //return Text("Full Name: ${data['passCode']}");
          return Scaffold(
            body: Form(
              key: _formKey,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.blueGrey, Colors.lightBlueAccent]
                  )
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            decoration: InputDecoration(
                              //hintText: 'Name of Meal:',
                              labelText:'Passcode: ' ,
                              errorText: wrongPass?'Incorrect... Retry':null,
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
                                   //.where('phone', isEqualTo: '+254721305762')
                                   .where('phone', isEqualTo: value)
                                   .get()
                                   .then((QuerySnapshot querySnapshot) {
                                 if("${data['passCode']}" == _controller.text) {
                                   Navigator.pushReplacementNamed(context, '/fifth');
                                   print('Good Job!!');
                                 }
                                 else if("${data['passCode']}" != _controller.text) {
                                   //Navigator.pushReplacementNamed(context, '/fifth');
                                   print('Incorrect password!');
                                   setState(() {
                                     wrongPass = true;
                                   });
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
