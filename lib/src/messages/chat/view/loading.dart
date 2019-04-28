import 'package:flutter/material.dart';
import 'package:login/prop-config.dart';

Widget buildLoading(bool isLoading) {
  print('\n\nBuildLoading\n\n');
  return Positioned(
    child: isLoading
        ? Container(
            child: Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(themeColors.accent1)),
            ),
            color: Colors.white.withOpacity(0.8),
          )
        : Container(),
  );
}
