import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:login/prop-config.dart';
import 'package:login/userController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/src/itemBuilds/modItems.dart';
import 'package:login/src/itemBuilds/modVoteItem.dart';
import 'package:intl/intl.dart';


Widget moderateVoteItem(BuildContext context, betId, userController user){

  return StreamBuilder(
    stream: Firestore.instance.collection('bets').document(betId).snapshots(),
    builder: (context, snapshot1) {
      if (!snapshot1.hasData || !snapshot1.data["open"] || snapshot1.data["complete"] 
         || (snapshot1.data["mod_vote"] != null && snapshot1.data["mod_vote"] != "") 
         || (snapshot1.data["rec_vote"] == "" && snapshot1.data["send_vote"] == "")
         || (snapshot1.data["rec_vote"] == null && snapshot1.data["send_vote"] == null)
         ){
        return Container();
      } else {
        var bet = snapshot1.data;
        String send_uid = bet["send_uid"];
        String rec_uid = bet["rec_uid"];

        print("REC UID: $rec_uid\nSEND UID: $send_uid\n");

        return StreamBuilder(
          stream: Firestore.instance.collection('users').document(snapshot1.data["send_uid"]).snapshots(),
          builder: (context, snapshot2) {
            if(!snapshot2.hasData) {
              print("Send UID query returned null\n");
              return Container();
            } else {
              var sendUser = snapshot2.data;
              String sendUserName = sendUser["name"];
              String sendUserPhotoUrl = sendUser["photoUrl"];

              print("Send User Name: $sendUserName\n");

              return StreamBuilder( 
                stream: Firestore.instance.collection('users').document(rec_uid).snapshots(),
                builder: (context, snapshot3) {
                  if(!snapshot3.hasData){
                    print("Rec UID query returned null\n");
                    return Container();
                  } else {
                    var recUser = snapshot3.data;
                    String recUserName = recUser["name"];
                    String recUserPhotoUrl = recUser["photoUrl"];

                    print("Rec User Name: $recUserName\n");

                    return Container( 
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          buildModViewTopRow(
                            context, bet["description"], 
                            sendUserName, recUserName, 
                            sendUserPhotoUrl, recUserPhotoUrl
                          ),

                          buildBetVoteImage(
                            context, bet["imageUrl"], 
                            sendUserName, recUserName,
                            bet["timestamp"], user, bet, betId,
                          ),
                          
                          buildItemDivider(context), 

                        ]
                      ),
                    );
                  }
                }
              );
            }
          }
        );
      }
    }
  );
}
