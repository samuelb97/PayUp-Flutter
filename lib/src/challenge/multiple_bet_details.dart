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
import 'package:login/src/challenge/sender_option.dart';

class MultipleBetDetailsPage extends StatefulWidget {
  MultipleBetDetailsPage({Key key, this.analControl, @required this.user, this.bet})
      : super(key: key);

  betController bet;

  final userController user;
  final analyticsController analControl;
  
  //final TextEditingController _controller = new TextEditingController();

  @override
  _MultipleBetDetailsPageState createState() => _MultipleBetDetailsPageState();
}

class _MultipleBetDetailsPageState extends StateMVC<MultipleBetDetailsPage> {
  String dropdownValue; //= 'Number of potential outcomes';
  String wager_type; // standard or min/max
  List <String> tempOutcomes = ['test'];
  List <String> _options = ['Two', 'Three', 'Four', 'Five'];
  bool _autoValidate = false;
  var image =
      'https://firebasestorage.googleapis.com/v0/b/payupelite.appspot.com/o/download.png?alt=media&token=876542de-1dcc-4ea7-b3fc-39eb3301d5b9';

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
            child: 
                //  Container(
                //     margin: EdgeInsets.all(15.0),
                
                Form(
                    key: widget.bet.registerformkey,
                    autovalidate: _autoValidate,
                    child: Container(
                      decoration: themeColors.linearGradient,
                      child: Column(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(
                                      color: Colors.white, fontSize: 13),
                                  hintText: 'Group Challenge Description',
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
                            width: MediaQuery.of(context).size.width,
                            color: themeColors.theme3,
                            child: Center( 
                              child: Theme(
                                data: Theme.of(context).copyWith(canvasColor: themeColors.theme3),
                                child: DropdownButton<String>(
                                  hint: Text('Number of potential outcomes', style: TextStyle(color: Colors.white)),
                                  value: dropdownValue,
                                  //hint: Text("Number of Potential Outcomes"),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dropdownValue = newValue;
                                    });
                                  },
                                  items: _options.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value,
                                        style: TextStyle(color: Colors.white)),
                                      );
                                    })
                                    .toList(),
                                )))),
                          Padding(padding: EdgeInsets.only(top: 5)),

                          Center(
                            child: Container( 
                              width: MediaQuery.of(context).size.width * .85,
                              child: Text("Hint: specify how many outcome options you would like to make available to your friends for this challenge", 
                              style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: themeColors.theme0)))),
                          
                          Padding(padding: EdgeInsets.only(bottom: 15)),

                          _outcomeItems(context, dropdownValue),
                          Padding(padding: EdgeInsets.only(bottom: 25)),
                          Text("Wager Type", style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold)),
                          Padding(padding: EdgeInsets.only(bottom: 5)),
                          RadioButtonGroup(
                            labelStyle: TextStyle(color: Colors.white),
                            labels: <String>[
                              "Standard",
                              "Minimum/Maximum",
                            ],
                            onSelected: (String selected) {
                              setState(() {
                                wager_type = selected;
                                //widget.bet.set_wager_type = selected;
                              });
                            }
                          ),

                           Padding(padding: EdgeInsets.only(top: 5)),

                          Center(
                            child: Container( 
                              width: MediaQuery.of(context).size.width * .85,
                              child: Text("Hint: Standard wager allows you to specify a set amount that everyone will put up, while Minimum/Maximum allows you to set a range of acceptable wagers", 
                              style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: themeColors.theme0)))),
                          
                          Padding(padding: EdgeInsets.only(bottom: 15)),

                          _wagerItems(context, wager_type),
                          
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
                            child: Text("Add a Challenge Image (optional)",
                                style: TextStyle(
                                  fontSize: 12,
                                )),
                          ),
                          RaisedButton(
                            onPressed: () {
                              print("BEFORE ERROR \n\n\n\n\n\n");
                              
                              // if (widget.bet.registerformkey.currentState
                              //     .validate()) {
                              widget.bet.registerformkey.currentState.save();

                              //print(widget.bet.outcome_description_list);
                              // print("in button");
                              
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SenderSelectPage(
                                          user: widget.user, bet: widget.bet)));
                                  // } else {
                                  //   setState(() {
                                  //     _autoValidate = true;
                                  //   });
                                  // }
                            },
                            color: themeColors.accent2,
                            textColor: Colors.white,
                            child: Text("Head to final step"),
                          ),
                          Container(height: 500),
                          
                        ],
                      ),
                    )))));
  }

  Widget _outcomeItems(BuildContext context, String option){
    switch(option){
      case 'Two': 
        return Column(
          children: <Widget>[
            _buildItem(context, "A"),
            _buildItem(context, "B")
          ]
        );
      case 'Three':
        return Column(
          children: <Widget>[
            _buildItem(context, "A"),
            _buildItem(context, "B"),
            _buildItem(context, "C"),
          ]
        );

      case 'Four':
        return Column(
          children: <Widget>[
            _buildItem(context, "A"),
            _buildItem(context, "B"),
            _buildItem(context, "C"),
            _buildItem(context, "D"),
          ]
        );
      
      case 'Five':
        return Column(
          children: <Widget>[
            _buildItem(context, "A"),
            _buildItem(context, "B"),
            _buildItem(context, "C"),
            _buildItem(context, "D"),
            _buildItem(context, "E"),
          ]
        );
      default:
        return Container();
    }
  }

  Widget _wagerItems(BuildContext context, String type){
    switch(type){
      case 'Standard': 
        return Column(
          children: <Widget>[
            _buildWagerItem(context, "Standard Wager Amount"),
          ]
        );
      case 'Minimum/Maximum':
        return Column(
          children: <Widget>[
            _buildWagerItem(context, "Minimum Wager"),
            _buildWagerItem(context, "Maximum Wager"),
            _buildWagerItem(context, "Your Wager"),

          ]
        );

      
      default:
        return Container();
    }
  }

  Widget _buildWagerItem(BuildContext context, String type){
    return Container(
      margin: EdgeInsets.only(left: 15.0, right: 15.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        validator: (input) {
          if (!isNumeric(input) ||
              int.parse(input) > 99999) {
            return "Please enter a valid amount";
          }
          else{return null;}
        },
        decoration: InputDecoration(
          fillColor: Colors.white,
          hintStyle: TextStyle(color: Colors.white),
          hintText: '$type',
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
        onSaved: (input) {
            print("wager type saved: $type");
            if(type == "Minimum Wager"){
              widget.bet.set_min_wager = int.parse(input);
            }
            else if(type == "Maximum Wager"){
              widget.bet.set_max_wager = int.parse(input);
            }
            else if(type == "Standard Wager Amount"){
              widget.bet.set_standard_wager = int.parse(input);
              widget.bet.set_send_wager = int.parse(input);
            }
            else if(type == "Your Wager"){
              widget.bet.set_send_wager = int.parse(input);
            }

            //handle based on "type"
            //widget.bet.set_rec_wager = int.parse(input),
        }));
  }

  Widget _buildItem(BuildContext context, String label){ 
    return Container(
      margin: EdgeInsets.only(left: 15.0, right: 15.0),
      child: TextFormField(
        
        decoration: InputDecoration(
          fillColor: Colors.white,
          hintStyle: TextStyle(
              color: Colors.white, fontSize: 13),
          hintText: 'Enter Outcome $label',
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
        onSaved: (input) {
            if(label == "A"){
              print("Label: $input \n\n\n");
              print("List: ");
              print(tempOutcomes);
              tempOutcomes[0] = input;
              print(tempOutcomes[0]);
              
              widget.bet.set_outcomes = tempOutcomes;
            }
            else if(label == "B"){
              print("Label: $input \n\n\n");
              tempOutcomes.add(input);
              widget.bet.set_outcomes = tempOutcomes;
            }
            else if(label == "C"){
              print("Label: $input \n\n\n");
              tempOutcomes.add(input);
              widget.bet.set_outcomes = tempOutcomes;
            }
            else if(label == "D"){
              print("Label: $input \n\n\n");
              tempOutcomes.add(input);
              widget.bet.set_outcomes = tempOutcomes;
            }
            else if(label == "E"){
              print("Label: $input \n\n\n");
              tempOutcomes.add(input);
              widget.bet.set_outcomes = tempOutcomes;
            }

            //handle outcome based on value of "label"

        }    //widget.bet.set_outcome = input,
      ));
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }
}