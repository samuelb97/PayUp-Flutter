import 'package:flutter/material.dart';
import 'package:login/src/messages/chat/view/view.dart';
import 'package:login/src/messages/chat/chatController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


Widget buildListMessage(ChatController chatController) {
  return Flexible(
    child: chatController.groupChatId == ''
        ? Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen)))
        : StreamBuilder(
            stream: Firestore.instance
                .collection('messages')
                .document(chatController.groupChatId)
                .collection(chatController.groupChatId)
                .orderBy('timestamp', descending: true)
                .limit(20)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen)));
              } else {
                chatController.set_listMessage = snapshot.data.documents;
                return ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemBuilder: (context, index) =>
                      buildItem(index, snapshot.data.documents[index], chatController),
                  itemCount: snapshot.data.documents.length,
                  reverse: true,
                  controller: chatController.listScrollController,
                );
              }
            },
          ),
  );
}
