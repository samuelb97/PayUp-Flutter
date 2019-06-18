import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:login/src/welcome/signup/view.dart';
import 'package:login/analtyicsController.dart';
import 'package:login/userController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/src/navbar.dart';
import 'package:login/prop-config.dart';
import 'package:async_loader/async_loader.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Controller extends ControllerMVC {
  factory Controller() {
    if (_this == null) _this = Controller._();
    return _this;
  }
  static Controller _this;

  Controller._();

  static Controller get con => _this;

  static final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  GlobalKey<FormState> get formkey => _formkey;

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
          await _user.load_data_from_firebase();
          print("\nPost Load\n");

          await _getAndSaveToken(email, password);

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      //Splash(user: _user, analControl: analControl)
                      Home(user: _user, analControl: analControl)
                  ));
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

  static void NavigateToSignUp(
      BuildContext context, analyticsController thisAnalyticsController) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SignUpPage(analControl: thisAnalyticsController),
            fullscreenDialog: true));
  }

  // static void NavigateToHome(BuildContext context,
  //     analyticsController analControl, userController _user) {}

  static Future sleep1() {
    return new Future.delayed(const Duration(seconds: 1), () => "1");
  }

  static _getAndSaveToken(email, password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await _getTokenFromHttp(email, password);
    await prefs.setString('jwt', token);
    print("\nGOT TOKEN\n");
    print(prefs.getString('jwt'));
  }

  static Future<String> _getTokenFromHttp(email, password) async {
    //Get Backend Python Token
    var response = await http.post(
      "${Backend.url}login", 
      headers: {"Content-Type": "application/json"},
      body: json.encode({'username': '$email', 'password': '$password'}),
    );
    var parsed = json.decode(response.body);
    print(parsed);
    String token = parsed['access_token'];
    return token;
  }
}
