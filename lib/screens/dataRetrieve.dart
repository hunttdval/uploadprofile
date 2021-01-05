import 'package:flutter/material.dart';
import 'package:flutter_manager/profile/settings.dart';
import 'package:flutter_manager/screens/dataDelete.dart';
import 'package:flutter_manager/screens/dataEdit.dart';
import 'package:flutter_manager/screens/dataUpload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_manager/services/authservice.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PageViewDemo extends StatefulWidget {
  @override
  _PageViewDemoState createState() => _PageViewDemoState();
}

class _PageViewDemoState extends State<PageViewDemo> {

  PageController _controllerPage = PageController(
    initialPage: 1,
  );

  @override
  void dispose() {
    _controllerPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controllerPage,
      children:[
        UserProfile(),
        ProfileExisting(),
      ],
    );
  }
}

class ProfileExisting extends StatefulWidget {
  @override
  _ProfileExistingState createState() => _ProfileExistingState();
}

class _ProfileExistingState extends State<ProfileExisting> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  ///SigningOut
  Future<void> _signOutDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sign Out'),
            content: Text('About to sign out?'),
            actions: <Widget>[
              ButtonBar(
                children: <Widget>[
                  InkWell(
                    splashColor: Colors.red,
                    child: FlatButton(
                      onPressed: () async {
                        await AuthService().signOut();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                          'Agree',
                        style: TextStyle(
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.blue,
                    child: FlatButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      child: Text('Disagree'),
                      textColor: Colors.white38,
                      splashColor: Colors.blue,
                    ),
                  ),
                ],
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text('Shoe uploads'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.link_off),
            onPressed: () async {
              _signOutDialog();
            },
          ),
        ],
      ),*/
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Shoe uploads'),
              background: Image.asset('assets/Donuts-PNG-File.png',
              fit: BoxFit.cover,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.link_off),
                onPressed: () async {
                  _signOutDialog();
                },
              ),
            ],

          ),
          SliverList(
              delegate: SliverChildListDelegate(
                [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(Icons.add),
                          //color: Colors.red,
                          onPressed: (){
                            Navigator.pushNamed(context, '/second');
                          },
                          iconSize: 40,
                          //child: Icon(Icons.add),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          // color: Colors.red,
                          onPressed: (){
                            Navigator.pushNamed(context, '/third');
                          },
                          iconSize: 28,
                          //child: Icon(Icons.add),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          // color: Colors.red,
                          onPressed: (){
                            Navigator.pushNamed(context, '/fourth');
                          },
                          iconSize: 25,
                          //child: Icon(Icons.add),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(Icons.account_circle),
                          //color: Colors.red,
                          onPressed: (){
                            Navigator.pushNamed(context, '/seventh');
                          },
                          iconSize: 25,
                          //child: Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                ]
              )
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),

                    ),
                    Divider(
                      height: 5,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: firestore.collection('items').snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: snapshot.data.docs.map((doc) {
                                return ListTile(
                                  leading: CircleAvatar(
                                    child:ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: doc.data()["url"],
                                        imageBuilder: (context, imageProvider) => Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                                colorFilter:
                                                ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
                                          ),
                                        ),
                                        //placeholder: (context, url) => CircularProgressIndicator(),
                                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                                            CircularProgressIndicator(value: downloadProgress.progress),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  title: Text('Shoe: ' + doc.data()["name"]),
                                  subtitle: Text('Cost: ' + doc.data()["price"].toString()),
                                  trailing: Text('Remaining: ' + doc.data()['quantity'].toString()),
                                  dense: true,
                                  //selected: true,
                                );
                              }).toList(),
                            );

                          } else {
                            return SizedBox();
                          }
                        }),

                  ],
                ),
              ],
            ),

          ),
        ],

      ),

    );

  }
}
