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

class betHandler extends ControllerMVC{
  factory betHandler(){
    if(_this == null) _this = betHandler._();
    return _this;
  }

  bool _isLoading;
  File _imageFile;
  String _imageUrl;

  static betHandler _this;
  betHandler._();

  static betHandler get betCon => _this;

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

  Future<String> updateBetVotes(BuildContext context, userController user, betID, vote) async {
    var docRef = Firestore.instance.collection("bets").document(betID);
    var docSnap = await Firestore.instance.collection("bets").document(betID).get();

    //ifs for update send_vote, rec_vote, or mod_vote
    if(docSnap.data['send_uid'] == user.uid){
      await docRef.updateData({
        "send_vote": vote,
      });
    }
    else if(docSnap.data['rec_uid'] == user.uid){
      await docRef.updateData({
        "rec_vote": vote,
      });
    }
    else if(docSnap.data['mod_uid'] == user.uid){
      await docRef.updateData({
        "mod_vote": vote,
      });
    } 

    print("\nupdated bet docRef.documentID\n");
    
    //To do -> add bet to arrays in userController
    return docRef.documentID;
    //nav to select mod_uid?
     
  }

//if bet not done, returns false
  Future<String> checkVotesDone(BuildContext context, userController user, betID) async {
    var docRef = Firestore.instance.collection("bets").document(betID);
    var docSnap = await Firestore.instance.collection("bets").document(betID).get();
    
    print("Checking Votes");
    print(docSnap.data["rec_vote"]);

    if((docSnap.data["send_vote"] != "" && docSnap.data["rec_vote"] != "") || (docSnap.data["mod_vote"] != "" && docSnap.data["rec_vote"] != "") || (docSnap.data["send_vote"] != "" && docSnap.data["mod_vote"] != "")){
      print("IN IF\n\n\n");
      
      
      if(docSnap.data["send_vote"] == docSnap.data["rec_vote"] && docSnap.data["send_vote"] == docSnap.data["send_uid"]){
        docRef.updateData({
          "winner": docSnap.data["send_uid"],
          "loser": docSnap.data["rec_uid"],
          "status": "closed"
          // "open": false,
          // "complete": true,
        });
        var winnerDocument = await Firestore.instance.collection("users").document(docSnap.data["send_uid"]).get();
        return winnerDocument.data["pubKey"];
      }
      else if(docSnap.data["send_vote"] == docSnap.data["rec_vote"] && docSnap.data["send_vote"] == docSnap.data["rec_uid"]){
        docRef.updateData({
          "winner": docSnap.data["rec_uid"],
          "loser": docSnap.data["send_uid"],
          "status": "closed",
          // "open": false,
          // "complete": true,
        });
        var winnerDocument = await Firestore.instance.collection("users").document(docSnap.data["rec_uid"]).get();
        return winnerDocument.data["pubKey"];
      }
      else{
        if(docSnap.data["mod_vote"] == docSnap.data["send_uid"]){
          docRef.updateData({
            "winner": docSnap.data["send_uid"],
            "loser": docSnap.data["rec_uid"],
            "status": "closed",
          // "open": false,
          // "complete": true,
          });
          var winnerDocument = await Firestore.instance.collection("users").document(docSnap.data["mod_vote"]).get();
          return winnerDocument.data["pubKey"];
        }
        else if(docSnap.data["mod_vote"] == docSnap.data["rec_uid"]){
          docRef.updateData({
            "winner": docSnap.data["rec_uid"],
            "loser": docSnap.data["send_uid"],
            "status": "closed",
          // "open": false,
          // "complete": true,
          });
          var winnerDocument = await Firestore.instance.collection("users").document(docSnap.data["mod_vote"]).get();
          return winnerDocument.data["pubKey"];
        }
      }
    }
    return null;
  }

  Future<bool> updateBetAcceptances(BuildContext context, userController user, betID, accept) async {
    var docRef = Firestore.instance.collection("bets").document(betID);
    var docSnap = await Firestore.instance.collection("bets").document(betID).get();
    var rec_docRef = Firestore.instance.collection("users").document(docSnap.data['rec_uid']);
    var send_docRef = Firestore.instance.collection("users").document(docSnap.data['send_uid']);
    var mod_docRef = Firestore.instance.collection("users").document(docSnap.data['mod_uid']);

    var rec_docSnap = await Firestore.instance.collection("users").document(docSnap.data['rec_uid']).get();
    var send_docSnap = await Firestore.instance.collection("users").document(docSnap.data['send_uid']).get();
    var mod_docSnap = await Firestore.instance.collection("users").document(docSnap.data['mod_uid']).get();

    //ifs for update send_vote, rec_vote, or mod_vote
    if(docSnap.data['rec_uid'] == user.uid){
      
      if(accept){
        await docRef.updateData({
          "user_accept": true,
        });
        return true;
      }
      else{
        await rec_docRef.updateData({
          "betIDs": FieldValue.arrayRemove(["${docRef.documentID}"]),
        });

        await send_docRef.updateData({
          "betIDs": FieldValue.arrayRemove(["${docRef.documentID}"]),
        });

        await mod_docRef.updateData({
          "modBets": FieldValue.arrayRemove(["${docRef.documentID}"]),
        });


        docRef.delete();
        
        return false;
      }
    }
    else if(docSnap.data['mod_uid'] == user.uid){
      if(accept){
        await docRef.updateData({
          "mod_accept": true,
          "status": "open",
        });
        return true;
      }
      else{
        
        await rec_docRef.updateData({
          "betIDs": FieldValue.arrayRemove(["${docRef.documentID}"]),
        });

        await send_docRef.updateData({
          "betIDs": FieldValue.arrayRemove(["${docRef.documentID}"]),
        });

        await mod_docRef.updateData({
          "modBets": FieldValue.arrayRemove(["${docRef.documentID}"]),
        });


        docRef.delete();
        return false;
      }
    }
    return null;

    


    //print("\nupdated bet docRef.documentID\n");
    //To do -> add bet to arrays in userController

    //nav to select mod_uid?
     
  }
  
}