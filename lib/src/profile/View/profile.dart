import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:login/prop-config.dart';
import 'package:login/analtyicsController.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:login/src/profile/Controller/profileController.dart';
import 'package:login/userController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/src/profile/View/items/open.dart';
import 'package:login/src/profile/View/items/closed.dart';
import 'package:login/src/profile/View/items/pending.dart';
import 'package:intl/intl.dart';
import 'package:login/src/profile/View/items/profileInfo.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({
    this.analControl, 
    this.user,
  });

  final userController user;
  final analyticsController analControl;

  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController( 
        length: 3,
        child: Scaffold(
          backgroundColor: themeColors.theme3,
          appBar: TabBar(
            indicatorColor: themeColors.accent,
            labelColor: themeColors.accent1,
            tabs: <Widget>[
              Tab(child: Text( 
                "Open",
                style: TextStyle(fontSize: 16),
              ),),
              Tab(child: Text( 
                "Closed",
                style: TextStyle(fontSize: 16),
              ),),
              Tab(child: Text( 
                "Pending",
                style: TextStyle(fontSize: 16),
              ),),
            ],
          ),
          body: Container(
            decoration: themeColors.linearGradient,
            child: TabBarView(
              children: List<Widget>.generate(3, (int index) { //creates a lists of 3 elements (tab count)
                print("Gen index: $index\n");
                print("User Bets Length: ${widget.user.bets.length}");
                if(index == 0) {
                  return ListView.builder(               //Open Bets
                    itemCount: widget.user.bets.length,
                    key: PageStorageKey<int>(index),
                        //Makes two keys for two lists
                    itemBuilder: (cntxt, idx)
                      => buildOpenBet(cntxt, idx, widget.user)
                  );
                }
                else if(index == 1){
                  return ListView.builder(              //Closed Bets
                    itemCount: widget.user.bets.length,
                    key: PageStorageKey<int>(index),     //Makes two keys for two lists
                    itemBuilder: (cntxt, idx) 
                      => buildClosedBet(cntxt, idx, widget.user)
                  );
                }
                else{
                  print("Before ListView Pending");
                  return ListView.builder(              //Pending
                    itemCount: widget.user.bets.length,
                    padding: EdgeInsets.only(bottom: 260),
                    key: PageStorageKey<int>(index),     //Makes two keys for two lists
                    itemBuilder: (cntxt, idx) 
                    => buildPendingBet(cntxt, idx, widget.user),
                  );
                }
              })
            )
          )
        ),
      )
    );
  }
}

// searchByName(String betId){
//   return Firestore.instance.collection('bets').document(betId);
// }
