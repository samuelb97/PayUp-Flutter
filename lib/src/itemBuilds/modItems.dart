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

 
Widget buildModViewTopRow(BuildContext context, description, 
  sendName, recName, sendPhoto, recPhoto,
) {
  return Container( 
    padding: EdgeInsets.only(bottom: 8),
    width: MediaQuery.of(context).size.width,
    child: Row(children: <Widget>[
      Container(
        padding: EdgeInsets.only(top: 8, left: 8),
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
            imageUrl:'$sendPhoto',
            width: 50.0,
            height: 50.0,
            fit: BoxFit.cover,
          ),
        )
      ),
      Spacer(),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                children: <TextSpan> [
                  TextSpan(text: "  $sendName"),
                  TextSpan(text: " vs ", style: TextStyle(fontWeight: FontWeight.normal)),
                  TextSpan(text: "$recName  ")
                ]
              ),
            )
          ),
          Padding(padding: EdgeInsets.only(top: 4)),
          Text( 
            "$description",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ]
      ),
      Spacer(),
      Container(
        padding: EdgeInsets.only(top: 8, right: 8),
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
            imageUrl:'$recPhoto',
            width: 50.0,
            height: 50.0,
            fit: BoxFit.cover,
          ),
        )
      ),
    ])
  );
}

Widget buildBetImage(BuildContext context, imageUrl, timestamp, betId, userController user, callback){
  return Builder(builder: (context) {
      if(imageUrl == "" || imageUrl == null) {
        return buildAcceptBtns(context, timestamp, betId, user, callback);
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
          buildAcceptBtns(context, timestamp, betId, user, callback, true),
        ]);
      }
    }
  );
}

Widget buildAcceptBtns(BuildContext context, timestamp, betId, 
  userController user,  callback, [bool vertical = false]) 
{
  betHandler handler = new betHandler();
  String houseKey = "044d53efca68e36c6cdd2560666ce3c320ac09b270fafa599fe85feb1c3db5a44042457fd549fcf89c2f61877f4dd114a24974ff68fe95e8fd335c389d67036cf6/";
  String sendToHouseWith = "https://shrouded-forest-59484.herokuapp.com/doTransactionWith";
  Widget buildAccept(){
    return Container(
      height: 30,
      width: 100,
      padding: EdgeInsets.only(top: 4, left: 8),
      child: RaisedButton(
        onPressed: () async {
          handler.updateBetAcceptances(context, user, betId, true);
          print("\nbet accepted\n\n");
          var betSnap = await Firestore.instance.collection("bets").document(betId).get();
          int rec_wager = betSnap.data['rec_wager'];
          int send_wager = betSnap.data['send_wager'];
          String send_uid = betSnap.data['send_uid'];
          String rec_uid = betSnap.data['rec_uid'];

          var sendSnap = await Firestore.instance.collection("users").document(send_uid).get();
          var recSnap = await Firestore.instance.collection("users").document(rec_uid).get();
          String send_pubKey = sendSnap.data['pubKey'];
          String rec_pubKey = recSnap.data['pubKey'];
          print("INFO:     $send_wager\n$rec_wager\n$send_pubKey\n$rec_pubKey\n");

          Map data = {
            'recipient': houseKey,
            'amount': send_wager
          };

          var body = json.encode(data);

          //await http.post('https://shrouded-forest-59484.herokuapp.com/doTransactionWith$send_pubKey', headers: {"Content-Type": "application/json"}, body: body);

          Map data2 = {
            'recipient': houseKey,
            'amount': rec_wager
          };

          body = json.encode(data2);
          
          //await http.post('https://shrouded-forest-59484.herokuapp.com/doTransactionWith$rec_pubKey', headers: {"Content-Type": "application/json"}, body: body);

        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        color: themeColors.accent1,
        child: Text("Accept",
            style: TextStyle(color: themeColors.theme3)),
      ),
    );
  }

  Widget buildDecline(){
    return Container(
      height: 30,
      width: 100,
      padding: EdgeInsets.only(top: 4, left: 8),
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
          print("\nbet declined\n\n");


        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35),
        ),
        color: themeColors.theme3,
        child: Text("Decline",
            style: TextStyle(color: Colors.white)),
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
          buildAccept(),
          SizedBox(width: 100, height: 10),
          buildDecline(),
          Container(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * .27),
            child: buildTimestamp(0),
          )
        ]
      ),
    );
  }

  return Row(children: <Widget>[
    buildAccept(),
    buildDecline(),
    Spacer(),
    buildTimestamp(24),
    Padding(padding: EdgeInsets.only(
      right: MediaQuery.of(context).size.width * .15
    )),
  ]);

  
}

Widget buildItemDivider(BuildContext context){
  //Padding(padding: EdgeInsets.only(bottom: 4)),
  return Container(
    padding: EdgeInsets.only(top: 4),
    width: MediaQuery.of(context).size.width * .85,
    height: 1,
    color: themeColors.accent1,
  );           
}