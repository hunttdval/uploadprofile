import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_manager/services/dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';



class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {

  final _formKey = new GlobalKey<FormState>();

  ///Text Controllers for editing
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  //TextEditingController _controller4 = TextEditingController();
  //String upUrl;
  String _currentDocument, durl;

    ///the image picker
  File _image;
  final picker = ImagePicker();

  //select and pick the image
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  FirebaseFirestore db = FirebaseFirestore.instance;
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Details")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(12.0),
          children: <Widget>[

            SizedBox(height: 20.0),
            Text(
                'Click an Item to Edit Value',
              textAlign: TextAlign.center,
            ),
            Divider(
              height: 5,
              //color: Colors.redAccent,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: db.collection('inst').doc('mustOne').collection('items').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.docs.map((doc) {
                        return ListTile(
                          onTap: () async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return EditDialogBox(
                                    title: doc.data()['name'],
                                    btntext: 'Update',
                                    controller: doc.data()['name'],
                                    controller2: doc.data()['price'].toString(),
                                    controller3: doc.data()['quantity'].toString(),
                                    controller4:doc.data()['uploaded'][DateTime.now().toString().substring(0,10)] != null ? doc.data()['uploaded'][DateTime.now().toString().substring(0,10)].toString():'0',
                                    img: (doc.data()['url']),
                                    currentDoc: doc.id,
                                  );
                                }
                            );
                            setState(() {
                             // _currentDocument = doc.data()['name'];
                              //_currentDocument = doc.id;
//                              _controller.text = doc.data()['name'];
//                              _controller2.text = doc.data()['price'].toString();
//                              _controller3.text = doc.data()['quantity'].toString();
                              //durl = doc.data()['url'];
                            });
                          },
                          leading: CircleAvatar(
                            child:ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: doc.data()["url"],
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
//                                        colorFilter:
//                                        ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                                    ),
                                  ),
                                ),
                                //placeholder: (context, url) => CircularProgressIndicator(),
                                progressIndicatorBuilder: (context, url, downloadProgress) =>
                                    CircularProgressIndicator(value: downloadProgress.progress),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                            ),
                          ),
                          title: Text('Meal: ' + doc.data()["name"]),
                          //subtitle: Text('Cost: ' + doc.data()["price"].toString()),
                          subtitle: Text('Remaining: ' + doc.data()["quantity"].toString()),
                          trailing: Icon(Icons.edit),
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
      ),
    );

  }
}
