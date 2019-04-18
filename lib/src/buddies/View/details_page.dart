import 'package:flutter/material.dart';
import 'package:login/src/buddies/View/detail_footer.dart';
import 'package:login/src/buddies/View/detail_header.dart';
import 'package:login/src/buddies/Controller/detail_body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/userController.dart';

class BuddyDetailsPage extends StatefulWidget {
  BuddyDetailsPage(this.document, this.user, {
    Key key,
     
  });
 userController user;
  final DocumentSnapshot document;
  //final Object avatarTag;

  @override
  _BuddyDetailsPageState createState() => new _BuddyDetailsPageState();
}

class _BuddyDetailsPageState extends State<BuddyDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          const Color(0xFF413070),
          const Color(0xFF2B264A),
        ],
      ),
    );

    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Container(
          decoration: linearGradient,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new BuddyDetailHeader(widget.document, widget.user),
              new Padding(
                padding: const EdgeInsets.all(24.0),
                child: new BuddyDetailBody(widget.document, widget.user),
              ),
              new BuddyShowcase(widget.document),
            ],
          ),
        ), 
      ),
    );
  }
}