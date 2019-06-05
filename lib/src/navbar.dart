import 'package:flutter/material.dart';
import 'package:login/src/buddies/View/friends.dart';
import 'package:login/src/payment/payment.dart';
import 'package:login/src/home/home.dart';
import 'package:login/src/profile/View/profile.dart';
import 'package:login/src/messages/messages.dart';
import 'package:login/src/settings/settings.dart';
import 'package:login/src/search/search.dart';
import 'package:login/prop-config.dart';
import 'package:login/analtyicsController.dart';
import 'package:login/userController.dart';
import 'package:login/src/my_flutter_app_icons.dart';
import 'package:login/src/challenge/challenge_search.dart';
import 'package:login/src/notifications/notificationsview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';



class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class Home extends StatefulWidget {

  Home({
    Key key,
    this.analControl,
    @required this.user,
  }) : super(key: key);

  final drawerItems = [
    new DrawerItem("PayUp", Icons.home),
    new DrawerItem("Search", Icons.search),
    new DrawerItem("My Action", Icons.person),
    new DrawerItem("Friends", Icons.person_add),
    new DrawerItem("Groups", Icons.group),
    new DrawerItem("Messages", Icons.message),
    new DrawerItem("Payment", Icons.monetization_on),
    new DrawerItem("Settings", Icons.settings),
  ];

  final userController user;
   analyticsController analControl;
  
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  int msgCounter = 0;
  int notifCounter = 3;
  //int _index = 0;
  int _selectedDrawerIndex = 2;

  Widget _getDrawerItemWidget(int pos) {
    switch (pos) {
      
      //TODO: Case 0 (home), case 4 (groups), case 6 (payment)

      case 0:
        widget.analControl.sendAnalytics('nav_to_search');
        return HomePage(user: widget.user, analControl: widget.analControl);
        break;

      case 1:
        widget.analControl.sendAnalytics('nav_to_search');
        return SearchPage(user: widget.user, analControl: widget.analControl);
        break;
      
      case 2:
        widget.analControl.sendAnalytics('nav_to_profile');
        return ProfilePage(user: widget.user, analControl: widget.analControl);
        break;

      case 3:
        widget.analControl.sendAnalytics('nav_to_friends');
        return FriendsPage(user: widget.user, analControl: widget.analControl);
        break;

      case 5:
        widget.analControl.sendAnalytics('nav_to_messages');
        return MessagePage(user: widget.user, analControl: widget.analControl);
        //return MessagePage(user: widget.user, analControl: widget.analControl);
        break;

      case 6:
        widget.analControl.sendAnalytics('nav_to_payment');
        return PaymentPage(user: widget.user, analControl: widget.analControl);
        break;

      case 7:
        widget.analControl.sendAnalytics('nav_to_settings');
        return SettingsPage(user: widget.user, analControl: widget.analControl);
        break;

      default:
        return Text("Home");
        //return ProfilePage(user: widget.user, analControl: widget.analControl);
        break;
    }
  }

  void _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = TabController(
  //       vsync: this,
  //       length: pages.length,
  //       initialIndex: _index
  //   );
  // }

  
  @override
  Widget build(BuildContext context){
    print("\n\nUSER USER: ${widget.user.name}\n\n");
    return StreamBuilder( 
      stream: Firestore.instance.collection('users').document(widget.user.uid).snapshots(),
      builder: (context, snapshot){
        var userSnap = snapshot.data;
        widget.user.set_mod_Bets = userSnap["modBets"];
        widget.user.set_bets = userSnap["betIDs"];
        widget.user.set_friend_requests = userSnap["friend_requests"];
        var drawerOptions = <Widget>[];

        for (var i = 0; i < widget.drawerItems.length; i++) {
          var d = widget.drawerItems[i];
          drawerOptions.add(
            new ListTile(
              leading: new Icon(d.icon),
              title: new Text(d.title),
              selected: i == _selectedDrawerIndex,
              onTap: () => _onSelectItem(i),
            )
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: <Widget> [
                
                Spacer(),

                Text(widget.drawerItems[_selectedDrawerIndex].title, 
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Quantify', fontSize: 28.0),
                  ), 
                Spacer(),
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.notifications),
                      onPressed: (){
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => NotificationsPage(user: widget.user)));
                      },
                    ),
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
          drawer: Drawer(
                  
            child: ListView(
              children: <Widget>[ 
                Container(
                  color: themeColors.theme3,
                  padding: EdgeInsets.only(top: 20.0, left: 22.0, bottom: 15),
                  child: Row(children: <Widget>[
                    Material(
                      borderRadius: BorderRadius.all(Radius.circular(45.0)),
                      clipBehavior: Clip.hardEdge,
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                strokeWidth: 1.0,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                              ),
                              width: 90.0,
                              height: 90.0,
                              padding: EdgeInsets.only(left: 12.0, top: 6, right: 12, bottom: 12),
                            ),
                        imageUrl: '${widget.user.photoUrl}',
                        width: 90.0,
                        height: 90.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                    ),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                      Text(
                        '${widget.user.name}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '@${widget.user.username}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Container(height: 1, width: 125, color: themeColors.accent1),
                      Padding(
                        padding: EdgeInsets.all(4.0),
                      ),
                      Text(
                        '${Userinfo.age}: ${widget.user.age}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 2)),

                      FutureBuilder(
                        future: win_loss(context, widget.user),
                        initialData: " ",
                        builder: (BuildContext context, AsyncSnapshot<String> text) {
                          return new Container(
                            child: new Text(
                              "Record: " + text.data,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.0,
                              ),
                          ));
                        }),
                      Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                      Text(
                        '${Userinfo.balance}: ${widget.user.balance}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 15)),
                    ]),
                  Padding(padding: EdgeInsets.symmetric(vertical: 15)),]),
                  ),

                Column(children: drawerOptions,) ,
                
              ],
            ),
          ),
          body: _getDrawerItemWidget(_selectedDrawerIndex),
          
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
            child: Icon(MyFlutterApp.icon),
          ),
        );
      },
    );
  }
}
Future<String> win_loss(BuildContext context, userController user) async {
  int wins = 0;
  int losses = 0;
  for(var bets in user.bets){
    var docRef = await Firestore.instance.collection('bets').document(bets).get();
    if(docRef['winner'] == user.uid){
      wins++;
    }
    else if(docRef['loser'] == user.uid){
      losses++;
    }
  }
  return "$wins-$losses";
}