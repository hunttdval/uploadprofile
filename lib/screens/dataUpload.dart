//import 'package:firestoreplay/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';


class ProfileCreate extends StatefulWidget {
  @override
  _ProfileCreateState createState() => _ProfileCreateState();
}

class _ProfileCreateState extends State<ProfileCreate> {

  /// Text controllers for the various values
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();

  ///instance of firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  ///Image picker upload and url retrieve
  File _image;
  final picker = ImagePicker();
  String upUrl;


  //select and pick image function
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  //upload image function
  Future uploadPic( BuildContext context) async {
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);

    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    print('This is the Url:$downloadUrl');

    ///upload image url along with other data
    //await firestore.collection('upload').add({'url': '$downloadUrl'});
    await firestore.collection('upload').add({'name': _controller.text, 'price': _controller2.text, 'quantity': _controller3.text, 'url': '$downloadUrl'});


    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    setState(() {
      print("Profile Picture Updated");
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    });

  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
        backgroundColor: Colors.red,
      ),
      body: Builder(
        builder: (context) => Container(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey,
                        child:ClipOval(
                          child: SizedBox(
                            width: 180,
                            height: 180,
                            child:(_image != null) ? Image.file(_image,fit: BoxFit.fill,)
                                :Image.asset(
                              'assets/placeholder.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: IconButton(
                          icon: Icon(Icons.camera_enhance,
                            size: 30,
                          ),
                          onPressed: () {
                            getImage();
                          }
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20,),
                TextField(
                  decoration: InputDecoration(hintText: 'Name of Shoe:'),
                  controller: _controller,
                ),
                SizedBox(height: 20,),
                TextField(
                  decoration: InputDecoration(hintText: 'Price of Shoe:'),
                  controller: _controller2,
                ),
                SizedBox(height: 20,),

                TextField(
                  decoration: InputDecoration(hintText: 'Quantity Available:'),
                  controller: _controller3,
                ),
                SizedBox(height: 20,),
                RaisedButton(
                  color: Colors.amber,
                  child: Text('Submit'),
                  onPressed: () async {
                    //await firestore.collection('upload').add({'name': _controller.text, 'price': _controller2.text, 'quantity': _controller3.text});
                    uploadPic(context);

                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
