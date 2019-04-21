import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login/prop-config.dart';
import 'package:login/userController.dart';

class betController{
  factory betController(){
    if(_this == null) _this = betController._();
    return _this;
  }

  static betController _this;
  betController._();

  static betController get betCon => _this;

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

  GlobalKey<FormState> get registerformkey => _formkey;
  static final GlobalKey<FormState> _formkey = GlobalKey<FormState>(debugLabel: "SignUpKey");

  set set_send_uid(String send_uid) {
    _send_uid = send_uid;
  }
  set set_rec_uid(String rec_uid) {
    _rec_uid = rec_uid;
  }
  set set_mod_uid(String mod_uid) {
    _mod_uid = mod_uid;
  }
  set set_send_wager(int send_wager) {
    _send_wager = send_wager;
  }
  set set_rec_wager(int rec_wager) {
    _rec_wager = rec_wager;
  }
  set set_timestamp(int timestamp) {
    _timestamp = timestamp;
  }
  set set_bet_image(String bet_image){
    _bet_image =bet_image;
  }
  set set_bet_id(String bet_id){
    _bet_id = bet_id;
  }
  set set_description(String description){
    _description =description;
  }



  Future<String> createBet(BuildContext context, userController user) async {
    final formState = registerformkey.currentState;
    if (formState.validate()) {
      formState.save();
      try{
        var docRef = await Firestore.instance.collection("bets").add({
          "send_uid":_send_uid,
          "rec_uid":_rec_uid,
          "mod_uid":"",
          "send_wager":0,
          "rec_wager":0,
          "timestamp":_timestamp,
          "bet_image":_bet_image,
          "open": false,
          "complete": false,
          "mod_accept": false,
          "user_accept":false,
          "winner":"",
          "loser":"",
          "description":""
        });
        return docRef.documentID;
        //nav to select mod_uid?
      }
      catch(e){
        print(e.message);
      }
      
    }
    return "Error";
  }
  
}