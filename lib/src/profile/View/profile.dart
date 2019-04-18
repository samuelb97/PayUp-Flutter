import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:login/prop-config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:login/analtyicsController.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:login/src/profile/Controller/profileController.dart';
import 'package:login/userController.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.analControl, @required this.user})
      : super(key: key);

  final userController user;
  final analyticsController analControl;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends StateMVC<ProfilePage> {
  _ProfilePageState() : super(Controller()) {
    _con = Controller.con;

  }
  Controller _con;

  @override
  Widget build(BuildContext context) {
    widget.user.load_data_from_firebase();
    widget.analControl.currentScreen('profile_page', 'ProfilePageOver');

    widget.user.updateLocation();

    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          const Color(0xFF413070),
          const Color(0xFF2B264A),
        ],
      ),
    );

    return Scaffold(
      body: Center(
        child: Container(
          decoration: linearGradient,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
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
                    ],
                  )
                ]),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                padding: EdgeInsets.all(10.0),
                child: Column(children: <Widget>[
                  Text(
                    Userinfo.interests,
                    style: Theme.of(context)
                        .textTheme
                        .body2
                        .merge(TextStyle(color: Colors.white)),
                  ),
                  Container(height: 1, width: 120, color: Colors.green),
                  Padding(
                    padding: EdgeInsets.all(2.0),
                  ),
                  Text(
                    '${widget.user.interests.toString().replaceAll('[', '').replaceAll(']', '')}',
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .merge(TextStyle(color: Colors.white)),
                    textAlign: TextAlign.center,
                  ),
                ]),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
              ),
              buildMap(context, widget.user.latitude, widget.user.longitude),
              Padding(
                padding: EdgeInsets.all(12.0),
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 50.0),
                  child: ButtonTheme(
                      minWidth: 250,
                      child: RaisedButton(
                        color: Colors.green[800],
                        splashColor: Colors.green[300],
                        textTheme: ButtonTextTheme.primary,
                        padding: EdgeInsets.symmetric(horizontal: 50.0),
                        elevation: 6,
                        shape: BeveledRectangleBorder(
                          side: BorderSide(
                            width: 2.0,
                            color: Colors.deepPurple[800],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () {
                          widget.analControl.sendAnalytics('to_update_profile');
                          _con.NavigateToUpdateProfile(
                              context, widget.analControl, widget.user);
                        },
                        child: Text(Prompts.updateProfile),
                      ))),
              Padding( 
                padding: EdgeInsets.all(4.0),
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 50.0),
                  child: ButtonTheme(
                      minWidth: 250,
                      child: RaisedButton(
                        color: Colors.green[800],
                        splashColor: Colors.green[300],
                        textTheme: ButtonTextTheme.primary,
                        padding: EdgeInsets.symmetric(horizontal: 50.0),
                        elevation: 6,
                        shape: BeveledRectangleBorder(
                          side: BorderSide(
                            width: 2.0,
                            color: Colors.deepPurple[800],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () {
                          widget.analControl.sendAnalytics('to_edit_interests');
                          _con.NavigateToEditInterests(
                              context, widget.analControl, widget.user);
                        },
                        child: Text(Prompts.editInterests),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildMap(BuildContext context, double latitude, double longitude) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 70.0),
    height: MediaQuery.of(context).size.height * .26,
    width: MediaQuery.of(context).size.width * .4,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15.0),
      color: Colors.grey[400],
    ),
    child: GoogleMap(
      myLocationEnabled: true,
      initialCameraPosition:
          CameraPosition(target: LatLng(latitude, longitude), zoom: 10),
    ),
  );
}
