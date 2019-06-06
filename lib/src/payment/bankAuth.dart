import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';
import 'package:login/prop-config.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:login/src/profile/Controller/updateController.dart';
import 'package:login/analtyicsController.dart';
import 'package:login/userController.dart';

String url = "http://10.0.2.2:5000/bankAuth";

class BankAuthPage extends StatelessWidget {
  BankAuthPage({Key key, this.analControl, @required this.user})
      : super(key: key);

  final userController user;
  final analyticsController analControl;

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold( 
      url: url,
    );
  }

}