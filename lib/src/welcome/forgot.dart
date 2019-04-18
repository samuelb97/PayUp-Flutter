import 'package:flutter/material.dart';
import 'package:login/analtyicsController.dart';
import 'package:login/prop-config.dart';

class Forgot extends StatefulWidget {
  static String tag = 'register';

  final analyticsController thisAnalyticsController;

  Forgot({this.thisAnalyticsController});

  @override
  _ForgotState createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  @override
  Widget build(BuildContext context) {
    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        fillColor: Colors.white,
        hintStyle: TextStyle(color: Colors.white),
        hintText: 'User ID or Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: const BorderSide(color: Colors.white)),
      ),
    );

    final reg = RaisedButton(
      onPressed: _registerPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      padding: EdgeInsets.all(12),
      color: themeColors.accent2,
      child: Text('Reset Password', style: TextStyle(color: Colors.white)),
    );

    return Scaffold(
        appBar: new AppBar(
          title: Text("Reset Password"),
          backgroundColor: themeColors.accent2,
          centerTitle: true,
        ),
        body: Container(
          decoration: themeColors.linearGradient,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                email,
                SizedBox(height: 17.0),
                reg,
                SizedBox(height: 25.0),
              ],
            ),
          ),
        ));
  }
}

_registerPressed() async {}//TODO: send new password
