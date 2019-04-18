import 'package:flutter/material.dart';
import 'package:login/userController.dart';
import 'package:login/analtyicsController.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/src/search/searchservice.dart';
import 'package:cached_network_image/cached_network_image.dart';


class SearchPage extends StatefulWidget {
  SearchPage({Key key, this.analControl, @required this.user})
      : super(key: key);

  final userController user;
  final analyticsController analControl;

  @override
  State createState() => _SearchPageState();
}

class _SearchPageState extends StateMVC<SearchPage> {
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value){
    if(value.length == 0){
      setState((){
        queryResultSet = [];
      tempSearchStore = [];
      });
    }

    var capitalizedValue = value.substring(0, 1).toUpperCase() + value.substring(1);

    if(queryResultSet.length == 0 && value.length == 1){
      SearchService().searchByName(value).then((QuerySnapshot docs){
        for(int i = 0; i<docs.documents.length; i++){
          if(docs.documents[i].documentID != widget.user.uid)  //new code might not work
            queryResultSet.add(docs.documents[i].data);
        }
      });
    }
    else{
      tempSearchStore = [];
      queryResultSet.forEach((element){
        if(element['name'].startsWith(capitalizedValue))
          setState((){
            tempSearchStore.add(element);
          });
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child:TextField(
              onChanged: (val){
                initiateSearch(val);
              },
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.arrow_back),
                  iconSize: 20.0,
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
                contentPadding: EdgeInsets.only(left: 25.0),
                hintText: 'Search by name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0))
              ),
            ),
          ),
          SizedBox(height: 10.0),
          ListView(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
            primary:false,
            shrinkWrap: true,
            children: tempSearchStore.map((element){
              return buildResultButton(element);
            }).toList(),
          )
        ]
      )
    );
  }
}

Widget buildResultButton(data){
  return FlatButton(
              child: Row(
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
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    clipBehavior: Clip.hardEdge,
                  ),
                  Flexible(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Text(
                              '${data['name']}',
                              style: TextStyle(color: Colors.lightGreen),
                            ),
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                          ),
                          // Container(
                          //   child: Text(
                          //     '${data.last['content']}',
                          //     style: TextStyle(color: Colors.lightGreen),
                          //   ),
                          //   alignment: Alignment.centerLeft,
                          //   margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          // )
                        ],
                      ),
                      margin: EdgeInsets.only(left: 20.0),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                print("pressed");
                print(data['name']);
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
              color: Colors.grey[700],
              padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            );
}