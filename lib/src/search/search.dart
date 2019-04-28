import 'package:flutter/material.dart';
import 'package:login/userController.dart';
import 'package:login/analtyicsController.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/src/search/searchservice.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:login/prop-config.dart';
import 'package:login/src/buddies/View/details_page.dart';
import 'package:login/src/buddies/View/non_friend_details_page.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key, this.analControl, @required this.user})
      : super(key: key);

  final userController user;
  final analyticsController analControl;
  //final TextEditingController _controller = new TextEditingController();

  @override
  State createState() => _SearchPageState();
}

class _SearchPageState extends StateMVC<SearchPage> {
  var queryResultSet = [];
  var tempSearchStore = [];
  var val;
  final TextEditingController _controller = new TextEditingController();

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; i++) {
          if (docs.documents[i].documentID !=
              widget.user.uid) 
            queryResultSet.add(docs.documents[i].data);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['name'].startsWith(capitalizedValue))
          setState(() {
            tempSearchStore.add(element);
          });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Container(
                decoration: themeColors.linearGradient,
                child: ListView(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      
                      controller: _controller,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          
                        
                        fillColor: Colors.white,
                           
                          prefixIcon: IconButton(
                            color: Colors.white,
                            icon: Icon(Icons.cancel),
                            iconSize: 20.0,
                            onPressed: () {
                              _controller.clear();
                              initiateSearch("");
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                            },
                          ),
                          contentPadding: EdgeInsets.only(left: 25.0),
                          hintStyle: TextStyle(color: Colors.white),
                          hintText: 'Search by name',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            borderSide: BorderSide(color: themeColors.accent1)
                          ),
                        ),
                              
                              
                      onChanged: (val) {
                        initiateSearch(val);
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ListView(
                    //padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),

                    primary: false,
                    shrinkWrap: true,
                    children: tempSearchStore.map((element) {
                      return buildResultButton(element, context, widget.user);
                    }).toList(),
                  )
                ]))));
  }
}

Widget buildResultButton(data, context, user) {
  return FlatButton(
    child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Material(
              child: CachedNetworkImage(
                placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                      width: 50.0,
                      height: 50.0,
                      padding: EdgeInsets.all(15.0),
                    ),
                imageUrl: '${data['photoUrl']}',
                width: 50.0,
                height: 50.0,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              clipBehavior: Clip.hardEdge,
            ),
            Flexible(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        '${data['name']}',
                        style: TextStyle(color: Colors.white),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                    ),
                    Container(
                      child: Text(
                        '@${data['username']}',
                        style: TextStyle(color: Colors.grey),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                    )
                  ],
                ),
                margin: EdgeInsets.only(left: 20.0),
              ),
            ),
            // SizedBox(
            //   height:10.0,
            //   child: new Center(
            //   child: new Container(
            //     margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
            //     height: 5.0,
            //     decoration: themeColors.linearGradient3,
            //   ),
            //   ),
            // ),
          ],
        ),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width,
          color: themeColors.accent1,
          margin: EdgeInsets.only(top: 15.0),
        ),
      ],
    ),
    onPressed: () {
      print("pressed");
      print(data['name']);

      SearchService().searchByUsername(data['username']).then((QuerySnapshot docs){
        if(user.friends.contains(docs.documents[0].documentID)){
          NavigateToFriendDetails(docs.documents[0], user, context);
        }
        else{
          NavigateToUserDetails(docs.documents[0], user, context);
        }
      });


      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => Chat(
      //               peerId: document.documentID,
      //               peerName: document['name'],
      //               peerAvatar: document['photoUrl'],
      //               analControl: analControl,
      //               user: user,
      //             ),
      //         fullscreenDialog: true));
    },

    color: Colors.transparent,
    padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
    // shape:
    //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  );
}

Future<void> NavigateToFriendDetails(DocumentSnapshot document, userController user, BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FriendDetailsPage(document, user),
        fullscreenDialog: true
      )
    );
}

Future<void> NavigateToUserDetails(DocumentSnapshot document, userController user, BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailsPage(document, user),
        fullscreenDialog: true
      )
    );
}
