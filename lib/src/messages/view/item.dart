import 'package:flutter/material.dart';
import 'package:login/analtyicsController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:login/userController.dart';
import 'package:login/src/messages/chat/chat.dart';
import 'package:login/prop-config.dart';

Widget buildItem(BuildContext context, DocumentSnapshot document,
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
      margin: EdgeInsets.only(bottom: 12.0, right: 5.0, top: 4),
      child: StreamBuilder(
        stream: Firestore.instance.collection('messages').document(groupChatId)
          .collection(groupChatId).snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData || snapshot.data.documents.toString() == "[]") {
            return Container();
          } else {
             return FlatButton(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                Row(
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
                              padding: EdgeInsets.all(10.0),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(
                                '${document['name']}',
                                style: TextStyle(color: Colors.white,
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                            Container(
                              child: Text(
                                DateFormat('dd MMM kk:mm').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(document['timestamp']))),
                                style: TextStyle(color: Colors.grey,
                                  fontSize: 14),
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(left: 20.0),
                      ),
                    ),
                    Spacer(),
                    Text( 
                    )
                       '${${DateFormat('dd MMM kk:mm').format(DateTime.fromMillisecondsSinceEpoch(snapshot.data.documents.last['content']))}'
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 6)),
                Container( 
                  height: 1,
                  width: MediaQuery.of(context).size.width * .85,
                  color: themeColors.accent1,
                )
              ]),
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
            );
          }
        }
      )  
    );
  } 
}