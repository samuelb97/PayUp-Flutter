import 'package:flutter/material.dart';
import 'package:login/prop-config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShowInterestsPage extends StatelessWidget {
  ShowInterestsPage({Key key, this.document})
      : super(key: key);

  final DocumentSnapshot document;
  
  @override
  
  Widget build(BuildContext context) {
    List items = document.data['interests'];
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
      appBar: AppBar(
        title: Text('${document.data['name']}\'s ${Userinfo.interests}'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Container (
          
          decoration: linearGradient,
          child: ListView.builder(
            
            itemCount: items.length,
            itemBuilder: (context, position) {
              return Container(
                color: Colors.lightGreen[300],
                child: ListTile(
                  title: Text('${position+1} : ${items[position]}', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                )
              ); 
            },
          )
      ),
    );
  }
}