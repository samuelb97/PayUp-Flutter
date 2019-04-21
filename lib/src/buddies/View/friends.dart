import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:login/src/buddies/Controller/controller.dart';
import 'package:login/src/buddies/Model/friend.dart';
import 'package:login/src/buddies/Model/item.dart'; 
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:login/analtyicsController.dart';
import 'package:login/userController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/prop-config.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:login/src/search/searchservice.dart';



class FriendsPage extends StatefulWidget {  
  FriendsPage({
    Key key,
    this.analControl,
    @required this.user 
    
  })
      : super(key: key);
  final userController user;
  final analyticsController analControl;

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends StateMVC<FriendsPage> {

  // var queryResultSet = [];
  // var tempSearchStore = [];

  // initiateSearch(value){
  //   if(value.length == 0){
  //     setState((){
  //       queryResultSet = [];
  //     tempSearchStore = [];
  //     });
  //   }

  //   var capitalizedValue = value.substring(0, 1).toUpperCase() + value.substring(1);

  //   if(queryResultSet.length == 0 && value.length == 1){
  //     SearchService().searchByName(value).then((QuerySnapshot docs){
  //       for(int i = 0; i<docs.documents.length; i++){
  //         if(docs.documents[i].documentID != widget.user.uid)  //new code might not work
  //           queryResultSet.add(docs.documents[i].data);
  //       }
  //     });
  //   }
  //   else{
  //     tempSearchStore = [];
  //     queryResultSet.forEach((element){
  //       if(element['name'].startsWith(capitalizedValue))
  //         setState((){
  //           tempSearchStore.add(element);
  //         });
  //     });
  //   }
  // }

  @override 
  Widget build(BuildContext context) {
    return Container(
        decoration: themeColors.linearGradient,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child:TextField(
                style: TextStyle(color: Colors.white),
                onChanged: (val){
                 // initiateSearch(val);
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  prefixIcon: IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.cancel),
                    iconSize: 20.0,
                    // onPressed: (){
                    //   Navigator.of(context).pop();
                    // },
                  ),
                  contentPadding: EdgeInsets.only(left: 25.0),
                  hintStyle: TextStyle(color: Colors.white),
                  hintText: 'Search by name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0))
                ),
              ),
            ),
            ListView(
              children: <Widget>[
                Builder(
                  builder: (context){
                    if(widget.user.friends == null){
                      return Center( 
                        child: Text( 
                          "You Have No Friends",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      );
                    }
                    else {
                      return ListView.builder(
                        padding: EdgeInsets.all(10.0),
                        itemBuilder: (context, index) => buildItem(
                          context, 
                          widget.user.friends[index], 
                          widget.user,
                          widget.analControl
                        ),
                        itemCount: widget.user.friends.length,
                      );
                    }
                  }
                )
              ]
            )
          ],
        ),
    );
  }
}