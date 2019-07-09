import 'package:flutter/material.dart';
import 'package:login/prop-config.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:login/src/profile/Controller/updateController.dart';
import 'package:login/analtyicsController.dart';
import 'package:login/userController.dart';
import 'package:login/src/payment/bankAuth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './inputNumber.dart';


class InputNumbersPage extends StatefulWidget {
  InputNumbersPage({
    Key key, this.analControl, 
    @required this.user, 
    @required this.depositOrCashOut
  }): super(key: key);

  final userController user;
  final analyticsController analControl;
  final String depositOrCashOut;

  @override
  _InputNumbersPageState createState() => _InputNumbersPageState();
}

class _InputNumbersPageState extends State<InputNumbersPage> {
  final cashController = TextEditingController();

  @override
  Widget build(context){
    return Scaffold(
    appBar: AppBar(
      title: Container(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * .19),
        child: Text(widget.depositOrCashOut, 
          textAlign: TextAlign.center,
          style: TextStyle(
            color: themeColors.textWhite,
            fontSize: 24
          ),
        ),
      ),
      backgroundColor: themeColors.accent2,
    ),
    body: Container( 
      decoration: themeColors.linearGradient,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
        Padding(padding: EdgeInsets.symmetric(vertical: 14.0),),
        Container( 
          width: MediaQuery.of(context).size.width * .8,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: themeColors.theme0,
          ),
          child: Form(
            child: TextFormField(
              controller: cashController,
              style: TextStyle(fontSize: 24, color: themeColors.textWhite),
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                hintText: "0.00",
                contentPadding: EdgeInsets.only(top: 18.0, right: 8)
              ),
              keyboardType: TextInputType.number,
            )
          )
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 12.0),),
        Container( 
          width: MediaQuery.of(context).size.width * .6,
          height: 40,
          decoration: BoxDecoration(  
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: FlatButton( 
            child: Text(widget.depositOrCashOut, 
              style: TextStyle(
                color: themeColors.textWhite,
                fontSize: 20,
              ),
            ),
            color: themeColors.accent2,
            onPressed: (){
              //Deposit in backend
              if (widget.depositOrCashOut == "Cash Out") {
                Withdraw();
              } else {
                Deposit();
              }
            },
          ),
        ),
      ],),
    ));
  }
  Future<void> Deposit() async {
    String amount = cashController.text;
    print(amount);
    if (!isNumeric(amount)){
      _showDialog(context);
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('jwt');
    print(token);

    var response = await http.post(
      "${Backend.url}deposit", 
      headers: {
        'Authorization': "Bearer $token",
        'Content-Type': "application/json"
      },
      body: json.encode({
        "amount": "$amount"
      }),
    );
    var parsed = json.decode(response.body);
    print("Server Returned After Deposit: $parsed");
    
  }

  Future<void> Withdraw() async {
    String amount = cashController.text;
    print(amount);
    if (!isNumeric(amount)){
      _showDialog(context);
      return;
    }
    
  }
}

bool isNumeric(String s) {
  if(s == null) {
    return false;
  }
  return double.parse(s, (e) => null) != null;
}

void _showDialog(context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Invalid Number"),
        content: new Text("Please enter a valid number or decimal"),
        actions: <Widget>[
          new FlatButton(
            child: new Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

