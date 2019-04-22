import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login/prop-config.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:login/userController.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:io';

class betController extends ControllerMVC{
  factory betController(){
    if(_this == null) _this = betController._();
    return _this;
  }

  bool _isLoading;
  File _imageFile;
  String _imageUrl;

  static betController _this;
  betController._();

  static betController get betCon => _this;

  static String _rec_name;

  static String _bet_id;

  static String _send_uid;
  static String _rec_uid;
  static String _mod_uid;

  static bool _user_accept;
  static bool _mod_accept;

  static String _winner;
  static String _loser;
  static String _description;

  static String _bet_image;

  static int _timestamp;
  
  static int _send_wager;
  static int _rec_wager;

  static bool _open;

 
  static List _friends;


  String get b_id => _bet_id;
  String get s_uid => _send_uid;
  String get r_uid => _rec_uid;
  String get m_uid => _mod_uid;

  bool get user_acc => _user_accept;
  bool get mod_acc => _mod_accept;
  String get win => _winner;
  String get loss => _loser;
  String get desc => _description;
  String get bet_im => _imageUrl;
  int get stamp => _timestamp;
  int get send_w => _send_wager;
  int get rec_w => _rec_wager;
  bool get op => _open;

  List get friend => _friends;

  String get rec_name => _rec_name;


  GlobalKey<FormState> get registerformkey => _formkey;
  static final GlobalKey<FormState> _formkey = GlobalKey<FormState>(debugLabel: "SignUpKey");

  set set_send_uid(String send_uid) {
    _send_uid = send_uid;
  }
  set set_rec_uid(String rec_uid) {
    _rec_uid = rec_uid;
    print("rec_uid");
    print(_rec_uid);
  }
  set set_mod_uid(String mod_uid) {
    _mod_uid = mod_uid;
  }
  set set_send_wager(int send_wager) {
    _send_wager = send_wager;
    print("send wager");
    print(_send_wager);
  }
  set set_rec_wager(int rec_wager) {
    _rec_wager = rec_wager;
    print("rec_wager");
    print(_rec_wager);
  }
  set set_timestamp(int timestamp) {
    _timestamp = timestamp;
  }
  set set_bet_image(String bet_image){
    _imageUrl =bet_image;
  }
  set set_bet_id(String bet_id){
    _bet_id = bet_id;
  }
  set set_description(String description){
    _description =description;
  }
  set set_rec_friends(List friends){
    _friends = friends;
    print("Friends setter");
    print(_friends);
  }
  set set_rec_name(String rec_name){
    _rec_name = rec_name;
  }

  Future <String> getImage(userController user) async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (_imageFile != null) {
      setState(() {
        _isLoading = true; 
      });
      return uploadFile(user);
    }
  }

  Future <String>uploadFile(userController user) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(_imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      _imageUrl = downloadUrl;
      setState(() {
        _isLoading = false;
        return _imageUrl;
      });
    }, onError: (err) {
      setState(() {
        _isLoading = false;
        return;
      });
      Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }



  Future<String> createBet(BuildContext context, userController user) async {
    
        var docRef = await Firestore.instance.collection("bets").add({
          "send_uid":_send_uid,
          "rec_uid":_rec_uid,
          "mod_uid":_mod_uid,
          "send_wager":_send_wager,
          "rec_wager":_rec_wager,
          "timestamp":_timestamp,
          "imageUrl":_imageUrl,
          "open": false,
          "complete": false,
          "mod_accept": false,
          "user_accept":false,
          "winner":"",
          "loser":"",
          "description":_description
        });
        print(docRef.documentID);
        //To do -> add bet to arrays in userController
        return docRef.documentID;
        //nav to select mod_uid?
     
  }
  
}