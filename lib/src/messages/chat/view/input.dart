import 'package:flutter/material.dart';
import 'package:login/src/messages/chat/chatController.dart';
import 'package:login/userController.dart';
import 'package:login/prop-config.dart';

 Widget buildInput(ChatController chatController, userController user) {
    print('\n\nBuildInput\n\n');
    print("\nList Messages: ${chatController.listMessage}\n");
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
                color: themeColors.accent2,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: themeColors.accent2, fontSize: 15.0),
                controller: chatController.textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: themeColors.accent2),
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
                onPressed: () {
                  chatController.onSendMessage(
                    chatController.textEditingController.text, 
                    0
                  );
                  if(chatController.listMessage.length == 0 
                    || chatController.listMessage == null
                    || !user.messages.contains(chatController.groupChatId)
                    ) 
                  {
                    print("\nFirst Message\n");
                    chatController.addChatToUsers(user);
                  }
                },
                color: themeColors.accent2,
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