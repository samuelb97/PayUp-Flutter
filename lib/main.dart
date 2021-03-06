import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login/src/welcome/view.dart';
import 'package:login/prop-config.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:login/analtyicsController.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  .then((_){
    runApp(MyApp());
  });
 } // This widget is the root of your application.

class MyApp extends StatelessWidget {
  Future <Map<PermissionGroup, PermissionStatus>> permissions = 
    PermissionHandler().
      requestPermissions([PermissionGroup.location, PermissionGroup.mediaLibrary]);
  
  Function() {
    print(PermissionStatus.values);
  }

  final _analyticsController = analyticsController();

  @override
  Widget build(BuildContext context) {
    var materialApp = MaterialApp(
      title: Headers.payup,
      theme: ThemeData(
        primarySwatch: themeColors.theme,
        fontFamily: 'Nunito',
      ),
      navigatorObservers: <NavigatorObserver>[_analyticsController.observer],
      home: WelcomePage(
        analControl: _analyticsController),
    );
    return materialApp;
  }
}


