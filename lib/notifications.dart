import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class Notif{

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;


  init(){
    var initSettingsAndroid = AndroidInitializationSettings('app_icon');

    var initSettingsIOS = IOSInitializationSettings();

    var initSettings = InitializationSettings(
      initSettingsAndroid, initSettingsIOS);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(initSettings,
      onSelectNotification: onSelectNotification);
    
  }

  Future onSelectNotification(String payload) async{
    //Go To Notfication Screen
  }
}
