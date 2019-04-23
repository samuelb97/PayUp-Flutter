import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:login/prop-config.dart';
import 'package:login/userController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


Widget buildBetVoteImage(BuildContext context, imageUrl, 
  sendName, recName, timestamp
){
  return Builder(builder: (context) {
      if(imageUrl == "" || imageUrl == null) {
        return buildVoteBtns(context, timestamp, sendName, recName);
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
          buildVoteBtns(context, timestamp, sendName, recName, true),
        ]);
      }
    }
  );
}

Widget buildVoteBtns(BuildContext context, timestamp, sendName,
  recName, [bool vertical = false]
){
  Widget buildVoteSend(){
    return Container(
      height: 30,
      width: 100,
      padding: EdgeInsets.only(top: 4, left: 8),
      child: RaisedButton(
        onPressed: () {
          //TODO: Handle Mod Vote SendUser
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
        onPressed: () {
          //TODO: Handle Mod Vote RecUser
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