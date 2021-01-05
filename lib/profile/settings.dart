import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_manager/services/authservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';


class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: StreamBuilder<DocumentSnapshot>(
          stream: firestore.collection('manager').doc(_auth.currentUser.uid).snapshots(),
          builder: (context, snapshot) {

              if(snapshot.hasData){
                DocumentSnapshot doc = snapshot.data;
                return ListView(
                   // children: snapshot.data.docs.map((doc){
                     // print(doc.data());
                  children: [
                   Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        child: CircleAvatar(
                          child:ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: doc.data()["image"],
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                    //colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                                  ),
                                ),
                              ),
                              //placeholder: (context, url) => CircularProgressIndicator(),
                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  CircularProgressIndicator(value: downloadProgress.progress),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                          radius: 65,
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text('Name: ${doc.data()['name']}'),
                      SizedBox(height: 20,),
                      Text('Phone: ${doc.data()['phone']}'),
                      Divider(height: 30,),
                      Text('Theme'),
                      Row(
                        children: <Widget>[
                          RaisedButton(
                              child: Icon(Icons.brightness_3),
                              color: Colors.white70,
                              onPressed: () {
                                DynamicTheme.of(context).setBrightness(
                                  Theme.of(context).brightness == Brightness.light  ? Brightness.dark : Brightness.light ,
                                );

                                /* DynamicTheme.of(context).setBrightness(
                                        Theme.of(context).brightness == Brightness.light || (Icons.brightness_3 == null) ? Brightness.dark : Brightness.light,
                                      );*/

                              }),
                        ],
                      ),
                      Divider(height: 10,),
                      Text('Color'),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: RaisedButton(
                                elevation: 14,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22)
                                ),
                                color: Colors.red,
                                onPressed: () {
                                  DynamicTheme.of(context).setThemeData( ThemeData(
                                    /* primaryColor: Theme.of(context).primaryColor == Colors.indigo ? Colors.red : Colors.indigo,
                                          buttonColor: Theme.of(context).buttonColor == Colors.indigo ? Colors.red : Colors.indigo,*/
                                    primaryColor: Colors.red,
                                    buttonColor:  Colors.red,
                                    brightness: Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light,

                                  ));
                                }),
                          ),
                          SizedBox(width: 5,),
                          Expanded(
                            flex: 1,
                            child: RaisedButton(
                                elevation: 14,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22)
                                ),
                                color: Colors.green,
                                onPressed: () {
                                  DynamicTheme.of(context).setThemeData( ThemeData(
                                    /* primaryColor: Theme.of(context).primaryColor == Colors.indigo ? Colors.red : Colors.indigo,
                                          buttonColor: Theme.of(context).buttonColor == Colors.indigo ? Colors.red : Colors.indigo,*/
                                    primaryColor: Colors.green,
                                    buttonColor:  Colors.green,
                                    brightness: Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light,

                                  ));
                                }),
                          ),
                          SizedBox(width: 5,),
                          Expanded(
                            flex: 1,
                            child: RaisedButton(
                                elevation: 14,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22)
                                ),
                                color: Colors.grey,
                                onPressed: () {
                                  DynamicTheme.of(context).setThemeData( ThemeData(
                                    /* primaryColor: Theme.of(context).primaryColor == Colors.indigo ? Colors.red : Colors.indigo,
                                          buttonColor: Theme.of(context).buttonColor == Colors.indigo ? Colors.red : Colors.indigo,*/
                                    primaryColor: Colors.grey,
                                    buttonColor:  Colors.grey,
                                    brightness: Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light,
                                  ));
                                }),
                          ),
                          SizedBox(width: 5,),
                          Expanded(
                            flex: 1,
                            child: RaisedButton(
                                elevation: 14,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22)
                                ),
                                color: Colors.deepPurple,
                                onPressed: () {
                                  DynamicTheme.of(context).setThemeData( ThemeData(
                                    /* primaryColor: Theme.of(context).primaryColor == Colors.indigo ? Colors.red : Colors.indigo,
                                          buttonColor: Theme.of(context).buttonColor == Colors.indigo ? Colors.red : Colors.indigo,*/
                                    primaryColor: Colors.deepPurple,
                                    buttonColor:  Colors.deepPurple,
                                    brightness: Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light,

                                  ));
                                }),
                          ),
                        ],
                      ),
                      Divider(),
                      IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.pushNamed(context, '/sixth');
                          }
                      ),
                      IconButton(
                          icon: Icon(Icons.link_off),
                          onPressed: () {
                            AuthService().signOut();
                          }
                      )
                    ],
                  ),
                )
                  ],
                  // }).toList(),
                );
              }
              else{
                return Text('NOTHING!!!');
              }
            },
        ),
      ),
    );
  }
}
