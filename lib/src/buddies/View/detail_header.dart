import 'package:flutter/material.dart';
import 'package:login/src/buddies/View/diagonally_cut_colored_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/userController.dart';
import 'package:login/analtyicsController.dart';
import 'package:login/src/messages/chat/chat.dart';
import 'package:login/src/buddies/View/showinterests.dart';
import 'package:login/prop-config.dart';

class FriendDetailHeader extends StatelessWidget {
  static const BACKGROUND_IMAGE = 'images/profile_header_background.png';

  FriendDetailHeader(this.document, this.user, {Key key});

  userController user;
  analyticsController analControl;
  final DocumentSnapshot document;
  Widget _buildDiagonalImageBackground(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    //var screenHeight = MediaQuery.of(context).size.height;

    return new DiagonallyCutColoredImage(
      new Image.asset(
        BACKGROUND_IMAGE,
        width: screenWidth,
        height: 240.0,
        fit: BoxFit.cover,
      ),
      color: themeColors.theme3,
    );
  }

  Widget _buildAvatar() {
    return new Hero(
      tag: "demohero",
      child: new CircleAvatar(
        backgroundImage: NetworkImage('${document.data['photoUrl']}'),
        radius: 60.0,
      ),
    );
  }

  Widget _buildFriendInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("${document.data["name"]}",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white
            )),
          Text(
            "@${document.data["username"]}",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey
            )
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            width: 120,
            child: _createMessageButton(context)
          ),
          Container(
            width: 120,
            child: _createChallengeButton(context)
          ),
        ],
      ),
    );
  }
  
  Widget _createMessageButton(BuildContext context){
    return RaisedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Chat(
              peerId: document.documentID,
              peerName: document.data['name'],
              peerAvatar: document.data['photoUrl'],
              analControl: analControl,
              user: user,
            ),
          fullscreenDialog: true));
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      padding: EdgeInsets.all(12),
      color: themeColors.accent1,
      child: Text("Message",
          style: TextStyle(color: themeColors.theme3)),
    );
  }

  Widget _createChallengeButton(BuildContext context){
    return RaisedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowInterestsPage(
                  document: document
                ),
            fullscreenDialog: true));
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      padding: EdgeInsets.all(12),
      color: themeColors.accent2,
      child: Text("Challenge",
          style: TextStyle(color: themeColors.theme3)),
    );
  }
    

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildDiagonalImageBackground(context),
        Align(
          alignment: FractionalOffset.bottomCenter,
          heightFactor: 1.4,
          child: Column(
            children: <Widget>[
              Row(children: <Widget>[
                Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                _buildAvatar(),
                _buildFriendInfo(),
              ]),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              _buildActionButtons(context),
            ],
          ),
        ),
        new Positioned(
          top: 26.0,
          left: 4.0,
          child: new BackButton(color: Colors.white),
        ),
      ],
    );
  }
}