
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetails extends StatesRebuilder {
  static final FacebookLogin facebookSignIn = new FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  FirebaseUser user;
  String displayname;
  String photourl;
  String uid;
  String serverid;

  UserDetails(FirebaseUser user) {
    if (user != null) {
      this.user = user;
      this.displayname = user.displayName;
      this.photourl = user.photoUrl;
      this.uid = user.uid;
    } else {
      this.displayname = 'Explorer';
    }
  }
  String Username() {
    return displayname;
  }

  Future<void> handleSignOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userid', null);
    prefs.setString('authtoken', null);
    userid = null;
    await _auth.signOut().then((_) {
      _googleSignIn.signOut();
      facebookSignIn.logOut();
      RestartWidget.restartApp(context);
//      Navigator.of(context).pushReplacement(
//          new MaterialPageRoute(builder: (context) => FirstTimeCheck()
//          )
//      );
    });
  }

//  void AddUserDetails(FirebaseUser user){
//    this.user=user;
//    this.displayname=user.displayName;
//    this.photourl=user.photoUrl;
//    this.uid=user.uid;
//
//  }

}
