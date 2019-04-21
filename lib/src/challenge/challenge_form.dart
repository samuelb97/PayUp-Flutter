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

class ChallengeFormPage extends StatefulWidget {
  ChallengeFormPage({Key key, this.analControl, @required this.user, this.bet})
      : super(key: key);

  final betController bet;

  final userController user;
  final analyticsController analControl;
  //final TextEditingController _controller = new TextEditingController();

  @override
  _ChallengeFormPageState createState() => _ChallengeFormPageState();
}

class _ChallengeFormPageState extends StateMVC<ChallengeFormPage> {
   @override
  Widget build(BuildContext context) {
    widget.analControl.currentScreen('update_profile', 'updateProfileOver');
    return Scaffold(
      appBar: AppBar(
        title: Text("Challenge Specifications"),
        backgroundColor: themeColors.accent2,
        actions: <Widget>[IconButton(
                            color: Colors.white,
                            icon: Icon(Icons.arrow_back),
                            iconSize: 20.0,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),],
        
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: Form(
            key: widget.bet.registerformkey,
            child: Column(
              children: <Widget>[
                Row( children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(hintText: "Your Wager"),
                  maxLength: 5,
                  //validator: _con.validateName,
                  onSaved: (input) => widget.bet.set_send_wager = int.parse(input),
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "To Win"),
                  maxLength: 5,
                  //validator: _con.validateAge,
                  onSaved: (input) => widget.bet.set_rec_wager = int.parse(input),
                ),]),
                TextFormField(
                  decoration: InputDecoration(hintText: "Challenge Description"),
                  maxLength: 140,
                  //validator: _con.validateOccupation,
                  onSaved: (input) => widget.bet.set_description = input,
                ),
                TextFormField(
                    decoration: InputDecoration(hintText: user_info.mobileNumber),
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    validator: _con.validateMobile,
                    onSaved: (input) => _con.set_mobile = input,
                ),
                SizedBox(height: 15.0),
                RaisedButton(
                  onPressed: () {
                    widget.analControl.sendAnalytics('profileUpdate');
                    _con.update(widget.user);
                  },
                  child: Text(user_info.update),
                )
              ],
            ),
          )
        )
      )
    );
  }
}