import 'package:flutter/material.dart';
import 'package:login/src/buddies/View/diagonally_cut_colored_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/userController.dart';
import 'package:login/analtyicsController.dart';
import 'package:login/src/messages/chat/chat.dart';
import 'package:login/src/buddies/View/showinterests.dart';

class BuddyDetailHeader extends StatelessWidget {
  static const BACKGROUND_IMAGE = 'images/profile_header_background.png';

  BuddyDetailHeader(this.document, this.user, {Key key});

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
        height: 280.0,
        fit: BoxFit.cover,
      ),
      color: const Color(0xBB8338f4),
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

  Widget _buildFollowerInfo(TextTheme textTheme) {
    var followerStyle =
        textTheme.subhead.copyWith(color: const Color(0xBBFFFFFF));

    return new Padding(
      padding: const EdgeInsets.only(top: 14.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text('', style: followerStyle),
          new Text(
            '  ',
            style: followerStyle.copyWith(
                fontSize: 24.0, fontWeight: FontWeight.normal),
          ),
          new Text('', style: followerStyle),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _createMessageButton(context,
            'MESSAGE',
            backgroundColor: Colors.green[500],
          ),
          _createInterestButton(context,
            'INTERESTS',
            backgroundColor: Colors.blue[500],
          )
      
        ],
      ),
    );
  }
  
  Widget _createMessageButton(
    BuildContext context, String text, {
    Color backgroundColor = Colors.transparent,
    Color textColor = Colors.white70,
    
  }) {
    return new ClipRRect(
      borderRadius: new BorderRadius.circular(30.0),
      
      child: new MaterialButton(
        minWidth: 140.0,
        color: Colors.green[600],
        textColor: Colors.black,
        onPressed: () {
          print('${document}');
          print('User: ${user.uid}');
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
        child: new Text(text),
      ),
    );
  }

  Widget _createInterestButton(
    BuildContext context, String text, {
    Color backgroundColor = Colors.transparent,
    Color textColor = Colors.white70,
    
  }) {
    
    return new ClipRRect(
      borderRadius: new BorderRadius.circular(30.0),
      child: new MaterialButton(
        minWidth: 140.0,
        color: Colors.green[200],
        textColor: Colors.black,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ShowInterestsPage(
                        document: document
                      ),
                  fullscreenDialog: true));
        },
        child: new Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return new Stack(
      children: <Widget>[
        _buildDiagonalImageBackground(context),
        new Align(
          alignment: FractionalOffset.bottomCenter,
          heightFactor: 1.4,
          child: new Column(
            children: <Widget>[
              _buildAvatar(),
              _buildFollowerInfo(textTheme),
              _buildActionButtons(theme, context),
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