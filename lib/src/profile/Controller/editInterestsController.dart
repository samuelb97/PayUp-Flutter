import 'package:flutter/material.dart';
import 'package:login/prop-config.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/userController.dart';

class Controller extends ControllerMVC {
  factory Controller() {
    if (_this == null) _this = Controller._();
    return _this;
  }
  static Controller _this;
  Controller._();
  static Controller get con => _this;

  List _interests;
  static String _newInterest;
  static TextEditingController _textController = TextEditingController();

  TextEditingController get textController => _textController;
  List get interests => _interests;
  String get newInterest => _newInterest;

  set set_interests(List __interests){
    _interests = __interests;
  }

  void setTextListener() {
    _textController.addListener(onChange);
  }

  void onChange() async {
    _newInterest = _textController.text;
  }
  
  Future<void> addInterest(userController user) async {
    if (_newInterest != null && _newInterest != "") {
      List temp = List.from(_interests);
      temp.add(_newInterest);
      _interests = temp;
      Firestore.instance.collection("users")
        .document("${user.uid}")
        .updateData({"interests": FieldValue.arrayUnion(["$_newInterest"])});
    }
  }

  Future<void> deleteInterest(userController user, String interest) async {
    print("Removing $interest");
    List temp = List.from(_interests);
    temp.remove(interest);
    _interests = temp;
    Firestore.instance.collection("users")
        .document("${user.uid}")
        .updateData({"interests": FieldValue.arrayRemove(["$interest"])});
  }

  String validateInterest(String value) {
    RegExp regExp = new RegExp(Pattern.characters);
    if (value.length == 0) {
      return Requirements.name;
    } else if (!regExp.hasMatch(value)) {
      return Requirements.range;
    }
    return null;
  }
}
