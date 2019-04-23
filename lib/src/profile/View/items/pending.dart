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

Widget buildPendingBet(BuildContext context, int index, userController user) {

  betHandler handler;

    if(index >= user.bets.length){
      return Container();
    }
    else{
      var betId = user.bets[index];
      return StreamBuilder(
        stream: Firestore.instance.collection('bets').document(betId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data["open"] || snapshot.data["complete"]){
            return Container();
          } else {
            var bet = snapshot.data;
            String opponenetID, challengedOrAccepted;
            int userWager, opponentWager;
            String modPending = "pending";
            String userPending = "pending";
            if(bet["send_uid"] == user.uid){
              opponenetID = bet["rec_uid"];
              challengedOrAccepted = "challenged";
              userWager = bet["send_wager"];
              opponentWager = bet["rec_wager"];
            }
            else{
              opponenetID = bet["send_uid"];
              challengedOrAccepted = "accepted";
              userWager = bet["rec_wager"];
              opponentWager = bet["send_wager"];
            }
            if(bet["user_accept"]){
              userPending = "";
            }
            return Container(
              //height: 140,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    //height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder(
                      stream: Firestore.instance.collection('users').document(opponenetID).snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData){
                          return Container();
                        } else {
                          String opponentName = "${snapshot.data["name"]}";
                          return Row(children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                              Row(children: <Widget>[
                                Builder(
                                  builder: (context) {
                                    if(!bet["user_accept"] && opponenetID == bet["send_uid"]) {
                                      return Row(children: <Widget>[
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
                                      ]);
                                    } else {
                                      return Row(children: <Widget>[
                                        Text(
                                          "  ${user.name}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          " $challengedOrAccepted ",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          "$opponentName",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "  $userPending",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ]); 
                                    }
                                  },
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
                        if(bet["imageUrl"] == "" || bet["imageUrl"] == null){
                          return Row(children: <Widget>[
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
                                  TextSpan(text: "  $modPending", 
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                    )
                                  ),
                                ]
                              ),
                            ),
                            Spacer(),
                            Builder(builder: (context){
                              if(bet["user_accept"] || user.uid == bet["send_uid"]){
                                return Container(
                                  padding: EdgeInsets.only(top: 10, right: MediaQuery.of(context).size.width * .15),
                                  child: Text(
                                    "   ${DateFormat('dd MMM kk:mm').format(
                                        DateTime.fromMillisecondsSinceEpoch(bet['timestamp'])
                                    )}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10.0,
                                        fontStyle: FontStyle.italic),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            })
                          ]);
                        }
                        else { 
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
                                  TextSpan(text: "  $modPending", 
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                    )
                                  ),
                                ]
                              ),
                            ),
                            ]),
                            Row(children: <Widget>[
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
                            ]),
                          ]);
                        }
                      }
                    }
                  ),
                  Builder(
                    builder: (context) {
                      if(!bet["user_accept"] && opponenetID == bet["send_uid"]) {
                        return Row(children: <Widget>[
                          Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                          Container(
                            height: 24,
                            width: 94,
                            padding: EdgeInsets.only(top: 4),
                            child: RaisedButton(
                              onPressed: () {
                                handler.updateBetAcceptances(context, user, betId, true);
                                print("\nbet accepted\n\n");
                                

                                //TODO: lock button
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              color: themeColors.accent1,
                              child: Text("Accept",
                                  style: TextStyle(color: themeColors.theme3)),
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                          Container(
                            height: 24,
                            width: 94,
                            padding: EdgeInsets.only(top: 4),
                            child: RaisedButton(
                              onPressed: () {
                                handler.updateBetAcceptances(context, user, betId, false);
                                print("\nbet declined\n\n");

                                
                                //TODO: lock button
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35),
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
                        ]);
                      } else {
                        return Container();
                      }
                    },
                  ),
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
  }