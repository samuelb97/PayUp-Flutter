import 'package:flutter/material.dart';

Widget buildLoading(bool isLoading) {
  print('\n\nBuildLoading\n\n');
  return Positioned(
    child: isLoading
        ? Container(
            child: Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen)),
            ),
            color: Colors.white.withOpacity(0.8),
          )
        : Container(),
  );
}
