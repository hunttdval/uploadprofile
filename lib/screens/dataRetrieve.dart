import 'package:flutter/material.dart';
import 'package:flutter_manager/screens/dataDelete.dart';
import 'package:flutter_manager/screens/dataEdit.dart';
import 'package:flutter_manager/screens/dataUpload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_manager/screens/dialogUpload.dart';
import 'package:flutter_manager/services/authservice.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

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
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controllerPage,
      children: [
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
  FirebaseAuth _auth = FirebaseAuth.instance;

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
                      //textColor: Colors.white38,
                      splashColor: Colors.blue,
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  Future<void> _resetShelvesDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Warning !',
              style: TextStyle(color: Colors.red),
            ),
            content: Text(
                'You are about to set the QUANTITY of all meals to ZERO \n\n This cannot be reversed once Agreed'),
            actions: <Widget>[
              ButtonBar(
                children: <Widget>[
                  InkWell(
                    splashColor: Colors.red,
                    child: FlatButton(
                      onPressed: () async {
                        // await resetShelves(context);
                        await recordShelves();
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
                      //textColor: Colors.white38,
                      splashColor: Colors.blue,
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  //Future resetShelves( BuildContext context) async {
 /* Future resetShelves() async {
    await firestore
        .collection('inst')
        .doc('mustOne')
        .collection('items')
        .where("quantity", isGreaterThanOrEqualTo: 1)
        .get()
        .then((res) {
      res.docs.forEach((result) {
        firestore
            .collection('inst')
            .doc('mustOne')
            .collection('items')
            .doc(result.id)
            .update({'quantity': 0});
      });
      print('total Is: ${res.size}');
    });
    print('all remaining quantity set to zero');
  }*/

  Future recordShelves() async {
    await FirebaseFirestore.instance
        .collection('inst')
        .doc('mustOne')
        .collection('items')
        //.where("name", isEqualTo: doc.id)
        .get()
        .then((res) {
      res.docs.forEach((result) {
        var remDb = result.data()['remaining'][DateTime.now().toString().substring(0, 10)]!=null? result.data()['remaining'][DateTime.now().toString().substring(0, 10)] :0;
        firestore
            .collection('inst')
            .doc('mustOne')
            .collection('items')
            .doc(result.id)
            .set({
          'remaining': {
            DateTime.now().toString().substring(0, 10):
                result.data()['quantity']+=remDb
          }
        },SetOptions(merge: true)).then((value) => firestore
                .collection('inst')
                .doc('mustOne')
                .collection('items')
                .doc(result.id)
                .update({'quantity': 0}));
      });
    });

    print('shelve records stored');
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      /*appBar: AppBar(
        title: Text('Meal uploads'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.link_off),
            onPressed: () async {
              _signOutDialog();
            },
          ),
        ],
      ),*/
      /*     drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient:  LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.blueGrey, Colors.lightBlueAccent]
            ),
          ),
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

                                     DynamicTheme.of(context).setBrightness(
                                            Theme.of(context).brightness == Brightness.light || (Icons.brightness_3 == null) ? Brightness.dark : Brightness.light,
                                          );

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
                                         primaryColor: Theme.of(context).primaryColor == Colors.indigo ? Colors.red : Colors.indigo,
                                              buttonColor: Theme.of(context).buttonColor == Colors.indigo ? Colors.red : Colors.indigo,
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
                                         primaryColor: Theme.of(context).primaryColor == Colors.indigo ? Colors.red : Colors.indigo,
                                              buttonColor: Theme.of(context).buttonColor == Colors.indigo ? Colors.red : Colors.indigo,
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
                                         primaryColor: Theme.of(context).primaryColor == Colors.indigo ? Colors.red : Colors.indigo,
                                              buttonColor: Theme.of(context).buttonColor == Colors.indigo ? Colors.red : Colors.indigo,
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
                                         primaryColor: Theme.of(context).primaryColor == Colors.indigo ? Colors.red : Colors.indigo,
                                              buttonColor: Theme.of(context).buttonColor == Colors.indigo ? Colors.red : Colors.indigo,
                                        primaryColor: Colors.deepPurple,
                                        buttonColor:  Colors.deepPurple,
                                        brightness: Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light,

                                      ));
                                    }),
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                          children: [
                            IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/sixth');
                                }
                            ),
                            Text('Edit Profile'),
                          ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                  icon: Icon(Icons.link_off),
                                  onPressed: () {
                                    AuthService().signOut();
                                  }
                              ),
                              Text('Sign Out')
                            ],
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
      ),*/
      drawer: Container(
        height: double.infinity,
        width: MediaQuery.of(context).size.width / 1.2,
        child: Drawer(
          child: StreamBuilder<DocumentSnapshot>(
            stream: firestore
                .collection('manager')
                .doc(_auth.currentUser.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                DocumentSnapshot doc = snapshot.data;
                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Card(
                              elevation: 20,
                              color: Colors.greenAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: CachedNetworkImage(
                                      imageUrl: doc.data()["image"],
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0.0, bottom: 8),
                                  child: Text(
                                    '${doc.data()['name']}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                Text(
                                  '${doc.data()['phone']}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Padding(
                                padding: EdgeInsets.all(3),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    /*IconButton(
                                                  icon: Icon(Icons.palette_outlined),
                                                  onPressed: () {
                                              }),*/
                                    IconButton(
                                        icon: Icon(Icons.wb_sunny),
                                        onPressed: () {
                                          setState(() {
                                            EasyDynamicTheme.of(context)
                                                .changeTheme();
                                          });
                                        })
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      /* child: Text('Elegant Paul'),
                            decoration: BoxDecoration(
                            gradient:  LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [Colors.blueGrey, Colors.lightBlueAccent]
                            ),
                          ),*/
                    ),
                    ListTile(
                      title: Text('Name: ${doc.data()['name']}'),
                      leading: Icon(Icons.person),
                      onTap: () {
                        Navigator.pushNamed(context, '/sixth');
                      },
                      trailing: Icon(Icons.edit),
                    ),
                    ListTile(
                      title: Text('Contact: ${doc.data()['phone']}'),
                      leading: Icon(Icons.phone),
                    ),
                    ListTile(
                      title: Text('Close Shelves'),
                      leading: Icon(Icons.remove_shopping_cart_outlined),
                      onTap: () async {
                        //recordShelves();
                        await _resetShelvesDialog();
                      },
                    ),
                    ListTile(
                      title: Text('Switch Cafeteria'),
                      leading: Icon(Icons.swap_horizontal_circle_outlined),
                      onTap: () {
                        /* change to another cafeteria / verify access first*/
                      },
                    ),
                    ListTile(
                      title: Text('Contact US'),
                      leading: Icon(Icons.headset_mic),
                      onTap: () async {
                        Navigator.of(context).pop();
                        await launch('tel:0722494071');
                      },
                    ),
                    //ListTile(title: Text('Edit Profile'),onTap: (){Navigator.pushNamed(context, '/sixth');},leading: Icon(Icons.edit),),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: Card(
                            elevation: 0,
                            child: ListTile(
                              title: Text('SignOut'),
                              onTap: () async {
                                await _signOutDialog();
                              },
                              leading: Icon(Icons.link_off),
                              enableFeedback: true,
                            ))),
                  ],
                );
              } else {
                return Text('none');
              }
            },
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: RichText(
                  text: TextSpan(
                      text: 'Eatz',
                      style: GoogleFonts.orbitron(
                        textStyle:
                            TextStyle(color: Colors.blue, letterSpacing: .5),
                        fontSize: 21,
                        fontWeight: FontWeight.w200,
                      ),
                      children: <TextSpan>[
                    TextSpan(
                        text: ' Manager',
                        style: GoogleFonts.lexendDeca(
                            textStyle: TextStyle(
                                color: Colors.blueAccent, fontSize: 14)))
                  ])),
              //title: Text('Eatz Manager'),
              /* background: Image.asset('assets/Donuts-PNG-File.png',
              fit: BoxFit.cover,
              ),*/
            ),
            actions: <Widget>[
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.show_chart),
                    onPressed: () async {
                      Navigator.pushNamed(context, '/seventh');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.table_chart),
                    onPressed: () async {
                      Navigator.pushNamed(context, '/eighth');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.link_off),
                    onPressed: () async {
                      _signOutDialog();
                    },
                  ),
                ],
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text('Currently Available Meals'),
                    ),
                    Divider(
                      height: 5,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: firestore
                            .collection('inst')
                            .doc('mustOne')
                            .collection('items')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: snapshot.data.docs.map((doc) {
                                return ListTile(
                                  leading: CircleAvatar(
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: doc.data()["url"],
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
//                                                colorFilter:
//                                                ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                                            ),
                                          ),
                                        ),
                                        //placeholder: (context, url) => CircularProgressIndicator(),
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    'Meal: ' + doc.data()["name"],
                                    style: GoogleFonts.ruda(),
                                  ),
                                  subtitle: Text(
                                    'Cost: ' + doc.data()["price"].toString(),
                                    style: GoogleFonts.mitr(),
                                  ),
                                  trailing: (doc.data()['quantity'] <= 50)
                                      ? Text(
                                          'Remaining: ' +
                                              doc.data()['quantity'].toString(),
                                          style: GoogleFonts.sawarabiMincho(
                                              textStyle: TextStyle(
                                                  color: Colors.redAccent)),
                                        )
                                      : Text(
                                          'Remaining: ' +
                                              doc.data()['quantity'].toString(),
                                          style: GoogleFonts.sawarabiMincho(),
                                        ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          //Navigator.pushNamed(context, '/second');
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return UploadDialogBox();
              });
        },
        tooltip: 'Add New Meal',
        icon: Icon(Icons.add),
        label: Text(
          'Add Meal',
          style: GoogleFonts.orbitron(),
        ),
        elevation: 2.0,
        splashColor: Color.alphaBlend(Colors.grey, Colors.red),
      ),
      bottomNavigationBar: BottomAppBar(
        //color: Colors.transparent,
        elevation: 10,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.pushNamed(context, '/third');
                },
                tooltip: 'click to edit items',
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  Navigator.pushNamed(context, '/fourth');
                },
                tooltip: 'click to delete items',
              ),
            ),
          ],
        ),
        shape: CircularNotchedRectangle(),
        //color: Colors.blueGrey,
        //color: Color.fromARGB( 50, 102, 153, 204),
      ),
    );
  }
}
