import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart' as prefix0;
import 'package:login/prop-config.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:login/src/profile/Controller/updateController.dart';
import 'package:login/analtyicsController.dart';
import 'package:login/userController.dart';
import 'package:http/http.dart';

String url = "http://10.0.0.33:5000/bankAuth";

class BankAuthPage extends StatelessWidget {
  BankAuthPage({Key key, this.analControl, @required this.user})
      : super(key: key);

  final userController user;
  final analyticsController analControl;

  @override
  Widget build(BuildContext context) {
    final client = Client();

    client.readBytes(url);

    return WebviewScaffold(
      appBar: AppBar(
        title: Text("Verify Bank Account"),
        backgroundColor: themeColors.accent2,
      ),
      url: url,
      withLocalStorage: true,
    );
  }

}