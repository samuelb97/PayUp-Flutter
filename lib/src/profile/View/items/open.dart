import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:login/prop-config.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:login/analtyicsController.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:login/src/profile/Controller/profileController.dart';
import 'package:login/userController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:login/src/betHandler/betHandler.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:login/src/navbar.dart';

Widget buildOpenBet(BuildContext context, int index, userController user) {

  analyticsController analControl = new analyticsController();
  betHandler handler = new betHandler();

  if(index >= user.bets.length){
    return Container();
  }
  else{
    var betId = user.bets[user.bets.length - index - 1];
    bool btnDisable = false;
    bool isWon = false;
    Color wonColor = themeColors.theme3;
    Color lostColor = themeColors.theme3;
    return StreamBuilder(
      stream: Firestore.instance.collection('bets').document(betId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data["open"]){
          return Container();
        } else {
          var bet = snapshot.data;
          String opponenetID;
          int userWager, opponentWager;
          String yourVote;
          if(bet["send_uid"] == user.uid){  //User is sender
            yourVote = bet["send_vote"];
            opponenetID = bet["rec_uid"];
            userWager = bet["send_wager"];
            opponentWager = bet["rec_wager"];
            if(bet["send_vote"] == user.uid){
              btnDisable = true;
              isWon = true;
              wonColor = themeColors.accent1;
              lostColor = Colors.grey;
            }
            if(bet["send_vote"] == opponenetID){
              btnDisable = true;
              wonColor = Colors.grey;
              lostColor = themeColors.accent1;
            }
          }
          else{
            yourVote = bet["rec_vote"];   //User if reciever
            opponenetID = bet["send_uid"];
            userWager = bet["rec_wager"];
            opponentWager = bet["send_wager"];
            if(bet["rec_vote"] == user.uid){
              btnDisable = true;
              isWon = true;
              wonColor = themeColors.accent1;
              lostColor = Colors.grey;
            }
            if(bet["rec_vote"] == opponenetID){
              btnDisable = true;
              wonColor = Colors.grey;
              lostColor = themeColors.accent1;
            }
          }
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder(
                    stream: Firestore.instance.collection('users').document(opponenetID).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData){
                        return Container();
                      } else {
                        return Row(children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                            Row(children: <Widget>[
                              Text(
                                "  ${user.name}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                " vs ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "${snapshot.data["name"]}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]),
                            Padding(padding: EdgeInsets.only(top: 4)),
                            Text( 
                              "  ${bet["description"]}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            )
                          ]),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.only(top: 8, right: 16),
                            child: Material(
                              borderRadius: BorderRadius.all(Radius.circular(25.0)),
                              clipBehavior: Clip.hardEdge,
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                  ),
                                  width: 50.0,
                                  height: 50.0,
                                  padding: EdgeInsets.all(15.0),
                                ),
                                imageUrl:'${snapshot.data["photoUrl"]}',
                                width: 50.0,
                                height: 50.0,
                                fit: BoxFit.cover,
                              ),
                            )
                          ),
                        ]);
                      }
                    },
                  ),
                ),
                StreamBuilder(
                  stream: Firestore.instance.collection('users').document(bet["mod_uid"]).snapshots(),
                  builder: (context,snapshot) {
                    if(!snapshot.hasData){
                      return Container();
                    }
                    else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:<Widget>[
                        
                        Row(children: <Widget>[
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey
                              ),
                              children: <TextSpan>[
                                TextSpan(text: "  Your Wager: "),
                                TextSpan(text: "$userWager", style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: "       Opponent Wager: "),
                                TextSpan(text: "$opponentWager", style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: "\n  Moderator: "),
                                TextSpan(text: "${snapshot.data["name"]}", style: TextStyle(fontWeight: FontWeight.bold)),
                              ]
                            ),
                          ),
                          Spacer(),
                        ]),
                        Builder(builder: (context){
                          if(bet["imageUrl"] == "" || bet["imageUrl"] == null){
                            return Container();
                          } else {
                            return Container(
                              padding: EdgeInsets.only(right: 50, top: 8, bottom: 8, left: 8),
                              child: Material(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                clipBehavior: Clip.hardEdge,
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                    ),
                                    width: 120.0,
                                    height: 80.0,
                                    padding: EdgeInsets.all(15.0),
                                  ),
                                  imageUrl: '${bet["imageUrl"]}',
                                  width: 120.0,
                                  height: 80.0,
                                  fit: BoxFit.cover,
                                ),
                              )
                            );
                          }
                        }),
                        Row(children: <Widget>[
                          Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                          Container(
                            height: 24,
                            width: 94,
                            padding: EdgeInsets.only(top: 4),
                            child: RaisedButton(
                              highlightColor: Colors.white,
                              onPressed: btnDisable ? null : () async {
                                btnDisable = true;
                                isWon = true;
                                String temp = await handler.updateBetVotes(context, user, betId, user.uid);

                                print("\n\n\nWinner registered:  $temp");

                                String winner_pubKey = await handler.checkVotesDone(context, user, betId);
                                print("Winner pubKey:  $winner_pubKey");
                                if(winner_pubKey != null){
                                  int total = bet['rec_wager'] + bet['send_wager'];
                                  Map data ={
                                    'recipient': winner_pubKey,
                                    'amount': total
                                  };

                                  var body = json.encode(data);

                                  final response = 
                                  await http.post('https://gentle-ridge-52752.herokuapp.com/transact-to-winner', headers: {"Content-Type": "application/json"}, body: body);
                                  
                                  user.set_balance = json.decode(response.body)['balance'];
                                  
                                }
                                // Navigator.pushReplacement(context, 
                                //   MaterialPageRoute(builder: (context) => Home(user: user, analControl: analControl))
                                // );



                                //TODO: transaction if bet_done is true
                              },
                              
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: (!isWon && btnDisable) ? Colors.grey : themeColors.accent1),
                                borderRadius: BorderRadius.circular(35),
                              ),
                              color: wonColor,
                              child: Text("I Won",
                                  style: TextStyle(color: Colors.grey)),
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                          Container(
                            height: 24,
                            width: 94,
                            padding: EdgeInsets.only(top: 4),
                            child: RaisedButton(
                              onPressed: btnDisable ? null : () async {
                                String temp;
                                btnDisable = true;
                                isWon = false;
                                print("snapshot data comparator: \n\n");
                                print(bet['rec_uid']);
                                if(user.uid == bet['send_id']){
                                  temp = await handler.updateBetVotes(context, user, betId, bet['rec_uid']);
                                }
                                else{
                                  temp = await handler.updateBetVotes(context, user, betId, bet['send_uid']);
                                }

                                print("\n\n\nWinner registered:  $temp");

                                String winner_pubKey = await handler.checkVotesDone(context, user, betId);
                                print("Winner pubKey:  $winner_pubKey");

                                if(winner_pubKey != null){
                                  int total = bet['rec_wager'] + bet['send_wager'];
                                  Map data ={
                                    'recipient': winner_pubKey,
                                    'amount': total
                                  };

                                  var body = json.encode(data);

                                  http.post('https://gentle-ridge-52752.herokuapp.com/transact-to-winner', headers: {"Content-Type": "application/json"}, body: body);

                                  //user.set_balance = user.balance + total;
                                  
                                }
                                // Navigator.pushReplacement(context, 
                                //   MaterialPageRoute(builder: (context) => Home(user: user, analControl: analControl))
                                // );

                                // if(winner_pubKey != null){
                                  
                                // }

                                // if(bet_done){
                                //   print("\n\nBet done, winner is Sam");
                                // }

                                //TODO: Transaction if bet_done is true 
                              },
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: (isWon && btnDisable) ? Colors.grey : themeColors.accent1),
                                borderRadius: BorderRadius.circular(35),
                              ),
                              color: lostColor,
                              child: Text("I Lost",
                                  style: TextStyle(color: Colors.grey)),
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.only(top: 24),
                            child: Text(
                              "   ${DateFormat('dd MMM kk:mm').format(
                                  DateTime.fromMillisecondsSinceEpoch(bet['timestamp'])
                              )}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10.0,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * .15
                          )),
                        ])
                      ]);
                    }
                  }
                ),
                Padding(padding: EdgeInsets.only(bottom: 4)),
                Container(
                  width: MediaQuery.of(context).size.width * .85,
                  height: 1,
                  color: themeColors.accent1,
                )   
              ],
            ),
          );
        }
      }
    );
  }
}

// class ChangeRaisedButtonColor extends StatefulWidget {

//   ChangeRaisedButtonColor({
//     this.isWon,
//     this.btnDisable,
//   });

//   bool isWon;
//   bool btnDisable;

//   @override
//   ChangeRaisedButtonColorState createState() => ChangeRaisedButtonColorState();
// }

// class ChangeRaisedButtonColorState extends State<ChangeRaisedButtonColor>
//     with SingleTickerProviderStateMixin {
//   AnimationController _animationControllerWon;
//   Animation _colorTweenSelectedWon;
//   Animation _colorTweenNotSelectedWon;
//   AnimationController _animationControllerLost;
//   Animation _colorTweenSelectedLost;
//   Animation _colorTweenNotSelectedLost;
  

//   @override
//   void initState() {
//     _animationControllerWon =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 300));
//     _animationControllerLost =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    
//     _colorTweenSelectedWon = ColorTween(begin: themeColors.theme3, end: themeColors.accent1)
//         .animate(_animationControllerWon);
//     _colorTweenNotSelectedWon = ColorTween(begin: themeColors.theme3, end: Colors.grey)
//         .animate(_animationControllerWon);

//     _colorTweenSelectedLost = ColorTween(begin: themeColors.theme3, end: themeColors.accent1)
//         .animate(_animationControllerLost);
//     _colorTweenNotSelectedLost = ColorTween(begin: themeColors.theme3, end: Colors.grey)
//         .animate(_animationControllerLost);
    

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(children: <Widget> [
//       AnimatedBuilder(
//         animation: _colorTween,
//         builder: (context, child) => Container(
//           height: 24,
//           width: 94,
//           padding: EdgeInsets.only(top: 4),
//           child: RaisedButton(
//               child: Text("You Lost"),
//               shape: RoundedRectangleBorder(
//                 side: BorderSide(color: (widget.isWon && widget.btnDisable) ? Colors.grey : themeColors.accent1),
//                 borderRadius: BorderRadius.circular(35),
//               ),
//               color: _colorTween.value,
//               onPressed: () {
//                 if (_animationController.status == AnimationStatus.completed) {
//                   _animationController.reverse();
//                 } else {
//                   _animationController.forward();
//                 }
//               },
//             ),
//         )
//       ),
//     ]);
//   }
// }

// Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
// Container(
//   height: 24,
//   width: 94,
//   padding: EdgeInsets.only(top: 4),
//   child: RaisedButton(
//     highlightColor: Colors.white,
//     onPressed: btnDisable ? null : () {
//       //TODO: Handle Win Vote
//     },
//     shape: RoundedRectangleBorder(
//       side: BorderSide(color: (!isWon && btnDisable) ? Colors.grey : themeColors.accent1),
//       borderRadius: BorderRadius.circular(35),
//     ),
//     color: (!btnDisable) ? (themeColors.theme3) : isWon? themeColors.accent1 : Colors.grey,
//     child: Text("You Won",
//         style: TextStyle(color: Colors.grey)),
//   ),
// ),
// Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
// Container(
//   height: 24,
//   width: 94,
//   padding: EdgeInsets.only(top: 4),
//   child: RaisedButton(
//     onPressed: btnDisable ? null : () {
//       //TODO: Handle Win Vote
//     },
//     shape: RoundedRectangleBorder(
//       side: BorderSide(color: (isWon && btnDisable) ? Colors.grey : themeColors.accent1),
//       borderRadius: BorderRadius.circular(35),
//     ),
//     color: btnDisable ? (isWon ? Colors.grey : themeColors.accent1) : themeColors.theme3,
//     child: Text("You Lost",
//         style: TextStyle(color: Colors.grey)),
//   ),
// ),