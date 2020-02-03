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

  List _challenge_list;


//define in details

  







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


  static String _sender_outcome_id;
  static int _number_invited;
  static String _wager_type;
  static int _standard_wager;
  static int _min_wager;
  static int _max_wager;

  static List outcome_description_list;

  List get outcomeList => outcome_description_list;

  set set_outcomes(List _outcome_description_list){
    outcome_description_list = _outcome_description_list;
  }
  // static String _outcome_2_description;
  // static String _outcome_3_description;
  // static String _outcome_4_description;
  // static String _outcome_5_description;


  // set set_outcome_1_desc(String outcome1){
  //   _outcome_1_description = outcome1;
  // }
  // set set_outcome_2_desc(String outcome2){
  //   _outcome_2_description = outcome2;
  // }
  // set set_outcome_3_desc(String outcome3){
  //   _outcome_3_description = outcome3;
  // }
  // set set_outcome_4_desc(String outcome4){
  //   _outcome_4_description = outcome4;
  // }
  // set set_outcome_5_desc(String outcome5){
  //   _outcome_5_description = outcome5;
  // }
      

  set set_sender_outcome_id(String sender_outcome_id){
    _sender_outcome_id = sender_outcome_id;
  }
  set set_num_invited(number_invited){
    _number_invited = number_invited;
  }
  set set_wager_type(String wager_type){
    _wager_type = wager_type;
  }
  set set_standard_wager(standard_wager){
    _standard_wager = standard_wager;
  }
  set set_min_wager(min_wager){
    _min_wager = min_wager;
  }
  set set_max_wager(max_wager){
    _max_wager = max_wager;
  }



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

  set set_challenge_list(List _challengelist){
    _challenge_list = _challengelist;
  }

  Future <String> getImage(userController user) async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (_imageFile != null) {
      setState(() {
        _isLoading = true; 
      });
      return await uploadFile(user);
    }
  }

  Future <String>uploadFile(userController user) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(_imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    await storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
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
          "status": "pending",
          "mod_accept": false,
          "user_accept":false,
          "winner":"",
          "loser":"",
          "description":_description,
          "send_vote":"",
          "rec_vote":"",
          "mod_vote":""
        });
        print(docRef.documentID);
        //To do -> add bet to arrays in userController
        return docRef.documentID;
        //nav to select mod_uid?
     
  }

  Future<String> createGroupBet(BuildContext context, userController user) async {
    
        var docRef = await Firestore.instance.collection("bets").add({
          "pool_bet": true,
          "timestamp":_timestamp,
          "imageUrl":_imageUrl,
          "standard_wager": _standard_wager,
          "status": "pending",
          "minimum_wager": _min_wager,
          "maximum_wager": _max_wager,
          "number_accepted": 0,
          "number_invited": _challenge_list.length,
          "number_declined": 0,
          "wager_type": _wager_type,
          "winners":[],
          "losers":[],
          "description":_description,
          "winning_outcome_id": "",
          "challenge_list": _challenge_list
        });


        print(docRef.documentID);
        //To do -> add bet to arrays in userController
        return docRef.documentID;
        //nav to select mod_uid?
     
  }
  Future<String> createOutcome(BuildContext context, String betID, String description) async {
    var docRef2 = await Firestore.instance.collection("bets").document(betID).collection("outcomes").add({
          "description": description,
          "votes": 0
        });
    return docRef2.documentID;
  }
  Future<String> createBettor(BuildContext context, String betID, String outcomeID, String uid, int wager_amount) async {
    var docRef2 = await Firestore.instance.collection("bets").document(betID).collection("bettors").add({
          "outcome_id": outcomeID,
          "uid": uid,
          "vote_id": "",
          "vote_weight": "",
          "wager": wager_amount
        });
    return docRef2.documentID;
  }
  
}