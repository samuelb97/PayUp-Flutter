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


class PaymentPage extends StatefulWidget {
  PaymentPage({Key key, this.analControl, @required this.user})
      : super(key: key);

  final userController user;
  final analyticsController analControl;

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends StateMVC<PaymentPage> {
  _PaymentPageState() : super(Controller()) {
    _con = Controller.con;
  }
  Controller _con;

  @override
  Widget build(BuildContext context) {
    widget.analControl.currentScreen('update_profile', 'updateProfileOver');
    return SingleChildScrollView( 
      child: Container(
        decoration: themeColors.linearGradient,
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * .875),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 24),),
            Row(children: <Widget>[
              Padding(padding: EdgeInsets.symmetric(horizontal: 10),),
              Container( 
                width: 75,
                height: 75,
                child: Image.asset('assets/payUpLogo1Beta.png'),
                
              ),              
              Padding(padding: EdgeInsets.symmetric(horizontal: 14),),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Headers.payup,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: themeColors.textWhite,
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 2),),
                  Text( 
                    "Balance: ${widget.user.balance}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w100,
                      color: themeColors.textWhite,
                    ),
                  )
                ]
              ),
              Spacer(),
            ]),
            Padding(padding: EdgeInsets.symmetric(vertical: 6.0),),
            Row(children: <Widget>[
              Spacer(),
              RaisedButton(
                color: themeColors.theme0,
                textColor: themeColors.accent3,
                child: Text("Deposit", 
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.w700,
                ),),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                        InputNumbersPage(
                          user: widget.user, 
                          analControl: widget.analControl,
                          depositOrCashOut: "Deposit",
                        ),
                        fullscreenDialog: true
                    )
                  );
                },
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 24.0),),
              RaisedButton( 
                color: themeColors.theme0,
                textColor: themeColors.accent3,
                child: Text("Cash Out", 
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                ),),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                        InputNumbersPage(
                          user: widget.user, 
                          analControl: widget.analControl,
                          depositOrCashOut: "Cash Out",
                        ),
                        fullscreenDialog: true
                    )
                  );
                },
              ),
              Spacer()
            ],),
            Container( 
              padding: EdgeInsets.only(left: 26, top: 10.0),
              alignment: Alignment.center,
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .9,
              ),
              child: Text( 
                "Money will only be used in PayUp if you have loaded your balance from your payment options, we will not take your money ever without asking",
                style: TextStyle(
                  color: themeColors.textWhite,
                  fontSize: 13,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 4.0),),
            payUpDivider(context),
            Padding(padding: EdgeInsets.symmetric(vertical: 4.0),),
            Text(
              "   Payment Methods",
              style: TextStyle(  
                color: themeColors.textWhite,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            paymentMethods(context, widget.user),
            FlatButton( 
              child: Container( 
                child: Text( 
                  "+ Add Payment Method",
                  style: TextStyle( 
                    color: themeColors.accent1,
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                  )
                ),
              ),
              onPressed: () {
                //TODO: add payment
                return Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => BankAuthPage(user: widget.user, analControl: widget.analControl),
                    fullscreenDialog: true
                  )
                );
              },
            ),
            
          ],
        )
      ),
    );
  }
}

Widget payUpDivider(BuildContext context){
  return Container(
    width: MediaQuery.of(context).size.width * .86,
    height: 1,
    color: themeColors.accent1,
  );
}

Widget paymentMethods(BuildContext context, userController user){
  
  List<Widget> paymentMethods = [];
  
  if(user.payMethods == null){
    return Container();
  }

  for (var card in user.payMethods){
    var temp = card.toString().split("::");
    var type = temp[0];
    var name = temp[1];
    var numbers = temp[2];
    print("Name: $name");

    paymentMethods.add(
      Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child:  FlatButton(
          child: Row(children: <Widget>[
            Card( 
              child: Container( 
                width: 80,
                height: 36,
                child: Image.asset('assets/banks/$name.PNG')
              )
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 4),),
            Text(
              "$name\n$type         ******$numbers",
              style: TextStyle(
                color: themeColors.textWhite,
                fontSize: 14,
              ),
            )
          ],),
          onPressed: () {
            print("Pressed $name");
            _showDialog(context, user, "$type::$name::$numbers");
            //Pop Up Window
          },
        ),
      )
    );
  }

  return Column(children: paymentMethods);

}

Future<void> deletePayMethod(user, payMethod){
  List temp = List.from(user.payMethods);
  temp.remove(payMethod);
  user.set_payMethods = temp;

  Firestore.instance.collection("users")
    .document("${user.uid}")
    .updateData({"payMethods": FieldValue.arrayRemove(["$payMethod"])});

  //Ping Flask Server to delete from Payment DB

}

void _showDialog(context, user, payMethod) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Remove Payment Method"),
        content: new Text("Are you sure you want to remove this payment method?"),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Yes"),
            onPressed: () {
              deletePayMethod(user, payMethod);
              deletePayFromServer(payMethod);
              Navigator.of(context).pop();
            },
          ),
          new FlatButton(
            child: new Text("No"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> deletePayFromServer(payMethod) async {

  var temp = payMethod.split("::");
  var type = temp[1];
  var mask = temp[2];

  SharedPreferences prefs = await SharedPreferences.getInstance();
  print(prefs.getString('jwt'));
  var token = prefs.getString('jwt');
  print(token);

  var response = await http.post(
    "${Backend.url}deletePayment", 
    headers: {
      'Authorization': "Bearer $token",
      'Content-Type': "application/json"
    },
    body: json.encode({
      "type": "$type",
      "mask": "$mask"
    }),
  );
  var parsed = json.decode(response.body);
  print("Delete From Server Parsed: $parsed");
}