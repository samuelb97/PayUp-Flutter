import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:login/prop-config.dart';
import 'package:login/userController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/src/itemBuilds/friendRequestItems.dart';
import 'package:login/src/itemBuilds/modVoteItem.dart';
import 'package:intl/intl.dart';


Widget friendRequestItem(BuildContext context, userController user){

  return StreamBuilder(
    stream: Firestore.instance.collection('users').document(user.uid).snapshots(),
    builder: (context, snapshot1) {
      if (!snapshot1.hasData || snapshot1.data['friend_requests'] == null
         ){
        return Container();
      } else {
        List friend_request = snapshot1.data["friend_requests"];
      if(friend_request.length == 0){
        return Container();
      }
        for(var userID in friend_request){
            return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                  stream: Firestore.instance.collection('users').document(userID).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData){
                      return Container();
                    } else {
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
                              " sent you a friend request",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ]),
                          Padding(padding: EdgeInsets.only(top: 4)),
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
                                padding: EdgeInsets.all(12.0),
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
              
              Row(children: <Widget>[
              Container(
                height: 24,
                width: 90,
                //padding: EdgeInsets.only(top: 4),
                child: RaisedButton(
                  onPressed: () async {
                    var docRef = Firestore.instance.collection("users").document(user.uid);
                    var docRef2 = Firestore.instance.collection("users").document(userID);
                    await docRef.updateData({
                      "friend_requests":FieldValue.arrayRemove(["$userID"]), //suspicious of this userC instance being correct
                      "friends":FieldValue.arrayUnion(["$userID"]),
                    });
                    await docRef2.updateData({
                      "friend_requests":FieldValue.arrayRemove(["${user.uid}"]), //suspicious of this userC instance being correct
                      "friends":FieldValue.arrayUnion(["${user.uid}"]),
                    });
                    List temp = List.from(user.friends);
                    List temp1 = List.from(user.friend_req);
                    temp.add(userID);
                    temp1.remove(userID);
                    user.set_friends = temp;
                    user.set_friend_requests = temp1;
                    //firestore update friends list for both users, and request list for this user
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
                //padding: EdgeInsets.only(top: 4),
                child: RaisedButton(
                  onPressed: () async {
                    var docRef = Firestore.instance.collection("users").document(user.uid);
                    await docRef.updateData({
                      "friend_requests":FieldValue.arrayRemove(["$userID"]) //suspicious of this userC instance being correct
                    });
                    List temp1 = List.from(user.friend_req);
                    temp1.remove(userID);
                    user.set_friend_requests = temp1;
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
    }
  );
}
