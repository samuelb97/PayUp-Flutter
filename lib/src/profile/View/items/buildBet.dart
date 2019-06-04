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
import 'dart:async';

Widget buildUserBet(BuildContext context, betId, userController user){
  
  

  return StreamBuilder( 
    stream: Firestore.instance.collection('bets').document(betId).snapshots(),
    builder: (context, snapshot) {
      if(!snapshot.hasData){
        return Container();
      }
      else if(snapshot.connectionState == "active"){
        return buildBetLoading();
      }
      else{
        var bet = snapshot.data;
        String opponentId;
        int userWager, opponentWager;

        if(bet["send_uid"] == user.uid){
          opponentId = bet["rec_uid"];
          userWager = bet["send_wager"];
          opponentWager = bet["rec_wager"];
        }
        else{
          opponentId = bet["send_uid"];
          userWager = bet["rec_wager"];
          opponentWager = bet["send_wager"];
        }

        return StreamBuilder( 
          stream: Firestore.instance.collection('users').document(opponentId).snapshots(),
          builder: (context, snapshot) { 

          }
        );
      }
    }
  );

}

Widget buildBetLoading(){
  return Container( 
    height: 100,
    child: CircularProgressIndicator( 
      strokeWidth: 1.0,
      valueColor: AlwaysStoppedAnimation<Color>(themeColors.accent2),
    ),
  );
}

Widget buildBetDetailsRow(context, text, description, firstName, secondName, photoUrl, [pending = ""]){
  return Row(children: <Widget>[
    Container( 
      width: MediaQuery.of(context).size.width * .7,
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText( 
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: themeColors.textWhite,
                fontWeight: FontWeight.bold
              ),
              children: <TextSpan>[
                TextSpan(text: "  $firstName"),
                TextSpan(text: " $text ", style: TextStyle(fontWeight: FontWeight.normal)),
                TextSpan(text: "$secondName"),
                TextSpan(text: " $pending", 
                  style: TextStyle(color: themeColors.textGrey, 
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.normal)
                )
              ]
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 4)),
          Text( 
            "  $description",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          )
        ],
      ),
    ),
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
          imageUrl:'$photoUrl',
          width: 50.0,
          height: 50.0,
          fit: BoxFit.cover,
        ),
      )
    )
  ]);
}

Widget buildPendingBottom(context, modName, userWager, opponentWager, bet, user){
  return Column( 
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
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
              TextSpan(text: "$modName", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: " pending", 
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
      ])
    ],
  );
}
  
  

/*
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
*/