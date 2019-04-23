import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:login/prop-config.dart';
import 'package:login/userController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:login/src/betHandler/betHandler.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


Widget buildBetVoteImage(BuildContext context, imageUrl, 
  sendName, recName, timestamp, userController user, bet, betId
){

  return Builder(builder: (context) {
      if(imageUrl == "" || imageUrl == null) {
        return buildVoteBtns(context, timestamp, sendName, recName, user, bet, betId);
      } else {
        return Row(children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
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
                imageUrl: '$imageUrl',
                width: 120.0,
                height: 80.0,
                fit: BoxFit.cover,
              ),
            )
          ),
          buildVoteBtns(context, timestamp, sendName, recName, user, bet, betId, true),
        ]);
      }
    }
  );
}

Widget buildVoteBtns(BuildContext context, timestamp, sendName,
  recName, userController user, bet, betId, [bool vertical = false]
){
  betHandler handler = new betHandler();
  
  Widget buildVoteSend(){
    return Container(
      height: 30,
      width: 100,
      padding: EdgeInsets.only(top: 4, left: 8),
      child: RaisedButton(
        onPressed: () async {
          String temp = await handler.updateBetVotes(context, user, betId, bet['send_uid']);

          print("\n\n\nWinner registered:  $temp");

          String winner_pubKey = await handler.checkVotesDone(context, user, betId);
          print("Winner pubKey:  $winner_pubKey");
          if(winner_pubKey != null){
            int total = bet['rec_wager'] + bet['send_wager'];
            Map data ={
              'recipient': winner_pubKey,
              'amount': total
            };

            var body = json.encode(data);

            final response = 
            await http.post('https://gentle-ridge-52752.herokuapp.com/transact-to-winner', headers: {"Content-Type": "application/json"}, body:body);
            
            //user.set_balance = json.decode(response.body)['balance'];
            
          }
        },
        shape: RoundedRectangleBorder(
          side: BorderSide(color: themeColors.accent1),
          borderRadius: BorderRadius.circular(24),
        ),
        color: themeColors.theme3,
        child: Text(sendName.toString().split(" ")[0] + " " + sendName.toString().split(" ")[1][0],
            style: TextStyle(color: Colors.white, fontSize: 11)),
      ),
    );
  }

  Widget buildVoteDecline(){
    return Container(
      height: 30,
      width: 100,
      padding: EdgeInsets.only(top: 4, left: 8),
      child: RaisedButton(
        onPressed: () async {
          String temp = await handler.updateBetVotes(context, user, betId, bet['rec_uid']);

          print("\n\n\nWinner registered:  $temp");

          String winner_pubKey = await handler.checkVotesDone(context, user, betId);
          print("Winner pubKey:  $winner_pubKey");
          if(winner_pubKey != null){
            int total = bet['rec_wager'] + bet['send_wager'];
            Map data ={
              'recipient': winner_pubKey,
              'amount': total
            };

            var body = json.encode(data);

            final response = 
            await http.post('https://gentle-ridge-52752.herokuapp.com/transact-to-winner', headers: {"Content-Type": "application/json"}, body:body);
            
            //user.set_balance = json.decode(response.body)['balance'];
            
          }
        },
        shape: RoundedRectangleBorder(
          side: BorderSide(color: themeColors.accent1),
          borderRadius: BorderRadius.circular(24),
        ),
        color: themeColors.theme3,
        child: Text(recName.toString().split(" ")[0] + " " + recName.toString().split(" ")[1][0],
            style: TextStyle(color: Colors.white, fontSize: 11)),
      ),
    );
  }

  Widget buildTimestamp(double topPadding){
    return Container(
      padding: EdgeInsets.only(top: topPadding),
      child: Text(
        "   ${DateFormat('dd MMM kk:mm').format(
            DateTime.fromMillisecondsSinceEpoch(timestamp)
        )}",
        style: TextStyle(
            color: Colors.black,
            fontSize: 10.0,
            fontStyle: FontStyle.italic),
      ),
    );
  }


  if(vertical){
    return Container(
      padding: EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildVoteSend(),
          SizedBox(width: 100, height: 10),
          buildVoteDecline(),
          Container(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * .27),
            child: buildTimestamp(0),
          )
        ]
      ),
    );
  }

  return Row(children: <Widget>[
    buildVoteSend(),
    buildVoteSend(),
    Spacer(),
    buildTimestamp(24),
    Padding(padding: EdgeInsets.only(
      right: MediaQuery.of(context).size.width * .15
    )),
  ]);

  
}