import 'package:flutter/material.dart';
import 'package:login/analtyicsController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:login/userController.dart';
import 'package:login/src/messages/chat/chat.dart';

Widget buildItem (BuildContext context, DocumentSnapshot document,
    userController user, analyticsController analControl) {

  String groupChatId;

  if(!document.exists) {
    return Container();
  }

  if (user.uid.hashCode <= document.documentID.hashCode) {
    groupChatId = '${user.uid}-${document.documentID}';
  } else {
    groupChatId = '${document.documentID}-${user.uid}';
  }
  {
    return Container(
      margin: EdgeInsets.only(bottom: 6.0, left: 5.0, right: 5.0),
      child: StreamBuilder(
        stream: Firestore.instance.collection('messages').document(groupChatId)
          .collection(groupChatId).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.data.documents.toString() == "[]") {
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
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                            ),
                            width: 50.0,
                            height: 50.0,
                            padding: EdgeInsets.all(15.0),
                          ),
                      imageUrl: '${document.data['photoUrl']}',
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
                              '${document['name']}',
                              style: TextStyle(color: Colors.lightGreen),
                            ),
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                          ),
                          Container(
                            child: Text(
                              '${snapshot.data.documents.last['content']}',
                              style: TextStyle(color: Colors.lightGreen),
                            ),
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          )
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
                              peerId: document.documentID,
                              peerName: document['name'],
                              peerAvatar: document['photoUrl'],
                              analControl: analControl,
                              user: user,
                            ),
                        fullscreenDialog: true));
              },
              color: Colors.grey[700],
              padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            );
          }
        }
      )  
    );
  } 
}
