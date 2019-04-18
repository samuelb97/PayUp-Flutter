import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:login/prop-config.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class SupportPage extends StatefulWidget {

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends StateMVC<SupportPage> {

  @override
  Widget build(BuildContext context) {
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
                padding: EdgeInsets.only(top: 50.0),
                child: 
                  Material(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    clipBehavior: Clip.hardEdge,
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                            ),
                            width: 100.0,
                            height: 100.0,
                            padding: EdgeInsets.all(40.0),
                          ),
                      imageUrl: 'https://pbs.twimg.com/media/DVz1ZUIW0AE89BR.jpg',    //developers aka us
                      width: 80.0,
                      height: 80.0,
                      fit: BoxFit.cover,
                    ),
                  ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                padding: EdgeInsets.all(10.0),
                child: Column(children: <Widget>[
                  Text(
                    Prompts.meet,
                    style: Theme.of(context)
                        .textTheme
                        .body2
                        .merge(TextStyle(color: Colors.white)),
                  ),
                  Container(height: 1, width: 220, color: Colors.green),
                  Padding(
                    padding: EdgeInsets.all(2.0),
                  ),
                  Text(
                    Prompts.contact,
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .merge(TextStyle(color: Colors.white)),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.all(30.0)
                  ),
                  Text(
                    Prompts.dev1,
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .merge(TextStyle(color: Colors.white)),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.all(30.0)
                  ),
                  Text(
                    Prompts.dev2,
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .merge(TextStyle(color: Colors.white)),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.all(30.0)
                  ),
                  Text(
                    Prompts.dev3,
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .merge(TextStyle(color: Colors.white)),
                    textAlign: TextAlign.center,
                  ),
                ]),
              ),
            ]
          ),
        ),
      ),
    );
  }
}
