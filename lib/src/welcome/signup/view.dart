import 'package:flutter/material.dart';
import 'package:login/prop-config.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:login/analtyicsController.dart';
import 'controller.dart';

class SignUpPage extends StatefulWidget {
  final analyticsController analControl;

  SignUpPage({Key key, this.analControl})
      : super(key: key);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends StateMVC<SignUpPage> {
  _SignUpPageState() : super(Controller()) {
    _con = Controller.con;
  }
  Controller _con;

  @override
  Widget build(BuildContext context) {
    widget.analControl.currentScreen('Sign_Up', 'signUpOver');
    return Scaffold(
        appBar: AppBar(
          title: Text(Prompts.signup),
          backgroundColor: themeColors.accent2,
        ),
        body: Container(
          decoration: themeColors.linearGradient,
          child: Center(
            child: Form(
              key: _con.registerformkey,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  Text(
                    "Money won is twice as sweet as money earned",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Aguafina'
                    ),
                  ),
                  SizedBox(height: 25.0),
                  TextFormField(
                    validator: (input) {
                      if(input.isEmpty){
                        return Prompts.type_username;
                      } 
                    },
                    onSaved: (input) => _con.set_username = input,
                    style: TextStyle(color: Colors.white),
                    autofocus: false,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      hintStyle: TextStyle(color: Colors.white),
                      hintText: 'Username',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: const BorderSide(color: Colors.white)
                      ),
                    ),
                  ),
                  SizedBox(height: 17.0),
                  TextFormField(
                    validator: (input) {
                      if(input.isEmpty){
                        return Prompts.name;
                      } 
                    },
                    onSaved: (input) => _con.set_name = input,
                    style: TextStyle(color: Colors.white),
                    autofocus: false,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      hintStyle: TextStyle(color: Colors.white),
                      hintText: 'Full Name',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: const BorderSide(color: Colors.white)
                      ),
                    ),
                  ),
                  SizedBox(height: 17.0),
                  TextFormField(
                    validator: (input) {
                      if(!isNumeric(input)){
                        return Prompts.age;
                      } 
                    },
                    onSaved: (input) => _con.set_age = input,
                    style: TextStyle(color: Colors.white),
                    autofocus: false,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      hintStyle: TextStyle(color: Colors.white),
                      hintText: 'Age',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: const BorderSide(color: Colors.white)
                      ),
                    ),
                  ),
                  SizedBox(height: 17.0),
                  TextFormField(
                    validator: (input) {
                      if(input.isEmpty){
                        return Prompts.type_email;
                      } 
                    },
                    onSaved: (input) => _con.set_email = input,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      hintStyle: TextStyle(color: Colors.white),
                      hintText: 'Email',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: const BorderSide(color: Colors.white)
                      ),
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
                  TextFormField(
                    validator: (input) {
                    if(input.length < 6){
                      return Prompts.passwrd_valid;
                      } 
                    },
                    onSaved: (input) => _con.set_password2 = input,
                    style: TextStyle(color: Colors.white),
                    autofocus: false,
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      hintStyle: TextStyle(color: Colors.white),
                      hintText: Prompts.passwrd2,
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
                      Controller.signUp(context, widget.analControl);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: EdgeInsets.all(12),
                    color: themeColors.accent2,
                    child: Text('Sign Up', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(height: 25.0),
                ]
              )
            )
          )
        )
      );
  }

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }
}