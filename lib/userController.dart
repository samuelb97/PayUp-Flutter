import 'package:location/location.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class userController{
  factory userController() {
    if (_this == null) _this = userController._();
    return _this;
  }
  static userController _this;

  userController._();

  static userController get userCon => _this;

  LocationData _location;
  static String _uid;
  static String _age;
  static String _gender;
  static String _mobile;
  static String _name;
  static String _occupation;
  static String _photoUrl;

  static List _interests;
  static double _latitude;
  static double _longitude;
 

  set set_uid(String uid){
    _uid = uid;
  }

  String get uid => _uid;
  String get name => _name;
  String get age => _age;
  String get gender => _gender;
  String get mobile => _mobile;
  String get occupation => _occupation;
  String get photoUrl => _photoUrl;


  List get interests => _interests;
  LocationData get location => _location;
  double get latitude => _latitude;
  double get longitude => _longitude;
  // LatLng get latlng => LatLng(_latitude, _longitude);

  

  Future load_data_from_firebase() async {
    Firestore.instance.collection('users').document(_uid)
      .get().then((DocumentSnapshot){
        print('Load Data From Firebase');
        print(DocumentSnapshot.data['name'].toString());
        _age = DocumentSnapshot.data['age'].toString();
        _gender = DocumentSnapshot.data['gender'].toString();
        _mobile = DocumentSnapshot.data['mobile'].toString();
        _name = DocumentSnapshot.data['name'].toString();
        _occupation = DocumentSnapshot.data['occupation'].toString();
        _interests = DocumentSnapshot.data['interests'];
        _photoUrl = DocumentSnapshot.data['photoUrl'].toString();
        GeoPoint __location = DocumentSnapshot.data['location'];
        _latitude = __location.latitude;
        _longitude = __location.longitude;
        print('Location After Load: $_longitude , $_latitude');
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

  Future updateLocation() async {

    LocationData currentLocation;

    var location = new Location();
    try {
      currentLocation = await location.getLocation();
      
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print(e.message);
      }
      currentLocation = null;
    }
    var geopoint =
        new GeoPoint(currentLocation.latitude, currentLocation.longitude);
    Firestore.instance
        .collection("users")
        .document("$_uid")
        .updateData({"location": geopoint});
    
  }
}