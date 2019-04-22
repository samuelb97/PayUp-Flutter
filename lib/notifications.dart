import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

class Notif{
  Notif({
    this.context,
    this.flutterLocalNotificationsPlugin
  });

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  BuildContext context;

  void initNotif(){
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    var android = AndroidInitializationSettings('@mipmap/ic_launcher');

    var iOS = IOSInitializationSettings();

    var initSettings = InitializationSettings(android, iOS);

    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onSelectNotification: onSelectNotification
    );
    
  }

  Future onSelectNotification(String payload) async{
    debugPrint("payload : $payload");
    showDialog(
      context: context, 
      builder: (_) => AlertDialog(
        title: Text("Notification"),
        content: Text("$payload"),
      )
    );
     //Go To Notfication Screen
  }

  showNotification() async {
    var android = AndroidNotificationDetails("channel id", "channel Name", "channelDescription");
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show( 
      0, "This some Ass", "Flutter Local Notifiction", platform
    );
  }
}
