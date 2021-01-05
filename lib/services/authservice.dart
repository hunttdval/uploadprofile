import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_manager/screens/dataRetrieve.dart';
import 'package:flutter_manager/login/phoneauth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthService {

  //Handles Auth
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return PageViewDemo();
          } else {
            return LoginPage();
          }
        });
  }

  //Sign out
  signOut() async{
    await FirebaseAuth.instance.signOut();
  }

  //SignIn
  signIn(AuthCredential authCreds) async{
    UserCredential credential = await FirebaseAuth.instance.signInWithCredential(authCreds);

    User user = credential.user;
    await FirebaseFirestore.instance
        .collection('manager')
        .doc(user.uid)
        .set({'uid':user.uid, 'phone':user.phoneNumber, 'name':'Edit Name', 'image':'https://firebasestorage.googleapis.com/v0/b/phone-login-414b0.appspot.com/o/cofee%20holder.jpg?alt=media&token=696cb718-c9c2-46bc-bbd7-441861295e4a'});

  }

  signInWithOTP(smsCode, verId) async {
    AuthCredential authCreds = PhoneAuthProvider.credential(
        verificationId: verId, smsCode: smsCode);
    await signIn(authCreds);
  }
}

