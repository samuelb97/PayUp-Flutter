import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/analtyicsController.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:login/src/messages/msgController.dart';
import 'package:login/src/messages/view/item.dart';
import 'package:login/userController.dart';

class MessagePage extends StatefulWidget {
  MessagePage({Key key, this.analControl, @required this.user})
      : super(key: key);

  final userController user;
  final analyticsController analControl;

  @override
  State createState() => _MessagePageState();
}

class _MessagePageState extends StateMVC<MessagePage> {
  _MessagePageState() : super(MsgController()) {
    msgController = MsgController.con;
  }
  MsgController msgController;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: <Widget>[
            // List
            Container(
              decoration: linearGradient,
              child: StreamBuilder(
                stream: Firestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) => buildItem(
                        context, 
                        snapshot.data.documents[index], 
                        widget.user,
                        widget.analControl
                      ),
                      itemCount: snapshot.data.documents.length,
                    );
                  }
                },
              ),
            ),
            // Loading
            Positioned(
              child: msgController.isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent)),
                      ),
                      color: Colors.white.withOpacity(0.8),
                    )
                  : Container(),
            )
          ],
        ),
    );
  }
}