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

class NotificationsPage extends StatefulWidget {
  NotificationsPage({Key key, this.analControl, @required this.user})
      : super(key: key);

  final userController user;
  final analyticsController analControl;

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends StateMVC<NotificationsPage> {

  List headers = ['Challenge Requests', 'Moderator Requests', 'Moderation Votes Pending'];
  List<Widget> list = new List();
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
        itemCount: 3,
        itemBuilder:(context,index){
          // if(index > 2) return Container();
          return new StickyHeader( 
            
            header: new Container( 
              color: themeColors.theme3,
              height: 50.0, 
              padding: new EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: new Text(headers[index],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            content: new Builder(
              builder:(context){
                print("list view index:  $index\n");
               if(index == 0){
                for(int i = 0; i < widget.user.bets.length; i++){
                  print("Challenge $i\n");
                  print("Challenge response\n\n");
                  
                    list.add(challengeRespondItem(context, widget.user.bets[i], widget.user));
                }
                return Column(children: list);
               }
               if(index == 1){
                for(int i = 0; i < widget.user.modBets.length; i++){
                  print("Moderator $i\n");
                  print("Moderate response\n\n");
                  
                    list.add(moderateRespondItem(context, widget.user.modBets[i], widget.user));
                }
                return Column(children: list);
               }
               else {return Container();}
              }
              
              
            ),
          );
        }
      ),

        ));
  }
}