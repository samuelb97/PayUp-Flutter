import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:login/prop-config.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:login/analtyicsController.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:login/src/profile/Controller/profileController.dart';
import 'package:login/userController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/src/profile/View/items/open.dart';
import 'package:login/src/profile/View/items/closed.dart';
import 'package:login/src/profile/View/items/pending.dart';
import 'package:intl/intl.dart';

Widget buildProfileDelegate(BuildContext context, userController user){

    return Container(
      color: themeColors.theme3,
      padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
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
                  padding: EdgeInsets.all(12.0),
                ),
            imageUrl: '${user.photoUrl}',
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
            '${user.name}',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            '@${user.username}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey
            ),
            textAlign: TextAlign.center,
          ),
          Container(height: 1, width: 160, color: themeColors.accent1),
          Padding(
            padding: EdgeInsets.all(4.0),
          ),
          Text(
            '${Userinfo.age}: ${user.age}',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 2)),
          Text(
            '${Userinfo.record}: ${user.wins}-${user.loses}',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 2)),
          Text(
            '${Userinfo.balance}: ${user.balance}',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white
            ),
          ),
        ])
      ]));
}

const tabCount = 3;

class TestTabBarDelegate extends SliverPersistentHeaderDelegate {
  TestTabBarDelegate({this.controller});

  final TabController controller;
  var height = 50.0;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: themeColors.theme3,
      padding: EdgeInsets.only(top: 10),
      height: height,
      child: TabBar(
        controller: controller,
        key: PageStorageKey<Type>(TabBar),
        indicatorColor: themeColors.accent1,
        indicatorWeight: 2.0,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: <Widget>[
          Text(
            "Open",
            style: TextStyle(color: themeColors.accent1, fontSize: 16)
          ),
          Text(
            "Closed",
            style: TextStyle(color: themeColors.accent1, fontSize: 16)
          ),
          Text(
            "Pending",
            style: TextStyle(color: themeColors.accent1, fontSize: 16)
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant TestTabBarDelegate oldDelegate) {
    print("\nRebuild Tab: ${controller.index}");
    return oldDelegate.controller != controller;
  }
}

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
  ScrollController _scrollController = new ScrollController();

  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: tabCount, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: themeColors.linearGradient2,
      child: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new SliverFixedExtentList(
              itemExtent: 150.0,
              delegate: SliverChildListDelegate([
                buildProfileDelegate(context, widget.user),
              ],),
            ),
            new SliverPersistentHeader(
              pinned: true,
              delegate: new TestTabBarDelegate(controller: _tabController),
            ),
          ];
        },
        body: TestHomePageBody(
          tabController: _tabController,
          scrollController: _scrollController,
          user: widget.user,
        ),
      ), 
    );
  }
}

class TestHomePageBody extends StatefulWidget {
  TestHomePageBody({
    this.scrollController, 
    this.tabController,
    this.user,
  });

  final ScrollController scrollController;
  final TabController tabController;
  final userController user;

  TestHomePageBodyState createState() => TestHomePageBodyState();
}

class TestHomePageBodyState extends State<TestHomePageBody> {
  Key _key = PageStorageKey({});
  bool _innerListIsScrolled = false;

  void _updateScrollPosition() {
    if (!_innerListIsScrolled &&
        widget.scrollController.position.extentAfter == 0.0) {
      setState(() {
        _innerListIsScrolled = true;
      });
    } else if (_innerListIsScrolled &&
        widget.scrollController.position.extentAfter > 0.0) {
      setState(() {
        _innerListIsScrolled = false;
        // Reset scroll positions of the TabBarView pages
        _key = PageStorageKey({});
      });
    }
  }

  @override
  void initState() {
    widget.scrollController.addListener(_updateScrollPosition);
    super.initState();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_updateScrollPosition);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: themeColors.linearGradient,
      child: TabBarView(
      controller: widget.tabController,
      key: _key,
      children: List<Widget>.generate(tabCount, (int index) { //creates a lists of 2 elements (tab count)
        print("Gen index: $index\n");
        if(index == 0) {
          return ListView.builder(
            itemCount: widget.user.bets.length,
            key: PageStorageKey<int>(index),
                 //Makes two keys for two lists
            itemBuilder: (BuildContext cntxt, int idx)
              => buildOpenBet(cntxt, idx, widget.user)
          );
        }
        else if(index == 1){
          return ListView.builder(
            itemCount: widget.user.bets.length,
            key: PageStorageKey<int>(index),     //Makes two keys for two lists
            itemBuilder: (cntxt, idx) 
              => buildClosedBet(cntxt, idx, widget.user)
          );
        }
        else{
          return ListView.builder(
            itemCount: widget.user.bets.length,
            key: PageStorageKey<int>(index),     //Makes two keys for two lists
            itemBuilder: (cntxt, idx) 
             => buildPendingBet(cntxt, idx, widget.user)
          );
        }
      }))
    );
  }
}

// searchByName(String betId){
//   return Firestore.instance.collection('bets').document(betId);
// }
