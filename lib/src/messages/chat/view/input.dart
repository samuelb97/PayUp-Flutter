import 'package:flutter/material.dart';
import 'package:login/src/messages/chat/chatController.dart';

 Widget buildInput(ChatController chatController) {
   print('\n\nBuildInput\n\n');
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: chatController.getImage,
                color: Colors.lightGreen,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: Colors.lightGreen, fontSize: 15.0),
                controller: chatController.textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                focusNode: chatController.focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => chatController.onSendMessage(
                  chatController.textEditingController.text, 
                  0
                ),
                color: Colors.lightGreen,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(
            color: Colors.grey[700], 
            width: 0.5)
            ), 
          color: Colors.white),
    );
  }