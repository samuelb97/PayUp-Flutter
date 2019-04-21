import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login/prop-config.dart';
import 'package:login/analtyicsController.dart';
import 'package:login/src/welcome/view.dart';
import 'package:login/userController.dart';
import 'package:login/src/settings/controller.dart';

class SettingsPage extends StatefulWidget {

  SettingsPage({
    Key key,
    this.analControl,
    @required this.user
  }) : super(key: key);

  final userController user;
  final analyticsController analControl;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isLoading;
  File _imageFile;
  String _imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: themeColors.linearGradient,
          child: Padding(padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Material(
            borderRadius: BorderRadius.circular(30),
            color: themeColors.accent,
            elevation: 5,
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
              onPressed: () => getImage(widget.user),
              child: Text('Change Profile Pic', textScaleFactor: 1.25)
            ),
          ),
          SizedBox(height: 15.0),
          Material(
            borderRadius: BorderRadius.circular(30),
            color: themeColors.accent,
            elevation: 5,
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
              onPressed: () {},
              child: Text('Change Password', textScaleFactor: 1.25)
            ),
          ),
          SizedBox(height: 15.0),
          Material(
            borderRadius: BorderRadius.circular(30),
            color: themeColors.accent,
            elevation: 5,
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
               onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomePage(analControl: widget.analControl))),
              child: Text('Logout', textScaleFactor: 1.25)
            ),
          ),
        ],
      ),
          ),
        ),
      ),
    );
  

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