import 'package:flutter/material.dart';
import 'package:login/prop-config.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/userController.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:io';

class Controller extends ControllerMVC {
  factory Controller() {
    if (_this == null) _this = Controller._();
    return _this;
  }
  static Controller _this;

  Controller._();

  static String name, age, gender, occupation, mobile;
  static int _genderBtnValue = 0;

  bool _isLoading;
  File _imageFile;
  String _imageUrl;

  GlobalKey<FormState> get formkey => _formkey;

  int get genderBtnValue => _genderBtnValue;

  static final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  static String email, password;

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

  

  Future<void> update(userController user) async {
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
    final DocumentReference documentReference =
        Firestore.instance.document(Path.user + user.uid);
    if (formState.validate()) {
      formState.save();
      print("name: $name");
      Map<String, String> data = <String, String>{
        "name": name,
        "occupation": occupation,
        "age": age,
        "mobile": mobile,
        "gender": gender,
      };
      documentReference.updateData(data).whenComplete(() {
        print(Prompts.updateDoc);
      }).catchError((e) => print(e));
    }
  }

  String validateName(String value) {
    RegExp regExp = new RegExp(Pattern.characters);
    if (value.length == 0) {
      return Requirements.name;
    } else if (!regExp.hasMatch(value)) {
      return Requirements.range;
    }
    return null;
  }

  String validateAge(String value) {
    RegExp regExp = new RegExp(Pattern.integers);
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

  Future getImage(userController user) async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (_imageFile != null) {
      setState(() {
        _isLoading = true;
      });
      uploadFile(user);
    }
  }

  Future uploadFile(userController user) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(_imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      _imageUrl = downloadUrl;
      setState(() {
        _isLoading = false;
        onUpdatePic(_imageUrl, user);
      });
    }, onError: (err) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }

  void onUpdatePic(String imageUrl, userController user) {
    Firestore.instance
        .collection("users")
        .document("${user.uid}")
        .updateData({"photoUrl": imageUrl});
    Fluttertoast.showToast(msg: 'Profile Picture Updated');
  }
}
