import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/userController.dart';
import 'package:latlong/latlong.dart';

class BuddyDetailBody extends StatelessWidget {
  BuddyDetailBody(this.document, this.user, {
    Key key,
  });
  final DocumentSnapshot document;
  userController user;
  double km;
  final Distance distance = new Distance();
  
  

  Widget _buildLocationInfo(TextTheme textTheme) {
    GeoPoint targetLocation = document.data['location'];
    km = distance.as(LengthUnit.Kilometer, new LatLng(user.latitude, user.longitude), new LatLng(targetLocation.latitude, targetLocation.longitude));
    return new Row(
      children: <Widget>[
        new Icon(
          Icons.place,
          color: Colors.white,
          size: 16.0,
        ),
        new Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: new Text(
            ' $km  kilometers away',
            style: textTheme.subhead.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _createCircleBadge(IconData iconData, Color color) {
    return new Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: new CircleAvatar(
        backgroundColor: color,
        child: new Icon(
          iconData,
          color: Colors.white,
          size: 16.0,
        ),
        radius: 20.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text(
          '${document['name']}',
          style: textTheme.headline.copyWith(color: Colors.white),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: _buildLocationInfo(textTheme),     //make this distance away
        ),
        new Text(
            '${document['gender']}',
            style: textTheme.headline.copyWith(color: Colors.white),
            ),
        new Text(
            '${document['age']}',
            style: textTheme.headline.copyWith(color: Colors.white),
            ),
        new Text(
            '${document['occupation']}',
            style: textTheme.headline.copyWith(color: Colors.white),
            ),
            /*
        new Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: new Row(
            children: <Widget>[
              _createCircleBadge(Icons.beach_access, theme.accentColor),
              _createCircleBadge(Icons.cloud, Colors.white12),
              _createCircleBadge(Icons.shop, Colors.white12),
            ],
          ),
        ),
        */
      ],
    );
  }
}