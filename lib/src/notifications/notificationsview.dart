import 'package:flutter/material.dart';
import 'package:login/userController.dart';
import 'package:login/analtyicsController.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:login/prop-config.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:login/src/notifications/challengeRespondItem.dart';
import 'package:login/src/notifications/moderateRespondItem.dart';
import 'package:login/src/notifications/moderateVoteItem.dart';
import 'package:login/src/notifications/friendRequestRespondItem.dart';

class NotificationsPage extends StatefulWidget {
  NotificationsPage({Key key, this.analControl, @required this.user})
      : super(key: key);

  final userController user;
  final analyticsController analControl;

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {

  List bets;
  List modBets;
  List friend_requests;

  toggleBets(){
    setState(() {
     bets = widget.user.bets; 
     modBets = widget.user.modBets;
    });
  }
  
  List headers = ['Challenge Requests', 'Moderator Requests', 'Moderator Votes', 'Friend Requests'];
  List<Widget> challengeList = new List();
  List<Widget> modReqList = new List();
  List<Widget> modVoteList = new List();
  List<Widget> friendReqList = new List();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        backgroundColor: themeColors.accent3,
      ),
      body: Container(
        height:MediaQuery.of(context).size.height,
        decoration: themeColors.linearGradient,
        child:new ListView.builder( 
        padding:EdgeInsets.only(bottom: 260),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 4,
        itemBuilder:(context,index){
          return new StickyHeader( 
            header: new Container( 
              color: themeColors.theme3,
              height: 50.0, 
              padding: new EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: new Text(headers[index],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            content: new Builder(
              builder:(context){
                bets = widget.user.bets;
                modBets = widget.user.modBets;
                friend_requests = widget.user.friend_req;
                print("list view index:  $index\n");
                if(index == 0){
                  for(int i = 0; i < bets.length; i++){
                    print("Challenge $i\n");
                    print("Challenge response\n\n");
                    
                    challengeList.add(challengeRespondItem(context, bets[i], widget.user, toggleBets));
                  }
                  return Column(children: challengeList);
                }
                if(index == 1){
                  for(int i = 0; i < modBets.length; i++){
                    print("Moderator $i\n");
                    print("Moderate response\n\n");

                    modReqList.add(moderateRespondItem(context, modBets[i], widget.user, toggleBets));
                  }
                  return Column(children: modReqList);
                }
                if(index == 2){
                  for(int i = 0; i < modBets.length; i++){
                    print("Moderator $i\n");
                    print("Moderate response\n\n");

                    modVoteList.add(moderateVoteItem(context, modBets[i], widget.user));
                  }
                  return Column(children: modVoteList);
                }
                if(index == 3){
                  for(int i = 0; i < friend_requests.length; i++){
                    
                    friendReqList.add(friendRequestItem(context, widget.user));
                  }
                  return Column(children: friendReqList);
                }
                else {
                  return Container();
                }
              }
              
              
            ),
          );
        }
      ),

    ));
  }
}