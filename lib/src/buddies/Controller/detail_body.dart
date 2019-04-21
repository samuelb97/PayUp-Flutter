import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/userController.dart';
import 'package:login/src/profile/View/items/closed.dart';
import 'package:login/prop-config.dart';

class Friend{
  String uid;
  String name;
  List bets;
}

class FriendDetailBody extends StatelessWidget {
  FriendDetailBody(this.document, this.user, {
    Key key,
  });
  final DocumentSnapshot document;
  userController user;

  int length = 0;

  @override
  Widget build(BuildContext context) {
    Friend friend = Friend();

    print("\n\n dID: ${document.documentID}\n\n");
    if(document.data["betIDs"] != null){
      length = document.data["betIDs"].length;
    }
    else {
      return Center(
        child: Text("${document.data["name"]} has no completed challenges")
      );
    }
    friend.uid = document.documentID.toString();
    friend.bets = document.data["betIDs"];
    friend.name = document.data["name"];
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(height: 1, color: themeColors.accent2),
        ListView.builder(
          shrinkWrap: true,
          itemCount: length,
          itemBuilder: (context, index)
            => buildClosedBet(context, index, friend)
        )
      ]
    );
  }
}