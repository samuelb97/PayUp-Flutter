import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart' as prefix0;
import 'package:login/prop-config.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:login/src/profile/Controller/updateController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/analtyicsController.dart';
import 'package:login/userController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class BankAuthPage extends StatefulWidget {
  BankAuthPage({Key key, this.analControl, @required this.user})
      : super(key: key);

  final userController user;
  final analyticsController analControl;

  @override
  _BankAuthPageState createState() => _BankAuthPageState();
}

class _BankAuthPageState extends State<BankAuthPage>{
  final webPlug = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    webPlug.onUrlChanged.listen((String urlChange){
      print("URL Change");
      print(urlChange);
      var parsedUrl = parseUrl(urlChange);
      if(parsedUrl != "BankError"){
        print(parsedUrl);
        addBankPayMethod(widget.user, parsedUrl);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getToken(),
      builder: (BuildContext context, AsyncSnapshot<String> text) {
        print("\n\n\nTEXT: $text\n\n\n");
        return WebviewScaffold(
          appBar: AppBar(
            title: Text("Verify Bank Account"),
            backgroundColor: themeColors.accent2,
          ),
          url: "${Backend.url}bankAuth",
          withLocalStorage: true,
          headers: {'Authorization': "Bearer ${text.data}"},
        );
      }
    );
  }

}

String parseUrl(String toParse){
  var parsed = toParse.split("//");
  parsed = parsed[1].split("/");
  if(parsed[1] != "bank"){
    print("Not Success Url");
    return "BankError";
  }
  else {
    var name = parsed[2];
    var numbers = parsed[3];
    name = name.replaceAll('%20', ' ');
    return name + "::" + numbers;
  }
}

Future<void> addBankPayMethod(userController user, var bankMethod) async {
  List temp = List.from(user.payMethods);
  temp.add("Bank::$bankMethod");
  user.set_payMethods = temp;

  Firestore.instance.collection("users")
    .document("${user.uid}")
    .updateData({"payMethods": FieldValue.arrayUnion(["Bank::$bankMethod"])});
}

Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print(prefs.getString('jwt'));
  return prefs.getString('jwt');
}