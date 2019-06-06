import 'package:flutter/material.dart';
import 'package:login/prop-config.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:login/src/profile/Controller/updateController.dart';
import 'package:login/analtyicsController.dart';
import 'package:login/userController.dart';
import 'package:login/src/payment/bankAuth.dart';

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
            Padding(padding: EdgeInsets.symmetric(vertical: 8.0),),
            Container( 
              padding: EdgeInsets.only(left: 26),
              alignment: Alignment.center,
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .9,
              ),
              child: Text( 
                "Money will only used in PayUp if you have loaded your balance from your payment options, we will not take your money ever without asking",
                style: TextStyle(
                  color: themeColors.textWhite,
                  fontSize: 12,
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
          },
        ),
      )
    );
  }

  return Column(children: paymentMethods);

}