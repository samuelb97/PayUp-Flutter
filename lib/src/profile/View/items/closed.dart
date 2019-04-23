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

Widget buildClosedBet(BuildContext context, int index, var user) {
  if (index >= user.bets.length) {
    return Container();
  } else {
    var betId = user.bets[user.bets.length - index - 1];
    return StreamBuilder(
        stream:
            Firestore.instance.collection('bets').document(betId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data["complete"]) {
            return Container();
          } else {
            var bet = snapshot.data;
            String opponenetID, beatOrLost;
            int userWager, opponentWager;
            Color netColor = themeColors.accent1;
            String plusMinus = "+";
            int netGain = 0;
            if (bet["send_uid"] == user.uid) {
              opponenetID = bet["rec_uid"];
              userWager = bet["send_wager"];
              opponentWager = bet["rec_wager"];
            } else {
              opponenetID = bet["send_uid"];
              userWager = bet["rec_wager"];
              opponentWager = bet["send_wager"];
            }
            if(bet["winner"] == user.uid){
              beatOrLost = "defeated";
              netGain = opponentWager;
            } else {
              netColor = Colors.red[300];
              netGain = userWager;
              plusMinus = "-";
              beatOrLost = "lost to";
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
                      stream: Firestore.instance
                          .collection('users')
                          .document(opponenetID)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        } else {
                          return Row(children: <Widget>[
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(children: <Widget>[
                                    Text(
                                      "  ${user.name}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      " $beatOrLost ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "${snapshot.data["name"]}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.0)),
                                  clipBehavior: Clip.hardEdge,
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1.0,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.green),
                                          ),
                                          width: 50.0,
                                          height: 50.0,
                                          padding: EdgeInsets.all(15.0),
                                        ),
                                    imageUrl: '${snapshot.data["photoUrl"]}',
                                    width: 50.0,
                                    height: 50.0,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          ]);
                        }
                      },
                    ),
                  ),
                  StreamBuilder(
                      stream: Firestore.instance
                          .collection('users')
                          .document(bet["mod_uid"])
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        } else {
                          if (bet["imageUrl"] == "" || bet["imageUrl"] == null) {
                            return Row(children: <Widget>[
                              RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.grey),
                                    children: <TextSpan>[
                                      TextSpan(text: "  Your Wager: "),
                                      TextSpan(
                                          text: "$userWager",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(text: "       Opponent Wager: "),
                                      TextSpan(
                                          text: "$opponentWager",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(text: "\n  Moderator: "),
                                      TextSpan(
                                          text: "${snapshot.data["name"]}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ]),
                              ),
                              Text( 
                                "  $plusMinus$netGain",
                                style: TextStyle(
                                  color: netColor,
                                  fontWeight: FontWeight.bold,
                                )
                              ),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "   ${DateFormat('dd MMM kk:mm').format(DateTime.fromMillisecondsSinceEpoch(bet['timestamp']))}",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10.0,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          .15)),
                            ]);
                          } else {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(children: <Widget>[
                                    RichText(
                                      text: TextSpan(
                                          style: TextStyle(
                                              fontSize: 11, color: Colors.grey),
                                          children: <TextSpan>[
                                            TextSpan(text: "  Your Wager: "),
                                            TextSpan(
                                                text: "$userWager",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text:
                                                    "       Opponent Wager: "),
                                            TextSpan(
                                                text: "$opponentWager",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(text: "\n  Moderator: "),
                                            TextSpan(
                                                text:
                                                    "${snapshot.data["name"]}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ]),
                                    ),
                                    Text( 
                                      "  $plusMinus$netGain",
                                      style: TextStyle(
                                        color: netColor,
                                        fontWeight: FontWeight.bold,
                                      )
                                    )
                                  ]),
                                  Row(children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.only(
                                            right: 50,
                                            top: 8,
                                            bottom: 8,
                                            left: 8),
                                        child: Material(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          clipBehavior: Clip.hardEdge,
                                          child: CachedNetworkImage(
                                            placeholder: (context, url) =>
                                                Container(
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 1.0,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Colors.green),
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
                                        )),
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.only(top: 76),
                                      child: Text(
                                        "   ${DateFormat('dd MMM kk:mm').format(DateTime.fromMillisecondsSinceEpoch(bet['timestamp']))}",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10.0,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            right: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .15)),
                                  ])
                                ]);
                          }
                        }
                      }),
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
        });
  }
}
