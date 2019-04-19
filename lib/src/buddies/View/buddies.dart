import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:login/src/buddies/Controller/controller.dart';
import 'package:login/src/buddies/Model/friend.dart';
import 'package:login/src/buddies/Model/item.dart'; 
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:login/analtyicsController.dart';
import 'package:login/userController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FriendsPage extends StatefulWidget {  
  FriendsPage({
    Key key,
    this.analControl,
    this.friend,
    @required this.user 
    
  })
      : super(key: key);
  final Friend friend;
  final userController user;
  final analyticsController analControl;

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends StateMVC<FriendsPage> {
  _FriendsPageState() : super(Controller()) {
    friendController = Controller.con;
  }
  Controller friendController;
  
  List<Friend> _friends;
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
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    http.Response response =
        await http.get('https://randomuser.me/api/?results=25');

    setState(() {
      _friends = Friend.allFromResponse(response.body);
    });
  }

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
              child: friendController.isLoading
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