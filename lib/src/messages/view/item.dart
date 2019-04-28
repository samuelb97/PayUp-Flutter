import 'package:flutter/material.dart';
import 'package:login/analtyicsController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:login/userController.dart';
import 'package:login/src/messages/chat/chat.dart';
import 'package:login/prop-config.dart';

Widget buildItem (BuildContext context, String groupChatId,
    userController user, analyticsController analControl) {

  String peerId = '';
  List groupSplit = groupChatId.split('-');
  if(groupSplit[0] == user.uid){
    peerId = groupSplit[1];
  }
  else {
    peerId = groupSplit[0];
  }

  {
    print("Build Message Item: $groupChatId, $peerId\n");
    return Container(
      margin: EdgeInsets.only(bottom: 6.0, left: 5.0, right: 5.0),
      child: StreamBuilder(
        stream: Firestore.instance.collection('messages').document(groupChatId)
          .collection(groupChatId).snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return Container();
          } else {
             return StreamBuilder(
               stream: Firestore.instance.collection('users').document(peerId).snapshots(),
               builder: (context, snapshot2) {
                if(!snapshot2.hasData) {
                  return Container();
                } else {
                  return FlatButton(
                    child: Row(
                      children: <Widget>[
                        Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(themeColors.accent1),
                                  ),
                                  width: 50.0,
                                  height: 50.0,
                                  padding: EdgeInsets.all(15.0),
                                ),
                            imageUrl: '${snapshot2.data['photoUrl']}',
                            width: 50.0,
                            height: 50.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        Flexible(
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    '${snapshot2.data['name']}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                ),
                                Container(
                                  child: Text(
                                    '${snapshot.data.documents.last['content']}',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 2.0),
                                ),
                                Container( 
                                  color: themeColors.accent1,
                                  height: 1,
                                  width: 220,
                                ),
                              ],
                            ),
                            margin: EdgeInsets.only(left: 20.0),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Chat(
                                    peerId: peerId,
                                    peerName: snapshot2.data['name'],
                                    peerAvatar: snapshot2.data['photoUrl'],
                                    analControl: analControl,
                                    user: user,
                                  ),
                              fullscreenDialog: true));
                    },
                    padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  );
                }
               }
             );
          }
        }
      )  
    );
  } 
}