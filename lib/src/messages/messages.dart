import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/analtyicsController.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:login/src/messages/msgController.dart';
import 'package:login/src/messages/view/item.dart';
import 'package:login/userController.dart';
import 'package:login/prop-config.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: <Widget>[
            Container(
              decoration: themeColors.linearGradient,
              child: StreamBuilder(
                stream: Firestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  print("\n\n Docs: ${snapshot.data.documents}\n Length: ${snapshot.data.documents.length}\n");
                  if (!snapshot.hasData || snapshot.data.documents == null) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    );
                  } else {
                    var docs = snapshot.data.documents;
                    return ListView.builder(
                      itemBuilder: (context, index) => buildItem(
                        context, 
                        docs[index], 
                        widget.user,
                        widget.analControl
                      ),
                      itemCount: docs.length,
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