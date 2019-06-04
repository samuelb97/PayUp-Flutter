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
            child: Column(children: <Widget>[
              
            ],)
          ),
        )

    );
  }
}
