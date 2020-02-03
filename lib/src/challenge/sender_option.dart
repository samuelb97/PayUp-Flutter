import 'package:flutter/material.dart';
import 'package:login/userController.dart';
import 'package:login/analtyicsController.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/src/search/searchservice.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:login/prop-config.dart';
import 'package:login/src/challenge/betController.dart';
import 'package:login/src/challenge/challenge_form.dart';
import 'package:login/src/challenge/moderator_search.dart';
import 'dart:async';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:fluttertoast/fluttertoast.dart';


class SenderSelectPage extends StatefulWidget {
  SenderSelectPage({Key key, this.analControl, @required this.user, this.bet})
      : super(key: key);

  betController bet;

  final userController user;
  final analyticsController analControl;
  
  //final TextEditingController _controller = new TextEditingController();

  @override
  _SenderSelectPageState createState() => _SenderSelectPageState();
}

class _SenderSelectPageState extends StateMVC<SenderSelectPage> {
  
  String selected_outcome;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Challenge Details"),
          backgroundColor: themeColors.accent2,
          
        ),
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child:SingleChildScrollView(
            
              child: Container(
                decoration: themeColors.linearGradient,
                child: Column(
                  children: <Widget>[
                    RadioButtonGroup(
                      labelStyle: TextStyle(color: Colors.white),
                      labels: widget.bet.outcomeList,
                      onSelected: (String selected) {
                        setState(() {
                          selected_outcome = selected;
                          widget.bet.set_wager_type = selected;
                        });
                      }
                    ),

                    sendButton(context),
                    
                    Container(height: 500),
                    
                  ],
                ),
                
              ))));
  }
  
  Widget sendButton(BuildContext context){
    if(selected_outcome != null){
      return RaisedButton(
        onPressed: () async {
         
          String betID = await widget.bet.createGroupBet(context, widget.user);

          for(String outcome in widget.bet.outcomeList){
            String outcomeID = await widget.bet.createOutcome(context, betID, outcome);
            if(outcome == selected_outcome){
              await widget.bet.createBettor(context, betID, outcomeID, widget.user.uid, widget.bet.send_w);
            }
          }
          
          Fluttertoast.showToast(msg: 'Challenge request sent');
          Navigator.pop(context);
        },
        color: themeColors.accent2,
        textColor: Colors.white,
        child: Text("Send it out"),
      );
    }
  }
}