import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuddyShowcase extends StatefulWidget {
  BuddyShowcase(this.document,{
    Key key,
    //this.document, 
  //  {
  //  @required this.avatarTag,
  //}
  });
 
  final DocumentSnapshot document;

  @override
  _BuddyShowcaseState createState() => new _BuddyShowcaseState();
}

class _BuddyShowcaseState extends State<BuddyShowcase>
    with TickerProviderStateMixin {
  List<Tab> _tabs;
  List<Widget> _pages;
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _tabs = [
      new Tab(text: 'Portfolio'),
      new Tab(text: 'Skills'),
      new Tab(text: 'Articles'),
    ];
    _controller = new TabController(
      length: _tabs.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(12.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Text(
            'About me...',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
          new SizedBox.fromSize(
            size: const Size.fromHeight(300.0),
            child: new Text(
              '${widget.document['aboutMe']}',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}