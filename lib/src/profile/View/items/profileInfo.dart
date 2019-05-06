import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:login/prop-config.dart';
import 'package:login/analtyicsController.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:login/src/profile/Controller/profileController.dart';
import 'package:login/userController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/src/profile/View/items/open.dart';
import 'package:login/src/profile/View/items/closed.dart';
import 'package:login/src/profile/View/items/pending.dart';
import 'package:intl/intl.dart';


Widget buildProfileDelegate(BuildContext context, userController user) {
    return Container(
      color: themeColors.theme3,
      padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
      child: Row(children: <Widget>[
        Material(
          borderRadius: BorderRadius.all(Radius.circular(45.0)),
          clipBehavior: Clip.hardEdge,
          child: CachedNetworkImage(
            placeholder: (context, url) => Container(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  width: 90.0,
                  height: 90.0,
                  padding: EdgeInsets.all(12.0),
                ),
            imageUrl: '${user.photoUrl}',
            width: 90.0,
            height: 90.0,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Text(
            '${user.name}',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            '@${user.username}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey
            ),
            textAlign: TextAlign.center,
          ),
          Container(height: 1, width: 160, color: themeColors.accent1),
          Padding(
            padding: EdgeInsets.all(4.0),
          ),
          Text(
            '${Userinfo.age}: ${user.age}',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 2)),

          FutureBuilder(
            future: win_loss(context, user),
            initialData: " ",
            builder: (BuildContext context, AsyncSnapshot<String> text) {
              return new Container(
                child: new Text(
                  "Record: " + text.data,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.0,
                  ),
              ));
            }),
          // Text(
          //   '${Userinfo.record}: ${win_loss(context, user)}',
          //   style: TextStyle(
          //     fontSize: 13,
          //     color: Colors.white
          //   ),
          // ),
          Padding(padding: EdgeInsets.symmetric(vertical: 2)),
          Text(
            '${Userinfo.balance}: ${user.balance}',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white
            ),
          ),
        ])
      ]));
}

Future<String> win_loss(BuildContext context, userController user) async {
  int wins = 0;
  int losses = 0;
  for(var bets in user.bets){
    var docRef = await Firestore.instance.collection('bets').document(bets).get();
    if(docRef['winner'] == user.uid){
      wins++;
    }
    else if(docRef['loser'] == user.uid){
      losses++;
    }
  }
  return "$wins-$losses";
}