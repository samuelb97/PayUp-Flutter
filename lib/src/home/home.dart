import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:login/prop-config.dart';
import 'package:login/analtyicsController.dart';
import 'package:login/src/itemBuilds/modItems.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:login/src/profile/Controller/profileController.dart';
import 'package:login/userController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/src/profile/View/items/open.dart';
import 'package:login/src/profile/View/items/closed.dart';
import 'package:login/src/profile/View/items/pending.dart';
import 'package:intl/intl.dart';
import 'package:login/src/profile/View/items/profileInfo.dart';

class HomePage extends StatefulWidget {
  HomePage({
    this.analControl, 
    this.user,
  });

  final userController user;
  final analyticsController analControl;

  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: themeColors.linearGradient,
      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * .86),
      child: StreamBuilder( 
          stream: friendsBets(widget.user),
          builder: (context, snapshot) {
            if(!snapshot.hasData) {
              return Container();
            }
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index){
                print(snapshot.data.documents[index]["description"]);
                var doc = snapshot.data.documents[index];
                if(widget.user.friends.contains(doc["send_uid"]) || widget.user.friends.contains(doc["rec_uid"])) {
                  return friendBet(context, doc);
                }
                else {
                  return Container();
                }
              },
            );
          },
        )
    );
  }
}

Stream homeItemsStream(){

}


Stream<QuerySnapshot> friendsBets(userController user) {
  return Firestore.instance
      .collection("bets")
      .where('mod_accept', isEqualTo: true)
      .where('user_accept', isEqualTo: true)
      .snapshots();
}

Widget friendBet(context, doc){
  return StreamBuilder( 
    stream: Firestore.instance.collection('users').document(doc["send_uid"]).snapshots(),
    builder: (context, snapshot) {
      if(!snapshot.hasData) {
        return Container();
      }
      // else if(snapshot.connectionState != ConnectionState.done){
      //   return Container( 
      //     height: 60,
      //     child: CircularProgressIndicator( 
      //       strokeWidth: 1.0,
      //       valueColor: AlwaysStoppedAnimation<Color>(themeColors.accent1),
      //     ),
      //   );
      // }
      else {
        return StreamBuilder( 
          stream: Firestore.instance.collection('users').document(doc["rec_uid"]).snapshots(),
          builder: (context, snapshot2) {
            if(!snapshot2.hasData) {
              return Container();
            }
            // else if(snapshot2.connectionState != ConnectionState.done){
            //   return Container( 
            //     height: 60,
            //     child: CircularProgressIndicator( 
            //       strokeWidth: 1.0,
            //       valueColor: AlwaysStoppedAnimation<Color>(themeColors.accent1),
            //     ),
            //   );
            // }
            else {
              return buildModViewTopRow(context, doc["description"], snapshot.data["name"], snapshot2.data["name"], snapshot.data["photoUrl"], snapshot2.data["photoUrl"]);
            }
          }
        );
      }
    },
  );
}