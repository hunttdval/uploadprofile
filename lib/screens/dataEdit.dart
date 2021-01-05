import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  ///Function to update all changed data
  Future _updateData (BuildContext context) async {

    ///upload image url along with other data
    //await firestore.collection('items').add({'url': '$downloadUrl'});
    ///document reference

    if(_image != null) {
      startTimer();
      print('Timer started');
      print('Running Image upload');
      String fileName = basename(_image.path);
      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);

      var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      print('This is the Url:$downloadUrl');
      //upUrl = '$downloadUrl';
      await db
          .collection('items')
          .doc(_currentDocument)
          .update({'name': _controller.text, 'price': int.parse(_controller2.text), 'quantity': int.parse(_controller3.text), 'url': '$downloadUrl'});
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      setState(() {
        print("Changes successful");
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Updated Successfully')));
      });

    } else {
      setState(() {
        _start = 11;
        startTimer();
      });
      print('Running Image==null upload');
      await db
          .collection('items')
          .doc(_currentDocument)
          .update({'name': _controller.text, 'price': int.parse(_controller2.text), 'quantity': int.parse(_controller3.text), 'url': durl});
    }
  }
  FirebaseFirestore db = FirebaseFirestore.instance;

  ///Text input validation
  bool progress = false;
  bool _validateName = false;
  bool _validatePrice = false;
  bool _validateQuantity = false;

  ///Timeout excess upload time
  Timer _timer;
  int _start = 0;

  void startTimer () {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (timer) {
      if ((_start > 12)) {
        timer.cancel();
        setState(() {
          progress = false;
          _start = 0;
        });
        print('timer Function Cancelled');
      } else {
        _start = _start + 1;
      }
    });
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Details")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(12.0),
          children: <Widget>[
            ///Avatar for upload
            Row(
              children: <Widget>[

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    child:ClipOval(
                      child: SizedBox(
                        width: 180,
                        height: 180,
                        child:(_image != null)
                            ? Image.file(_image,fit: BoxFit.fill,)
                            :Image.network('$durl',fit: BoxFit.fill,),
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Name of Shoe:',
                  labelText:'Name:',
                  errorText: _validateName ? 'Please input a valid name' : null,
                ),
                controller: _controller,
                autofocus: false,
                enableInteractiveSelection: true,
                textAlign: TextAlign.center,

              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Price of Shoe:',
                  labelText: 'Price:',
                  errorText: _validatePrice ? 'Please input the Price' : null,

                ),
                controller: _controller2,
                enableInteractiveSelection: true,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Quantity Available:',
                  labelText: 'Quantity:',
                  errorText: _validateQuantity ? 'Please input the quantity available' : null,

                ),
                controller: _controller3,
                autofocus: false,
                textAlign: TextAlign.center,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: progress? /*CircularProgressIndicator(
                strokeWidth: 2,
                backgroundColor: Colors.cyanAccent,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),

              )*/SpinKitPulse(
                color: Colors.cyanAccent,
              )
                  : RaisedButton(
                child: Text('Update'),
                //color: Colors.red,
                onPressed: () async {
                  setState(() {
                    //progress = true;
                    _controller.text.isEmpty ? _validateName = true : _validateName = false;
                    _controller2.text.isEmpty ? _validatePrice = true : _validatePrice = false;
                    _controller3.text.isEmpty ? _validateQuantity = true : _validateQuantity = false;

                    if((_validateName || _validateQuantity || _validatePrice) == false){
                      progress = true;
                      print('Loading Starts');
                      _updateData(context);
                      print('Updated Started');
                    }
                    else return null;
                  });
                },
              ),
            ),
            SizedBox(height: 20.0),
            Text(
                'Pick an Item to Enter the Quantity',
              textAlign: TextAlign.center,
            ),
            Divider(
              height: 5,
              //color: Colors.redAccent,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: db.collection('items').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.docs.map((doc) {
                        return ListTile(
                          onTap: () async {
                            setState(() {
                              _currentDocument = doc.data()['name'];
                              _controller.text = doc.data()['name'];
                              _controller2.text = doc.data()['price'].toString();
                              _controller3.text = doc.data()['quantity'].toString();
                              durl = doc.data()['url'];
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
                                        colorFilter:
                                        ColorFilter.mode(Colors.red, BlendMode.colorBurn)
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
                          title: Text('Shoe: ' + doc.data()["name"]),
                          subtitle: Text('Cost: ' + doc.data()["price"].toString()),
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