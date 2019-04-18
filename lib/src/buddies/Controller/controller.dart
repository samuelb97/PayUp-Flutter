import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/src/buddies/Model/buddy.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:login/src/buddies/View/details_page.dart';
import 'package:login/userController.dart';

class Controller extends ControllerMVC {
  factory Controller() {
    if (_this == null) _this = Controller._();
    return _this;
  } 
  static Controller _this;
  Controller._();
  static Controller get con => _this;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<Buddy> _buddies = [];
  List _interests; 
  static String _newInterest;
  static TextEditingController _textController = TextEditingController();
  set set_interests(List __interests){
    _interests = __interests;
  }


  TextEditingController get textController => _textController;
  List get interests => _interests;

  @override
  void initState() {
    super.initState();
    _loadBuddies();
  }

  Future<void> _loadBuddies() async {
    http.Response response =
        await http.get('https://randomuser.me/api/?results=25');

    setState(() {
      _buddies = Buddy.allFromResponse(response.body);
    });
  }

  static void NavigateToBuddyDetails(DocumentSnapshot document, userController user, BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BuddyDetailsPage(document, user),
        fullscreenDialog: true
      )
    );
  }
}