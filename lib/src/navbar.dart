import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:login/src/buddies/View/buddies.dart';
import 'package:login/src/profile/View/profile.dart';
import 'package:login/src/messages/messages.dart';
import 'package:login/src/settings/settings.dart';
import 'package:login/prop-config.dart';
import 'package:login/analtyicsController.dart';
import 'package:login/userController.dart';

class Home extends StatefulWidget {

  Home({
    Key key,
    this.analControl,
    @required this.user,
  }) : super(key: key);

  final userController user;
  final analyticsController analControl;
  
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  int _index = 0;
  TabController _controller;

  List<String> pages = [
    Headers.profile,
    Headers.messages,
    Headers.findBuddies,
    Headers.settings,
  ];

  @override
  void initState() {
    super.initState();
    _controller = TabController(
        vsync: this,
        length: pages.length,
        initialIndex: _index
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(Headers.spotBuddy),
        backgroundColor: Colors.lightGreen,
      ),
      body: TabBarView(
        controller: _controller,
        children: pages.map((title) {
          switch (title) {
            case Headers.profile:
              widget.analControl.sendAnalytics('nav_to_profile');
              return ProfilePage(user: widget.user, analControl: widget.analControl);
              break;
            
            case Headers.messages:
              widget.analControl.sendAnalytics('nav_to_messages');
              return MessagePage(user: widget.user, analControl: widget.analControl);
              //return MessagePage(user: widget.user, analControl: widget.analControl);
              break;

            case Headers.findBuddies:
              widget.analControl.sendAnalytics('nav_to_buddies');
              return BuddiesPage(user: widget.user, analControl: widget.analControl);
              break;

            case Headers.settings:
              widget.analControl.sendAnalytics('nav_to_settings');
              return SettingsPage(user: widget.user, analControl: widget.analControl);
              break;

            default:
              return ProfilePage(user: widget.user, analControl: widget.analControl);
              break;
          }
        }).toList(),
      ),
      bottomNavigationBar: BottomNavyBar(
        onItemSelected: (index) => setState(() {
            _index = index;
            _controller.animateTo(_index);
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.portrait),
            title: Text(Headers.profile),
            activeColor: Colors.green,
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.message),
              title: Text(Headers.messages),
              activeColor: Colors.green,
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.people),
              title: Text(Headers.findBuddies),
              activeColor: Colors.green,
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.settings),
              title: Text(Headers.settings),
              activeColor: Colors.green,
          ),
        ],
      )
    );
  }
}