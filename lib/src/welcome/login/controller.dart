import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/src/navbar.dart';
import 'package:login/prop-config.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:login/analtyicsController.dart';
import 'package:login/userController.dart';

class Controller extends ControllerMVC {
  factory Controller() {
    if (_this == null) _this = Controller._();
    return _this;
  }
  static Controller _this;

  Controller._();

  static Controller get con => _this;

  GlobalKey<FormState> get formkey => _formkey;

  static final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  static String email, password;

  set set_email(String _email) {
    email = _email;
  }

  set set_password(String _password) {
    password = _password;
  }

  static Future<void> signIn(
      BuildContext context, analyticsController analControl) async {
    final formState = _formkey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        FirebaseUser user =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (user.isEmailVerified) {
          analControl.sendAnalytics('login_successful');
          userController _user = userController();
          print('\n\nUserID: ${user.uid}\n\n');
          _user.set_uid = user.uid;
          _user.load_data_from_firebase();
          _user.updateLocation();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Home(user: _user, analControl: analControl)));
        } else {
          _ShowEmailNotVerifiedAlert(context, user);
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }

  static void _ShowEmailNotVerifiedAlert(
      BuildContext context, FirebaseUser user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Prompts.email_verif),
          content:
              Text(Prompts.email_err_1 + Prompts.email_err_2 + '${user.email}'),
          actions: <Widget>[
            FlatButton(
              child: Text(Headers.resend),
              onPressed: () {
                user.sendEmailVerification();
              },
            ),
            FlatButton(
              child: Text(Headers.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
