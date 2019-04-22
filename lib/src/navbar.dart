import 'package:flutter/material.dart';
import 'package:login/bottom_navy_bar.dart';
import 'package:login/src/buddies/View/friends.dart';
import 'package:login/src/profile/View/profile.dart';
import 'package:login/src/messages/messages.dart';
import 'package:login/src/settings/settings.dart';
import 'package:login/src/search/search.dart';
import 'package:login/prop-config.dart';
import 'package:login/analtyicsController.dart';
import 'package:login/userController.dart';
import 'package:login/src/challenge/challenge_search.dart';
import 'package:login/notifications.dart';

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

  int msgCounter = 0;
  int notifCounter = 3;
  int _index = 0;
  TabController _controller;

  List<String> pages = [
    Headers.profile,
    Headers.friends,
    Headers.messages,
    Headers.search,
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
    print("\n\nUSER USER: ${widget.user.name}\n\n");
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget> [
            Text(Headers.payup),
            Spacer(),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Icon(Icons.notifications),
                Builder(
                  builder: (context) {
                    if(notifCounter > 0) {
                      return Positioned( 
                        right: 0,
                        child: Container( 
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration( 
                            color: Colors.red[300],
                            borderRadius: BorderRadius.circular(6)
                          ),
                          constraints: BoxConstraints( 
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            "$notifCounter",
                            style: TextStyle( 
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }
                )
              ],
            )
          ]
        ),
        backgroundColor: themeColors.accent2,
      ),
      body: TabBarView(
        controller: _controller,
        children: pages.map((title) {
          switch (title) {
            case Headers.profile:
              widget.analControl.sendAnalytics('nav_to_profile');
              return ProfilePage(user: widget.user, analControl: widget.analControl);
              break;

            case Headers.friends:
              widget.analControl.sendAnalytics('nav_to_friends');
              return FriendsPage(user: widget.user, analControl: widget.analControl);
              break;

            case Headers.messages:
              widget.analControl.sendAnalytics('nav_to_messages');
              return MessagePage(user: widget.user, analControl: widget.analControl);
              //return MessagePage(user: widget.user, analControl: widget.analControl);
              break;

            case Headers.search:
              widget.analControl.sendAnalytics('nav_to_search');
              return SearchPage(user: widget.user, analControl: widget.analControl);
              break;

            case Headers.settings:
              widget.analControl.sendAnalytics('nav_to_settings');
              return SettingsPage(user: widget.user, analControl: widget.analControl);
              break;

            default:
              return Text("Profile");
              //return ProfilePage(user: widget.user, analControl: widget.analControl);
              break;
          }
        }).toList(),
      ),
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: themeColors.theme1,
        onItemSelected: (index) => setState(() {
            _index = index;
            _controller.animateTo(_index);
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.portrait),
            title: Text(Headers.profile),
            inactiveColor: themeColors.accent3,
            activeColor: themeColors.accent2,
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.people),
              title: Text(Headers.friends),
              inactiveColor: themeColors.accent3,
              activeColor: themeColors.accent2,
          ),
          BottomNavyBarItem(
            icon:  Stack(
              children: <Widget>[
                Icon(Icons.message),
                Builder(
                  builder: (context) {
                    if(msgCounter > 0) {
                      return Positioned( 
                        right: 0,
                        child: Container( 
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration( 
                            color: Colors.red[300],
                            borderRadius: BorderRadius.circular(6)
                          ),
                          constraints: BoxConstraints( 
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            "$msgCounter",
                            style: TextStyle( 
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }
                )
              ],
            ),
            title: Text(Headers.messages),
            inactiveColor: themeColors.accent3,
            activeColor: themeColors.accent2,
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.search),
              title: Text(Headers.search),
              inactiveColor: themeColors.accent3,
              activeColor: themeColors.accent2,
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.settings),
              title: Text(Headers.settings),
              inactiveColor: themeColors.accent3,
              activeColor: themeColors.accent2,
          ),
          
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          return Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => ChallengeSearchPage(user: widget.user, analControl: widget.analControl),
              fullscreenDialog: true
            )
          );
        }, //to challenge search
        tooltip: 'Challenge Reqeust',
        backgroundColor: themeColors.accent2,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}