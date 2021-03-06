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

class ChallengeFormPage extends StatefulWidget {
  ChallengeFormPage({Key key, this.analControl, @required this.user, this.bet})
      : super(key: key);

  betController bet;

  final userController user;
  final analyticsController analControl;
  //final TextEditingController _controller = new TextEditingController();

  @override
  _ChallengeFormPageState createState() => _ChallengeFormPageState();
}

class _ChallengeFormPageState extends StateMVC<ChallengeFormPage> {
  var image =
      'https://firebasestorage.googleapis.com/v0/b/payupelite.appspot.com/o/download.png?alt=media&token=876542de-1dcc-4ea7-b3fc-39eb3301d5b9';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Challenge ${widget.bet.rec_name}"),
          backgroundColor: themeColors.accent2,
          // actions: <Widget>[IconButton(
          //                     color: Colors.white,
          //                     icon: Icon(Icons.arrow_back),
          //                     iconSize: 20.0,
          //                     onPressed: () {
          //                       Navigator.pop(context);
          //                     },
          //                   ),],
        ),
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child:SingleChildScrollView(
            child:
                //  Container(
                //     margin: EdgeInsets.all(15.0),
                Form(
                    key: widget.bet.registerformkey,
                    child: Container(
                      decoration: themeColors.linearGradient,
                      child: Column(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(
                                  left: 15.0, right: 15.0, top: 15.0),
                              child: TextFormField(
                                validator: (input) {
                                  if (isNumeric(input) ||
                                      int.parse(input) < 99999) {
                                    return null;
                                  }
                                  else{return "Please enter a valid amount";}
                                },
                                keyboardType: TextInputType.number,
                                
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(color: Colors.white),
                                  hintText: 'To Wager',
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 10.0),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide:
                                        BorderSide(color: themeColors.accent1),
                                  ),
                                ),
                                maxLength: 5,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),

                                //validator: _con.validateName,
                                onSaved: (input) => widget.bet.set_send_wager =
                                    int.parse(input),
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 15.0, right: 15.0),
                              child: TextFormField(
                                validator: (input) {
                                  if (isNumeric(input) ||
                                      int.parse(input) < 99999) {
                                    return null;
                                  }
                                  else{return "Please enter a valid amount";}
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(color: Colors.white),
                                  hintText: 'To Win',
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 10.0),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                          color: themeColors.accent1)),
                                ),
                                maxLength: 5,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                                //validator: _con.validateAge,
                                onSaved: (input) =>
                                    widget.bet.set_rec_wager = int.parse(input),
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 15.0, right: 15.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(
                                      color: Colors.white, fontSize: 13),
                                  hintText: 'Challenge Description',
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 10.0),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                          color: themeColors.accent1)),
                                ),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                                maxLength: 140,
                                //validator: _con.validateOccupation,
                                onSaved: (input) =>
                                    widget.bet.set_description = input,
                              )),
                          Container(
                              child: Material(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            clipBehavior: Clip.hardEdge,
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.green),
                                    ),
                                    width: 180.0,
                                    height: 120.0,
                                    padding: EdgeInsets.all(15.0),
                                  ),
                              imageUrl: image,
                              width: 180.0,
                              height: 120.0,
                              fit: BoxFit.cover,
                            ),
                          )),
                          RaisedButton(
                            color: themeColors.theme3,
                            splashColor: themeColors.theme2,
                            textColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 14.0),
                            elevation: 6,
                            onPressed: () async {
                              await widget.bet.getImage(widget.user);
                              setState(() {
                                image = widget.bet.bet_im;
                              });
                            },
                            child: Text("Add a Challenge Image",
                                style: TextStyle(
                                  fontSize: 12,
                                )),
                          ),
                          RaisedButton(
                            onPressed: () {
                              if (widget.bet.registerformkey.currentState
                                  .validate()) {
                                widget.bet.registerformkey.currentState.save();
                              }
                              
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ModeratorSearchPage(
                                          user: widget.user, bet: widget.bet)));
                            },
                            color: themeColors.theme3,
                            textColor: Colors.white,
                            child: Text("Lock it in"),
                          ),
                          Container(height: 500),
                          
                        ],
                      ),
                    )))));
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }
}
