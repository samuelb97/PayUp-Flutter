import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:login/prop-config.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:login/analtyicsController.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:login/src/profile/Controller/profileController.dart';
import 'package:login/userController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
            '${Userinfo.age}: ${user.age}',
            style: Theme.of(context)
                .textTheme
                .body1
                .merge(TextStyle(color: Colors.white)),
            // textAlign: TextAlign.left,
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
              => buildOpenBet(cntxt, idx)
          );
        }
        else if(index == 1){
          return ListView.builder(
            itemCount: widget.user.bets.length,
            key: PageStorageKey<int>(index),     //Makes two keys for two lists
            itemBuilder: (cntxt, idx) 
              => buildClosedBet(cntxt, idx)
          );
        }
        else{
          return ListView.builder(
            itemCount: widget.user.bets.length,
            key: PageStorageKey<int>(index),     //Makes two keys for two lists
            itemBuilder: (cntxt, idx) 
             => buildPendingBet(cntxt, idx)
          );
        }
      }))
    );
  }
  Widget buildOpenBet(BuildContext context, int index) {
    print("\n\nLength: ${widget.user.bets.length}\nIndex $index\n\n");
    if(index >= widget.user.bets.length){
      return Container();
    }
    else{
      return Container(
        child: Text("Open $index, Bet: ${widget.user.bets[index]}")
       );
    }
  }

  Widget buildClosedBet(BuildContext context, int index) {
    return Container(
      child: Text("Closed $index"),
    );
  }

  Widget buildPendingBet(BuildContext context, int index) {
    return Container(
      child: Text("Pending $index"),
    );
  }

  searchByName(String betId){
    return Firestore.instance.collection('bets').document(betId);
  }
}

// Widget buildOpenBet(BuildContext context, int index) {
//   if(index >= )
//   return Container(
//     child: Text("Open $index"),
//   );
// }

// Widget buildClosedBet(BuildContext context, int index) {
//   return Container(
//     child: Text("Closed $index"),
//   );
// }

// Widget buildPendingBet(BuildContext context, int index) {
//   return Container(
//     child: Text("Pending $index"),
//   );
// }

// searchByName(String betId){
//   return Firestore.instance.collection('bets').document(betId);
// }
