import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadDialogBox extends StatefulWidget {
  final String title, descriptions, text;
  final Image img;

  const UploadDialogBox({Key key, this.title, this.descriptions, this.text, this.img}) : super(key: key);

  @override
  _UploadDialogBoxState createState() => _UploadDialogBoxState();
}

class _UploadDialogBoxState extends State<UploadDialogBox> {

  final _formKey = new GlobalKey<FormState>();


  /// Text controllers for the various values
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();

  ///instance of firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // get permissions

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
  /// Random Color Value
  ///

  Random rnd = new Random();
  var lst = [
    '0xffa9a3b2', '0xffa9a9a9', '0xffc7b02f', '0xff990099', '0xff009900', '0xff000743', '0xffbc0033', '0xff005e64', '0xff4e4e4e',
    '0xff3e3e3e', '0xffcc033', '0xff7e0008', '0xff00bc89', '0xfffb5261', '0xff007009', '0xff0068d2', '0xff8b4f00', '0xff466700'
  ];

  void main() {
    var element = lst[rnd.nextInt(lst.length)];
    //print(element);
    colorVal = element;
    //print(colorVal);

  }
  String colorVal;

  //end of random colors

  //upload image function
  Future uploadPic( BuildContext context) async {
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);

    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    print('This is the Url:$downloadUrl');

    ///upload image url along with other data
    //await firestore.collection('items').add({'url': '$downloadUrl'});
    await firestore
        .collection('inst')
        .doc('mustOne')
        .collection('items')
        .doc(_controller.text)
        .set({'colorVal': colorVal,'name': _controller.text, 'price': int.parse(_controller2.text), 'quantity': int.parse(_controller3.text), 'url': '$downloadUrl'});


    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    setState(() {
      print("Profile Picture Updated");
      progress = false;
      /*Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(
            'Details Uploaded successfully',
            textAlign: TextAlign.center,
          ),
          ));*/
      Navigator.of(context).pop();
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
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX:5 , sigmaY: 5),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.padding),
        ),
        elevation: 2,
        backgroundColor: Colors.transparent,
        child: contentBox(context),
      ),
    );
  }
  contentBox(context){
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: Constants.padding,top: Constants.avatarRadius
                + Constants.padding, right: Constants.padding,bottom: Constants.padding
            ),
            margin: EdgeInsets.only(top: Constants.avatarRadius),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                //color: Colors.white.withOpacity(0.3),
                //color: Colors.white,
                borderRadius: BorderRadius.circular(Constants.padding),
                boxShadow: [
                 /* BoxShadow(
                      color: Colors.white,
                      offset: Offset(0,10),
                      blurRadius: 10
                  ),*/
                ]
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Add Meal Profile',style: GoogleFonts.orbitron(textStyle: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),)),
                SizedBox(height: 15,),
                Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Name of Meal:',
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
                        hintText: 'Price of Meal:',
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
                  ],
                ),
                SizedBox(height: 22,),
                Align(
                  alignment: Alignment.bottomRight,
                  child: progress ? CircularProgressIndicator(
                    strokeWidth: 2,
                    backgroundColor: Colors.cyanAccent,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  )
                      :  ElevatedButton(
                    //color: Colors.redAccent,
                    child: Text('Submit'),
                    onPressed: () async {
                      if(_image == null){
                       /* Scaffold.of(context).showSnackBar(
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
                            ));*/
                        print('image==null');

                      }
                      setState(() {
                        //progress = true;
                        _controller.text.isEmpty ? _validateName = true : _validateName = false;
                        _controller2.text.isEmpty ? _validatePrice = true : _validatePrice = false;
                        _controller3.text.isEmpty ? _validateQuantity = true : _validateQuantity = false;

                        if((_validateName || _validateQuantity || _validatePrice) == false && _image != null){
                          progress = true;
                          main();
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
                ),
              ],
            ),
          ),
          Positioned(
            left: Constants.padding,
            right: Constants.padding,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: Constants.avatarRadius,
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                      child: (_image != null)
                          ? Image.file(_image,)
                          :Image.asset(
                        'assets/placeholder.png',
                      ),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.camera_enhance,
                      size: 30,
                    ),
                    onPressed: () {
                      getImage();
                    }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Constants{
  Constants._();
  static const double padding =20;
  static const double avatarRadius =45;
}