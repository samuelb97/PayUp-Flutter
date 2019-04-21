import 'package:flutter/material.dart';
import 'package:login/src/buddies/View/detail_footer.dart';
import 'package:login/src/buddies/View/detail_header.dart';
import 'package:login/src/buddies/Controller/detail_body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/userController.dart';
import 'package:login/prop-config.dart';

class FriendDetailsPage extends StatefulWidget {
  FriendDetailsPage(
    this.document, 
    this.user, {
    Key key,  
  });
  final userController user;
  final DocumentSnapshot document;

  @override
  _FriendDetailsPageState createState() => _FriendDetailsPageState();
}

class _FriendDetailsPageState extends State<FriendDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: themeColors.linearGradient,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FriendDetailHeader(widget.document, widget.user),
              FriendDetailBody(widget.document, widget.user)
            ],
          ),
        ), 
      ),
    );
  }
}