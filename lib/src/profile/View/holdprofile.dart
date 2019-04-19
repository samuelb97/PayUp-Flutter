import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:login/prop-config.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:login/analtyicsController.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:login/src/profile/Controller/profileController.dart';
import 'package:login/userController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.analControl, @required this.user})
      : super(key: key);

  final userController user;
  final analyticsController analControl;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends StateMVC<ProfilePage>
    with TickerProviderStateMixin {
  _ProfilePageState() : super(Controller()) {
    _con = Controller.con;
    betSelect = TabController(length: 3, vsync: this, initialIndex: _index);
  }
  Controller _con;
  TabController betSelect;
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    betSelect = TabController(length: 3, vsync: this);
    widget.user.load_data_from_firebase();
    widget.analControl.currentScreen('profile_page', 'ProfilePageOver');
    betSelect.addListener(
        () => {print("\nListener: ${betSelect.index}\n$_index\n")});

    return Scaffold(
      body: Center(
        child: Container(
            decoration: themeColors.linearGradient,
            child: ListView(children: <Widget>[
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.0),
                  padding: EdgeInsets.only(top: 20.0),
                  child: Row(children: <Widget>[
                    Material(
                      borderRadius: BorderRadius.all(Radius.circular(45.0)),
                      clipBehavior: Clip.hardEdge,
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                strokeWidth: 1.0,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.green),
                              ),
                              width: 90.0,
                              height: 90.0,
                              padding: EdgeInsets.all(12.0),
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
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${widget.user.name}',
                            style: Theme.of(context)
                                .textTheme
                                .title
                                .merge(TextStyle(color: Colors.white)),
                            textAlign: TextAlign.center,
                          ),
                          Container(height: 1, width: 160, color: Colors.green),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                          ),
                          Text(
                            '${Userinfo.age}: ${widget.user.age}',
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .merge(TextStyle(color: Colors.white)),
                            // textAlign: TextAlign.left,
                          ),
                        ])
                  ])),
              StickyHeader(
                header: TabBar(
                  controller: betSelect,
                  labelColor: themeColors.accent1,
                  indicatorColor: Colors.blue,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 2.0,
                  isScrollable: false,
                  unselectedLabelColor: Colors.white,
                  tabs: [
                    Tab(text: "Open"),
                    Tab(text: "Closed"),
                    Tab(text: "Moderated"),
                  ],
                ),
                content: ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemBuilder: (context, index) => buildItem(
                        context,
                        widget.user.bets[index],
                        widget.user.uid,
                      ),
                ),
              )
            ])),
      ),
    );
  }
}

Widget buildItem(BuildContext context, betID, uid) {
  return Container();
}
