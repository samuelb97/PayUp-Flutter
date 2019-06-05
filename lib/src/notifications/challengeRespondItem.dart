import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:login/prop-config.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:login/analtyicsController.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:login/src/profile/Controller/profileController.dart';
import 'package:login/userController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:login/src/betHandler/betHandler.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Widget challengeRespondItem(BuildContext context, betId, user, callback){

  betHandler handler = new betHandler();

  return StreamBuilder(
    stream: Firestore.instance.collection('bets').document(betId).snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData ||  snapshot.data["user_accept"] || snapshot.data["status"] != "pending" 
        || snapshot.data["send_uid"] == user.uid)
        {
        return Container();
      } else {
        var bet = snapshot.data;
        int userWager = bet["rec_wager"];
        String opponentID = bet["send_uid"];
        int opponentWager = bet["send_wager"];
        if(user.uid == bet["send_uid"]){
          opponentID = bet["rec_uid"];
          opponentWager = bet["send_wager"];
          userWager = bet["send_wager"];
        }
        
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                  stream: Firestore.instance.collection('users').document(opponentID).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData){
                      return Container();
                    } else {
                      print("Opp Else\n Name: ${snapshot.data["name"]}\n");
                      return Row(children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                          Row(children: <Widget>[  
                            Text(
                              "  ${snapshot.data["name"]}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              " challenged you",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ]),
                          Padding(padding: EdgeInsets.only(top: 4)),
                          Text( 
                            "  ${bet["description"]}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          )
                        ]),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.only(top: 8, right: 16),
                          child: Material(
                            borderRadius: BorderRadius.all(Radius.circular(25.0)),
                            clipBehavior: Clip.hardEdge,
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Container(
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                ),
                                width: 50.0,
                                height: 50.0,
                                padding: EdgeInsets.all(15.0),
                              ),
                              imageUrl:'${snapshot.data["photoUrl"]}',
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover,
                            ),
                          )
                        ),
                      ]);
                    }
                  },
                ),
              ),
              StreamBuilder(
                stream: Firestore.instance.collection('users').document(bet["mod_uid"]).snapshots(),
                builder: (context,snapshot) {
                  if(!snapshot.hasData){
                    return Container();
                  }
                  else {
                    print("Second STB\n");
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget> [
                      Row(children: <Widget>[
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey
                            ),
                            children: <TextSpan>[
                              TextSpan(text: "  Your Wager: "),
                              TextSpan(text: "$userWager", style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: "       Opponent Wager: "),
                              TextSpan(text: "$opponentWager", style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: "\n  Moderator: "),
                              TextSpan(text: "${snapshot.data["name"]}", style: TextStyle(fontWeight: FontWeight.bold)),
                            ]
                          ),
                        ),
                      ]),
                      Builder(
                        builder: (context) {
                          if(bet["imageUrl"] == "" || bet["imageUrl"] == null) {
                            return Container();
                          } else {
                            return Row(children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 50, top: 8, bottom: 8, left: 8),
                                child: Material(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  clipBehavior: Clip.hardEdge,
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.0,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                      ),
                                      width: 120.0,
                                      height: 80.0,
                                      padding: EdgeInsets.all(15.0),
                                    ),
                                    imageUrl: '${bet["imageUrl"]}',
                                    width: 120.0,
                                    height: 80.0,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              ),
                              Spacer(),
                            ]);
                          }
                        },
                      )
                    ]);
                  }
                }
              ),
              Row(children: <Widget>[
              Container(
                height: 24,
                width: 90,
                padding: EdgeInsets.only(top: 4),
                child: RaisedButton(
                  onPressed: () {
                    handler.updateBetAcceptances(context, user, betId, true);
                    print("\nbet accepted\n\n");
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  color: themeColors.accent1,
                  child: Text("Accept",
                      style: TextStyle(color: themeColors.theme3)),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
              Container(
                height: 24,
                width: 90,
                padding: EdgeInsets.only(top: 4),
                child: RaisedButton(
                  onPressed: () {
                    handler.updateBetAcceptances(context, user, betId, false);
                    List temp = List.from(user.bets);
                    List temp1 = List.from(user.modBets);
                    temp.remove(betId);
                    temp1.remove(betId);
                    user.set_bets = temp;
                    user.set_mod_Bets = temp1;
                    callback();
                    print("\nbet Declined\n\n");
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  color: themeColors.theme3,
                  child: Text("Decline",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.only(top: 24),
                child: Text(
                  "   ${DateFormat('dd MMM kk:mm').format(
                      DateTime.fromMillisecondsSinceEpoch(bet['timestamp'])
                  )}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 10.0,
                      fontStyle: FontStyle.italic),
                ),
              ),
              Padding(padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * .15
              )),
            ]),
              Padding(padding: EdgeInsets.only(bottom: 4)),
              Container(
                width: MediaQuery.of(context).size.width * .85,
                height: 1,
                color: themeColors.accent1,
              )   
            ],
          ),
        );
      }
    }
  );
}