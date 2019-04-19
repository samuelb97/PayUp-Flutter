import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class userController{
  factory userController() {
    if (_this == null) _this = userController._();
    return _this;
  }
  static userController _this;

  userController._();

  static userController get userCon => _this;

  static String _uid;
  static String _age;
  static String _name;
  static String _username;
  static String _photoUrl;
  static int _wins;
  static int _loses;

  static List _friends;
  static List _bets;
 

  set set_uid(String uid){
    _uid = uid;
  }

  String get uid => _uid;
  String get name => _name;
  String get username => _username;
  String get age => _age;
  String get photoUrl => _photoUrl;
  List get friends => _friends;
  List get bets => _bets;

  

  Future<void> load_data_from_firebase() async {
    await Firestore.instance.collection('users').document(_uid)
      .get().then((DocumentSnapshot){
        print('Load Data From Firebase');
        print(DocumentSnapshot.data['name'].toString());
        _age = DocumentSnapshot.data['age'].toString();
        _name = DocumentSnapshot.data['name'].toString();
        _username = DocumentSnapshot.data['username'].toString();
        _friends = DocumentSnapshot.data['friends'];
        _wins = DocumentSnapshot.data['wins'];
        _loses = DocumentSnapshot.data['loses'];
        _bets = DocumentSnapshot.data['betIDs'];
        _photoUrl = DocumentSnapshot.data['photoUrl'].toString();
        print('Loaded Data:\n $_age, $_name, $_username, $_wins, $_loses, $_photoUrl\n$_friends\n$_bets\n');
      }
    );
  }

  



  // Future<GeoPoint> getUserLocation() async {
  //   final _getLocation = Location();
  //   try {
  //     _location = await _getLocation.getLocation();
  //     final lat = _location.latitude;
  //     _latitude = lat;
  //     final lng = _location.longitude;
  //     _longitude = lng;
  //     final center = GeoPoint(lat, lng);
  //     return center;
  //   } on Exception {
  //     _location = null;
  //     return null;
  //   }
  // }

}