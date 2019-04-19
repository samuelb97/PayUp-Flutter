import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/analtyicsController.dart';
import 'package:login/prop-config.dart';
import 'package:login/src/welcome/view.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Controller extends ControllerMVC {
  factory Controller() {
    if (_this == null) _this = Controller._();
    return _this;
  }
  static Controller _this;

  Controller._();

  static String username, email, password, password2, name, age;

  GlobalKey<FormState> get registerformkey => _registerformkey;

  static final GlobalKey<FormState> _registerformkey = GlobalKey<FormState>(debugLabel: "SignUpKey");

  set set_email(String _email) {
    email = _email;
  }
  set set_password(String _password) {
    password = _password;
  }
  set set_name(String _name) {
    name = _name;
  }
  set set_age(String _age) {
    age = _age;
  }
  set set_username(String _username) {
    username = _username;
  }
   set set_password2(String _password2) {
    password2 = _password2;
  }


  static Controller get con => _this;

  static Future<void> signUp(BuildContext context,
      analyticsController analControl) async {

    final formState = _registerformkey.currentState;
    if (formState.validate()) {
      formState.save();
      if(password != password2){
        Fluttertoast.showToast(msg: 'Passwords do not match');
        return;
      }
      try {
        print("\nUsername: $username\n");
        FirebaseUser user =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String uid = user.uid;
        String searchKey = name[0].toUpperCase();
        Firestore.instance.collection("users").document("$uid").setData({
          "friends": null,
          "betIDs": null,
          "username": "$username",
          "email": "$email",
          "name": "$name",
          "age": "$age",
          "photoUrl": null,
          "wins": 0,
          "loses": 0,
          "searchKey": "$searchKey",
        });
        user.sendEmailVerification();
        Navigator.pop(context);
      } catch (e) {
        print(e.message);
      }
    }
  }

  String validateName(String value) {
    RegExp regExp = RegExp(Pattern.characters);
    if (value.length == 0) {
      return Requirements.name;
    } else if (!regExp.hasMatch(value)) {
      return Requirements.range;
    }
    return null;
  }
  String validateAge(String value) {
    RegExp regExp = RegExp(Pattern.integers);
    if (value.length == 0) {
      return Requirements.age;
    } else if (!regExp.hasMatch(value)) {
      return Requirements.age_valid;
    }
    return null;
  }
  String validateOccupation(String value) {
    RegExp regExp = new RegExp(Pattern.characters);
    if (value.length == 0) {
      return Requirements.occupation;
    } else if (!regExp.hasMatch(value)) {
      return Requirements.occupation_valid;
    }
    return null;
  }
  String validateMobile(String value) {
    RegExp regExp = new RegExp(Pattern.integers);
    if (value.length == 0) {
      return Requirements.mobile;
    } else if (value.length != 10) {
      return Requirements.mobile_valid_1;
    } else if (!regExp.hasMatch(value)) {
      return Requirements.mobile_valid_2;
    }
    return null;
  }
}