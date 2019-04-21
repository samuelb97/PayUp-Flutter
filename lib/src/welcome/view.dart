import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/prop-config.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'controller.dart';
import 'package:login/analtyicsController.dart';
import 'forgot.dart';

class WelcomePage extends StatefulWidget {
  final analyticsController analControl;

  WelcomePage({this.analControl});
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends StateMVC<WelcomePage> {
  String inp;
  _WelcomePageState() : super(Controller()) {
    _con = Controller.con;
  }
  Controller _con;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Headers.payup + Prompts.login),
        backgroundColor: themeColors.accent2,
        centerTitle: true,
      ),
      backgroundColor: themeColors.theme2,
      body: Container( 
        decoration: themeColors.linearGradient,
        child: Center(
          child: Form(
              key: _con.formkey,
              child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  children: <Widget>[
                    Container(
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 60.0,
                          child: Image.asset('assets/logo1.png'),
                    )),
                    SizedBox(height: 25.0),
                    TextFormField(
                      validator: (input) {
                        if(input.isEmpty){
                          return Prompts.type_email;
                        } 
                      },
                      onSaved: (input) => _con.set_email = input,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.white),
                      autofocus: false,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: Headers.email,
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                            borderSide: const BorderSide(color: Colors.white)),
                      ),
                    ),
                    SizedBox(height: 17.0),
                    TextFormField(
                      validator: (input) {
                      if(input.length < 6){
                        return Prompts.passwrd_valid;
                        } 
                      },
                      onSaved: (input) => _con.set_password = input,
                      style: TextStyle(color: Colors.white),
                      autofocus: false,
                      obscureText: true,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: Prompts.passwrd,
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                            borderSide: const BorderSide(color: Colors.white)),
                      ),
                    ),
                    SizedBox(height: 17.0),
                    RaisedButton(
                      onPressed: () {
                        widget.analControl.currentScreen(
                          'login_page', 
                          'Log_inPageOver');
                        Controller.signIn(context, widget.analControl);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: EdgeInsets.all(12),
                      color: themeColors.accent2,
                      child: Text(Prompts.login,
                          style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          child: Text(
                            'Forgot password',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: updateDialog
                        ),
                        FlatButton(
                          child: Text(
                            'Create Account',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            widget.analControl
                                .sendAnalytics('sign_up');
                            widget.analControl.currentScreen(
                                'welcome_page', 'WelcomePageOver');
                            Controller.NavigateToSignUp(
                                context, widget.analControl);
                          },
                        )
                      ],
                    )
                  ]))),
      )
    );
  }
  Future<bool> updateDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Reset Password', style: TextStyle(fontSize: 15.0)),
            content: Container(
              height: 125.0,
              width: 150.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 5.0),
                  TextField(
                    decoration: InputDecoration(hintText: 'Enter Email'),
                    onChanged: (value) {
                      this.inp = value;
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Reset'),
                textColor: Colors.blue,
                onPressed: () {
                  resetPassword(inp);
                  Navigator.of(context).pop();
                  _showDialog(inp);
                },
              )
            ],
          );
        });
  }
  
  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}

void _showDialog(String inp){
  showDialog(
    context: context,
    builder: (BuildContext context){
      return AlertDialog(title: new Text('A password reset link has been sent to $inp', textScaleFactor: 0.9),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Close"),
            onPressed: (){
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}

}
