import 'dart:async';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:io';


class EditDialogBox extends StatefulWidget {
  final String title, btntext, img, currentDoc;
  //final Image img;
  final String  controller, controller2, controller3, controller4;

  const EditDialogBox({Key key, this.title, this.controller, this.controller2, this.controller3, this.controller4,this.btntext, this.img, this.currentDoc}) : super(key: key);

  @override
  _EditDialogBoxState createState() => _EditDialogBoxState();
}

class _EditDialogBoxState extends State<EditDialogBox> {

  TextEditingController _controller = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;

  bool progress = false;
  bool _validateName = false;
  bool _validatePrice = false;
  bool _validateQuantity = false;

  //String quan, pric;
  int quan, pric;


  ///the image picker///
  File _image;
  final picker = ImagePicker();

  ///select and pick the image///
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }
///Overtime timer///
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
 /* @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }*/

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

      int quanParam = int.parse(widget.controller3);
      int upParam = int.parse(widget.controller4);
      //upUrl = '$downloadUrl';
      await db
          .collection('inst')
          .doc('mustOne')
          .collection('items')
          .doc(widget.currentDoc)
         // .update({ 'price': int.parse(_controller2.text), 'quantity': int.parse(quan), 'url': '$downloadUrl'});
          .set({ 'price': int.parse(_controller2.text), 'quantity':  quanParam+=quan, 'url': '$downloadUrl', 'uploaded':{DateTime.now().toString().substring(0,10):upParam+=quan}},SetOptions(merge:true));
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      setState(() {
        progress = false;
        //Navigator.of(context).pop();
        print("Changes successful");
       // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Updated Successfully')));
        Navigator.of(context).popAndPushNamed('/third');
      });

    } else {
     /* setState(() {
        _start = 11;
        startTimer();
      });*/
      int upParam= int.parse(widget.controller4);
      int quanParam = int.parse(widget.controller3);
      //widget.controller4 != null ? upParam = int.parse(widget.controller4) : upParam = 0;

      //_controller2.text.isEmpty ? pric = int.parse(widget.controller2) : pric = int.parse(_controller2.text);
      //_controller3.text.isEmpty ? quan = int.parse(widget.controller3) : quan =int.parse(_controller3.text);
      print('Running Image==null upload');
      await db
          .collection('inst')
          .doc('mustOne')
          .collection('items')
          .doc(widget.currentDoc)
          //.update({ 'price': int.parse(_controller2.text), 'quantity': int.parse(quan), 'url': widget.img});
    //.update({ 'price': pric, 'quantity': quan, 'url': widget.img});
          .set({ 'price': pric, 'quantity': quanParam+=quan, 'uploaded':{DateTime.now().toString().substring(0,10):upParam+=quan}},SetOptions(merge: true));
      ///Todo: to monitor deducts and uploads value of Quan should be uploaded
      setState(() {
        progress = false;
       // Navigator.of(context).pop();
        print("Changes successful");
        //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Updated Successfully')));
        //Navigator.of(context).popAndPushNamed('/third');
        Navigator.of(context).pop();
      });
    }
  }

  Future valueAdded() async {
    int man = 3;
    int sum = man + int.parse(widget.controller3);
    //int sum = man + 3;
    print(sum);
  }

    @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 2,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }
  contentBox(context){
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX:5 , sigmaY: 5),
            child: Container(
              padding: EdgeInsets.only(left: Constants.padding,top: Constants.avatarRadius
                  + Constants.padding, right: Constants.padding,bottom: Constants.padding
              ),
              margin: EdgeInsets.only(top: Constants.avatarRadius),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  //color: Colors.white.withOpacity(0.6),
                 // color: Colors.white,
                  borderRadius: BorderRadius.circular(Constants.padding),
                 /* boxShadow: [
                    BoxShadow(color: Colors.black,offset: Offset(0,10),
                        blurRadius: 10
                    ),
                  ]*/
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                //
                //you left here?? About to move controllers to this position from data edit
                //
                children: <Widget>[
                  Text(widget.title,style: GoogleFonts.orbitron(textStyle: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),)),
                  SizedBox(height: 15,),
                  //Text(widget.descriptions,style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),
                  Column(
                    children: [
                      /*Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Name of Meal:',
                            labelText:'Name: ' + widget.controller,
                            errorText: _validateName ? 'Please input a valid name' : null,
                          ),
                          controller: _controller,
                          autofocus: false,
                          enableInteractiveSelection: true,
                          textAlign: TextAlign.center,

                        ),
                      ),*/
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: TextFormField(
                          readOnly: true,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Price cannot be edited:',
                            labelText: 'Current Price: ' + widget.controller2,
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
                          keyboardType: TextInputType.phone,

                          // ignore: missing_return
                          validator: (val){
                            int c3 = int.parse(widget.controller3);
                            if(int.parse(val) + c3 < 0){
                              return 'error, Value remaining cant be a negative';
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Amount to Add(5) or Deduct(-5):',
                            labelText: 'Current Quantity: ' + widget.controller3,
                            errorText: _validateQuantity ? 'Please input the quantity available' : null,

                          ),
                          //controller: _controller3,
                          controller: _controller3,
                          autofocus: false,
                          textAlign: TextAlign.center,
                        ),
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

                    ) :
                    TextButton(
                        onPressed: () async{
                          setState(() {
                            //progress = true;
                            //_controller.text.isEmpty ? _validateName = true : _validateName = false;
                           // _controller2.text.isEmpty ? _validatePrice = true : _validatePrice = false;
                           // _controller3.text.isEmpty ? _validateQuantity = true : _validateQuantity = false;

                            _controller2.text.isEmpty ? pric = int.parse(widget.controller2) : pric = int.parse(_controller2.text);
                            _controller3.text.isEmpty ? quan = int.parse(widget.controller3) : quan =int.parse(_controller3.text);

                            if((_validateQuantity || _validatePrice) == false){
                              progress = true;
                              print('Loading Starts');

                            }
                            else return null;
                          });
                          await _updateData(context);
                          //await valueAdded();
                          print('Update Started');
                        },
                        child: Text(widget.btntext,style: GoogleFonts.orbitron(textStyle: TextStyle(fontSize: 18),))),
                  ),
                ],
              ),
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
                    //child: Image.asset("assets/model.jpeg")
                    child: (_image != null)
                        ? Image.file(_image,fit: BoxFit.cover,)
                        : CachedNetworkImage(
                          imageUrl: widget.img,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          //placeholder: (context, url) => CircularProgressIndicator(),
                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                              CircularProgressIndicator(value: downloadProgress.progress),
                          errorWidget: (context, url, error) => Icon(Icons.error_outline),
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
  static const double padding = 20;
  static const double avatarRadius = 45;
}

