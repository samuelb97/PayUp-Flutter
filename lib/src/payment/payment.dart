import 'package:flutter/material.dart';
import 'package:login/prop-config.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:login/src/profile/Controller/updateController.dart';
import 'package:login/analtyicsController.dart';
import 'package:login/userController.dart';

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
    return Scaffold(
        appBar: AppBar(
          title: Text(Headers.payment),
          backgroundColor: themeColors.theme2,
        ),
        body: SingleChildScrollView( 
          child: Container( 
            decoration: themeColors.linearGradient,
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 10),),
                Row(children: <Widget>[
                  Padding(padding: EdgeInsets.symmetric(horizontal: 4),),
                  Material( 
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: DecoratedBox( 
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("../../../assets/payUpLogo1Beta.png")
                        )
                      )
                    )
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 4),),
                  Column(children: <Widget>[
                    Text(
                      Headers.payup,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: themeColors.textWhite,
                      ),
                    ),
                    Text( 
                      "Balance: ${widget.user.balance}",
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        color: themeColors.textWhite,
                      ),
                    )
                  ]),
                  Spacer(),
                ]),
                Padding(padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4),),
                Text( 
                  "Money will only used in PayUp if you have loaded your balance from your payment options, we will not take your money ever without asking"
                )
              ],
            )
          ),
        )

    );
  }
}
