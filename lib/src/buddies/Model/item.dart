import 'package:flutter/material.dart';
import 'package:login/analtyicsController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:login/userController.dart';
import 'package:login/src/buddies/View/details_page.dart';
import 'package:login/prop-config.dart';

String photo;
Widget buildItem(BuildContext context, data, 
  userController user) {
    return Container(
      padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
      child: FlatButton(
        //onPressed: () => _navigateToBuddyDetails(document),
        onPressed: () {
          NavigateToFriendDetails(data, user, context);
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
                imageUrl:'${data['photoUrl']}',
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
                        '${data['name']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    Container(
                      child: Text(
                        '@${data['username']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                    Container( 
                      color: themeColors.accent1,
                      height: 1,
                      width: 220,
                    )
                  ],
                ),
                margin: EdgeInsets.only(left: 20.0),
              ),
            ),
          ]),
        ),
    );
}

Future<void> NavigateToFriendDetails(DocumentSnapshot document, userController user, BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FriendDetailsPage(document, user),
        fullscreenDialog: true
      )
    );
}
