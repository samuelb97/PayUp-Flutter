import 'package:flutter/material.dart';
import 'package:login/prop-config.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:login/src/profile/Controller/editInterestsController.dart';
import 'package:login/analtyicsController.dart';
import 'package:login/userController.dart';

class EditInterestsPage extends StatefulWidget {

  EditInterestsPage({
    Key key,
    this.analControl,
    @required this.user
  }) : super(key: key);

  final userController user;
  final analyticsController analControl;

  @override
  _EditInterestsPageState createState() => _EditInterestsPageState();
}

class _EditInterestsPageState extends StateMVC<EditInterestsPage> {
  _EditInterestsPageState() : super(Controller()){
    _con = Controller.con;
    _con.setTextListener();
    interests = _con.interests;
  }
  Controller _con;
  List interests;
  
  @override
  Widget build(BuildContext context) {
    widget.analControl.currentScreen('update_profile', 'EditInterestsOver');
    _con.set_interests = widget.user.interests;
    return Scaffold(
      appBar: AppBar(
        title: Text(Prompts.editInterests),
        backgroundColor: Colors.lightGreen,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
          child: Column(children: <Widget>[
            Row(children: <Widget>[
              Expanded( 
                child: TextFormField(
                  controller: _con.textController,
                  decoration: InputDecoration(
                    hintText: Prompts.newInterest,
                    // labelText: Prompts.newInterest
                  ),
                  maxLength: 32,
                  onEditingComplete: () => {
                    _con.addInterest(widget.user),
                    _con.textController.clear(),
                    setState((){
                      interests = _con.interests;
                    })
                  },  
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => {
                  _con.addInterest(widget.user),
                  _con.textController.clear(),
                  setState((){
                    interests = _con.interests;
                  })
                },
              )
            ]),
          getTextWidgets()
          ])
        )
      )
    );
  }
  Widget getTextWidgets(){
    List<Widget> list = List<Widget>();
    for(var i = 0; i < interests.length; i++){
        list.add(interestItem(interests[i]));
    }
    return Column(children: list);
  }

  Widget interestItem(String string){
    var id = string;
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor))
      ),
      child: Row(children: <Widget>[
        Expanded(
          child: Text(
            string,
            style: TextStyle(fontSize: 16)
          ),
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => {
            _con.deleteInterest(widget.user, id),
            setState((){
              interests = _con.interests;
            })
          },
        )
      ])
    );
  }
}