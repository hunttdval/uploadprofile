import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:async';



class ProfileCreate extends StatefulWidget {
  @override
  _ProfileCreateState createState() => _ProfileCreateState();
}

class _ProfileCreateState extends State<ProfileCreate> {

  final _formKey = new GlobalKey<FormState>();


  /// Text controllers for the various values
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();

  ///instance of firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  ///Image picker upload and url retrieve
  File _image;
  final picker = ImagePicker();

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
    //await firestore.collection('items').add({'url': '$downloadUrl'});
    await firestore.collection('items')
        .doc(_controller.text)
        .set({'name': _controller.text, 'price': int.parse(_controller2.text), 'quantity': int.parse(_controller3.text), 'url': '$downloadUrl'});


    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    setState(() {
      print("Profile Picture Updated");
      progress = false;
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(
          'Details Uploaded successfully',
        textAlign: TextAlign.center,
      ),
      ));
    });

  }

  ///Form Validation

  bool progress = false;
  bool _validateName = false;
  bool _validatePrice = false;
  bool _validateQuantity = false;
  bool _imagePath = false;

  ///Timeout excess upload time
  Timer _timer;
  int _start = 0;

  void startTimer () {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (timer) {
      if ((_start > 15)) {
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
      appBar: AppBar(
        title: Text('Add Shoe'),
       // backgroundColor: Colors.red,
      ),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: <Widget>[
          Form(
            key: _formKey,
            child: Builder(
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
                                  child:(_image != null)
                                      ? Image.file(_image,fit: BoxFit.fill,)
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
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Name of Shoe:',
                          labelText:'Name:',
                          errorText: _validateName ? 'Please input a valid name' : null,
                        ),
                        controller: _controller,
                        autofocus: false,

                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: 'Price of Shoe:',
                            labelText: 'Price:',
                          errorText: _validatePrice ? 'Please input the Price' : null,

                        ),
                        controller: _controller2,
                      ),
                      SizedBox(height: 20,),

                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: 'Quantity Available:',
                            labelText: 'Quantity:',
                          errorText: _validateQuantity ? 'Please input the quantity available' : null,

                        ),
                        controller: _controller3,
                        autofocus: false,
                      ),
                      SizedBox(height: 20,),

                      progress ? CircularProgressIndicator(
                        strokeWidth: 2,
                        backgroundColor: Colors.cyanAccent,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      )
                          :  RaisedButton(
                        //color: Colors.redAccent,
                        child: Text('Submit'),
                        onPressed: () async {
                          if(_image == null){
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text(
                                  'Please add an Image!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent,
                                  ),
                                ),
                                  backgroundColor: Colors.black45,
                                ));
                          }
                          setState(() {
                            //progress = true;
                            _controller.text.isEmpty ? _validateName = true : _validateName = false;
                            _controller2.text.isEmpty ? _validatePrice = true : _validatePrice = false;
                            _controller3.text.isEmpty ? _validateQuantity = true : _validateQuantity = false;

                            if((_validateName || _validateQuantity || _validatePrice) == false && _image != null){
                              progress = true;
                              print('Loading Starts');
                              uploadPic(context);
                              print('Upload Started');
                              startTimer();
                              print('Timer started');
                            }
                            else return null;
                          });
                          // Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  ///Validate the manager inputs
}