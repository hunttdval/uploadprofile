import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class UserDetails extends StatefulWidget {
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController _managername = TextEditingController();

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future uploadDetails (BuildContext context) async {

    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);

    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    print('This is the Url:$downloadUrl');
    await firestore.collection('manager')
        .doc(_auth.currentUser.uid)
        .update({'name': _managername.text, 'image': '$downloadUrl'});

    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    setState(() {
      print("Profile Picture Updated");
      Navigator.of(context).popAndPushNamed('/seventh');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('data'),
      ),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.grey,
                      child:ClipOval(
                        child: SizedBox(
                          width: 180,
                          height: 180,
                          child:(_image != null)
                              ? Image.file(_image,fit: BoxFit.fill,)
                              :Image.asset(
                            'assets/placeholder.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: IconButton(
                        icon: Icon(Icons.camera),
                        onPressed: () {
                          getImage();
                        },
                      ),
                    ),
                  ],
                ),
                Divider(height: 10,),
                TextField(
                  controller: _managername,
                  decoration: InputDecoration(
                    hintText: 'Enter official manager name:',
                    labelText: 'e.g Michael Nono',
                    suffixIcon: Icon(Icons.account_circle),
                  ),
                  autofocus: true,
                ),
                RaisedButton(
                  onPressed: () async{
                    uploadDetails(context);
                  },
                  child: Text('Proceed'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
