import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:login/prop-config.dart';
import 'package:login/analtyicsController.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:login/src/profile/Controller/profileController.dart';
import 'package:login/userController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/src/profile/View/items/open.dart';
import 'package:login/src/profile/View/items/closed.dart';
import 'package:login/src/profile/View/items/pending.dart';
import 'package:intl/intl.dart';
import 'package:login/src/profile/View/items/profileInfo.dart';

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
            SliverFixedExtentList(
              itemExtent: 150.0,
              delegate: SliverChildListDelegate([
                buildProfileDelegate(context, widget.user),
              ],),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: TestTabBarDelegate(controller: _tabController),
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
        print("\nScroll Update 1\n");
        _innerListIsScrolled = true;
      });
    } else if (_innerListIsScrolled &&
        widget.scrollController.position.extentAfter > 0.0) {
      setState(() {
        print("\nScroll Update 2\n");
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
      children: List<Widget>.generate(tabCount, (int index) { //creates a lists of 3 elements (tab count)
        print("Gen index: $index\n");
        print("User Bets Length: ${widget.user.bets.length}");
        if(index == 0) {
          return ListView.builder(               //Open Bets
            itemCount: widget.user.bets.length,
            key: PageStorageKey<int>(index),
                 //Makes two keys for two lists
            itemBuilder: (cntxt, idx)
              => buildOpenBet(cntxt, idx, widget.user)
          );
        }
        else if(index == 1){
          return ListView.builder(              //Closed Bets
            itemCount: widget.user.bets.length,
            key: PageStorageKey<int>(index),     //Makes two keys for two lists
            itemBuilder: (cntxt, idx) 
              => buildClosedBet(cntxt, idx, widget.user)
          );
        }
        else{
          print("Before ListView Pending");
          return ListView.builder(              //Pending
            itemCount: widget.user.bets.length,
            padding: EdgeInsets.only(bottom: 260),
            key: PageStorageKey<int>(index),     //Makes two keys for two lists
            itemBuilder: (cntxt, idx) 
             => buildPendingBet(cntxt, idx, widget.user),
          );
        }
      }))
    );
  }
}

// searchByName(String betId){
//   return Firestore.instance.collection('bets').document(betId);
// }
