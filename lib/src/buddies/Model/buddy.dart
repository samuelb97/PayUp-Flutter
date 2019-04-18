import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:meta/meta.dart';

class Buddy {
  Buddy({
    @required this.avatar,
    @required this.name,
    @required this.email,
    @required this.location,
    @required this.age,
    @required this.occupation,
  });

  final String avatar;
  final String age;
  final String name;
  final String email;
  final String occupation;
  final String location;

  static List<Buddy> allFromResponse(String response) {
    var decodedJson = json.decode(response).cast<String, dynamic>();

    return decodedJson['results']
        .cast<Map<String, dynamic>>()
        .map((obj) => Buddy.fromMap(obj))
        .toList()
        .cast<Buddy>();
  }

  static Buddy fromMap(Map map) {
    var name = map['name'];

    return new Buddy(
      avatar: map['picture']['large'],
      name: '${_capitalize(name['first'])} ${_capitalize(name['last'])}',
      email: map['email'],
      age: map['age'],
      occupation: map['occupation'],
      location: _capitalize(map['location']['state']),
    );
  }

  static String _capitalize(String input) {
    return input.substring(0, 1).toUpperCase() + input.substring(1);
  }
}
/*
void _navigateToBuddyDetails(Buddy buddy, Object avatarTag) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (c) {
          return new BuddyDetailsPage(buddy, avatarTag: avatarTag);
        },
      ),
    );
}
*/