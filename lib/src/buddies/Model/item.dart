import 'package:flutter/material.dart';
import 'package:login/analtyicsController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:login/userController.dart';
import 'package:login/src/buddies/Controller/controller.dart';
import 'package:login/src/buddies/View/details_page.dart';
import 'package:latlong/latlong.dart';

Controller buddyController;
String photo;
Widget buildItem(BuildContext context, String friendUid, 
  userController user, analyticsController analControl) {
  if (friendUid == user.uid) {
    return Container();
  } else {
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance.collection('users').document(friendUid).snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Container();
          }
          else {
            return FlatButton(
            //onPressed: () => _navigateToBuddyDetails(document),
            onPressed: () {
              Controller.NavigateToBuddyDetails(snapshot.data, user, context);
            },
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
                    imageUrl:'${snapshot.data['photoUrl']}',
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
                            '${snapshot.data['name']}',
                            style: TextStyle(color: Colors.lightGreen),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                        ),
                        Container(
                          child: Text(
                            '@${snapshot.data['username']}',
                            style: TextStyle(color: Colors.lightGreen),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(left: 20.0),
                  ),
                ),
              ]),
            );
          }
        }
      ),
    );
  }
}

void _navigateToBuddyDetails(
      DocumentSnapshot document, userController user) 
      async {
    BuildContext context;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BuddyDetailsPage(document, user),
        fullscreenDialog: true
        
      )
    );
}
