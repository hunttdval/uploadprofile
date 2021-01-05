import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_manager/services/authservice.dart';
import 'package:fluttertoast/fluttertoast.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = new GlobalKey<FormState>();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _otpFocusNode = FocusNode();

  String phoneNo, verificationId, smsCode;

  bool codeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blueGrey, Colors.lightBlueAccent]),
        ),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: Row(
                    children: [
                      RotatedBox(
                          quarterTurns: -1,
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                            ),
                          )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, left: 10.0),
                        child: Container(
                          //color: Colors.green,
                          height: 200,
                          width: 200,
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 60,
                              ),
                              Center(
                                child: Text(
                                  'Welcome to e-feed Your meals the smart way 🍗',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white38,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                codeSent ? Container() : Padding(
                    padding: EdgeInsets.only(left: 25.0, right: 25.0),
                    child: TextFormField(
                      focusNode: _phoneFocusNode,
                      //autofocus: true,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.lightBlueAccent,
                          hintText: 'Enter your phone number',
                          labelText: '+2547 xxxx xxxx',
                        labelStyle: TextStyle(
                          color: Colors.white70,
                        ),
                          suffixIcon: Icon(Icons.phone),
                      ),
                      validator: (val) {
                        if (val.isEmpty){
                          return 'Please Enter your phone number';
                        }
                        /*Pattern pattern =
                        //r'^(?:254|\+254)?(7(?:(?:[12][0-9])|(?:0[0-8])|(9[0-2]))[0-9]{6})$';
                        r'^(?:254|\+254|0)?(7(?:(?:[129][0–9])|(?:0[0–8])|(4[0–1]))[0–9]{6})$';
                        RegExp regex = new RegExp(pattern);
                        if (!regex.hasMatch(val)){
                          return 'Invalid phone number';
                        }*/
                        if (val.length != 13){
                          return 'Enter valid phone number';
                        }
                        setState(() {
                          this.phoneNo = val;
                        });
                        return null;
                      },
                    )
                ),
                codeSent ? Padding(
                    padding: EdgeInsets.only(left: 25.0, right: 25.0),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                         focusNode: _otpFocusNode,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: Colors.lightBlueAccent,
                              hintText: 'Enter OTP Code',
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              this.smsCode = val;
                            });
                          },
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Text(
                              //'OTP Code is being sent to $phoneNo ...',
                              'OTP not sent?',
                              overflow: TextOverflow.ellipsis,
                            ),
                            FlatButton(
                              onPressed: () {
                                setState(() {
                                  codeSent = false;
                                });
                              },
                              child: Text(
                                'Resend Code',
                                style: TextStyle(color: Colors.white),
                              ),
                              textColor: Colors.blue,
                            ),
                          ],
                        )
                      ],
                    ),

                ) : Container(),
                Padding(
                    padding: EdgeInsets.only(top: 20, right: 50, left: 200),
                    child: Container(
                      alignment: Alignment.bottomRight,
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue[300],
                            blurRadius: 10.0, // has the effect of softening the shadow
                            spreadRadius: 1.0, // has the effect of extending the shadow
                            offset: Offset(
                              5.0, // horizontal, move right 10
                              5.0, // vertical, move down 10
                            ),
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: FlatButton(
                          child: //Center(child: codeSent ? Text('Login'):Text('Verify')),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              codeSent ? Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.lightBlueAccent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ) :  Text(
                                'Verify',
                                style: TextStyle(
                                  color: Colors.lightBlueAccent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.lightBlueAccent,
                              ),
                            ],
                          ),
                          onPressed: () {try{
                            if (_formKey.currentState.validate()) {
                              // If the form is valid, display a Snackbar.
                              print('Success');
                            }
                            codeSent ? AuthService().signInWithOTP(smsCode, verificationId):  verifyPhone(phoneNo);
                          }catch(e){
                            print(e);
                          }

                          }),
                    )
                )
              ],
            )
        ),
      ),
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    /*final PhoneVerificationCompleted verified = (PhoneAuthCredential authResult) {
      AuthService().signIn(authResult);
    };*/

   /* final PhoneVerificationFailed verificationfailed =
        (FirebaseAuthException authException) {

      print('${authException.message}');
    };*/

    /*final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };*/

   /* final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };*/

    await FirebaseAuth.instance.verifyPhoneNumber(
      //phone number from the text-field
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        ///Automatic handling of the SMS code on Android devices
        //verificationCompleted: verified,
        verificationCompleted: (PhoneAuthCredential authResult) {
          AuthService().signIn(authResult);
        },

        ///Handle failure events such as invalid phone numbers or whether the SMS quota has been exceeded.
        //verificationFailed: verificationfailed,
        verificationFailed: (FirebaseAuthException authException) {

          print('${authException.message}');
        },

        ///Handle when a code has been sent to the device from Firebase, used to prompt users to enter the code.
        //codeSent: smsSent,
        codeSent: (String verId, [int forceResend]) {
          this.verificationId = verId;
          setState(() {
            this.codeSent = true;
          });
        },

        ///Handle a timeout of when automatic SMS code handling fails
        //codeAutoRetrievalTimeout: autoTimeout);
        codeAutoRetrievalTimeout: (String verId) {
          this.verificationId = verId;
        });
  }
}