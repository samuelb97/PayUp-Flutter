import 'package:flutter/material.dart';
import 'package:login/analtyicsController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:login/userController.dart';
import 'package:login/src/buddies/Controller/controller.dart';
import 'package:login/src/buddies/View/details_page.dart';
import 'package:latlong/latlong.dart';

Controller buddyController;
String photo;
Widget buildItem(BuildContext context, DocumentSnapshot document, 
  userController user, analyticsController analControl) {

  final Distance distance = new Distance();
  
  List targetInterests = document.data['interests'];
  List userInterests = user.interests;
  GeoPoint targetLocation = document.data['location'];
  bool checksOut = false;
  double radius = 50.0;
  double km;
  List commonInterests = [];
  int iterate = 0;

  print(targetInterests.length);
  print(userInterests.length);

  for(int i = 0; i < targetInterests.length; i++){
    for(int j = 0; j < userInterests. length; j++){
      if (targetInterests[i] == userInterests[j]){
        //print("GOT HERE 1");
        //print(targetInterests[i]);
        //print(userInterests[j]);
        commonInterests.insert(iterate, targetInterests[i]);
        km = distance.as(LengthUnit.Kilometer, new LatLng(user.latitude, user.longitude), new LatLng(targetLocation.latitude, targetLocation.longitude));
        print(km);
        if(km <= radius){ checksOut = true;
          if(commonInterests.length > 1){
            break;
          }
        }
        else checksOut = false;
        iterate++;
        //print("GOT HERE 2");
      }
    }
    if(checksOut){
      break;
    }
  }  


  if (!checksOut || document.documentID == user.uid) {
    return Container();
  } else {
    return Container(
      child: FlatButton(
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
                imageUrl:'${document.data['photoUrl']}',
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
                        '${document['name']}',
                        style: TextStyle(color: Colors.lightGreen),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                    ),
                    Container(
                      child: Row(
                      children: <Widget>[ Icon(
                      Icons.assignment,
                      color: Colors.white,
                      size: 16.0,
                      ),  Text(
                        'Interests: ${commonInterests.toString().replaceAll('[', '').replaceAll(']', '')}',
                        style: TextStyle(color: Colors.lightGreen),
                      ),
                      ]),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                    ),
                    
                    Container(
                    child: Row(
                      children: <Widget>[ Icon(
                      Icons.place,
                      color: Colors.white,
                      size: 16.0,
                      ), 
                      
                      Text(
                        '$km  kilometers away',
                        style: TextStyle(color: Colors.lightGreen),
                      ),
                      ]),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      
                    )
                  ],
                ),
                margin: EdgeInsets.only(left: 20.0),
              ),
            ),
          ],
        ),
          //onPressed: () => _navigateToBuddyDetails(document),
          onPressed: () {
            Controller.NavigateToBuddyDetails(document, user, context);
          },
    
        color: Colors.grey[700],
        padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
    );
  }
}

void _navigateToBuddyDetails(
      DocumentSnapshot document, userController user) 
      async {
    BuildContext context;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BuddyDetailsPage(document, user),
        fullscreenDialog: true
        
      )
    );
}
