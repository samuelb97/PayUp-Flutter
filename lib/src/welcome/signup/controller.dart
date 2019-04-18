import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/src/welcome/login/view.dart';
import 'package:login/analtyicsController.dart';
import 'package:login/prop-config.dart';

class Controller extends ControllerMVC {
  factory Controller() {
    if (_this == null) _this = Controller._();
    return _this;
  }
  static Controller _this;

  Controller._();

  static String email, password, name, age, gender, occupation, mobile;
  static int _genderBtnValue = 0;

  GlobalKey<FormState> get formkey => _formkey;

  static final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  int get genderBtnValue => _genderBtnValue;

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
  set set_gender(int g_Val) {
    _genderBtnValue = g_Val;
  }
  set set_occupation(String _occupation) {
    occupation = _occupation;
  }
  set set_mobile(String _mobile) {
    mobile = _mobile;
  }

  static Controller get con => _this;

  static Future<void> signUp(BuildContext context,
      analyticsController analControl) async {
    switch (_genderBtnValue) {
      case 0:
        gender = Userinfo.gender0;
        break;
      case 1:
        gender = Userinfo.gender1;
        break;
      case 2:
        gender = Userinfo.gender2;
        break;
      default:
        gender = Userinfo.gender0;
        break;
    }
    final formState = _formkey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        FirebaseUser user =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String uid = user.uid;
        Firestore.instance.collection("users").document("$uid").setData({
          "email": "$email",
          "name": "$name",
          "age": "$age",
          "gender": "$gender",
          "occupation": "$occupation",
          "mobile": "$mobile",
          "username": "$name",
          "photoUrl": null,
          "location": null
        });
        user.sendEmailVerification();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPage(analControl: analControl)));
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