import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:io';
 
class ChatController extends ControllerMVC {
  factory ChatController() {
    if (_this == null) _this = ChatController._();
    return _this;
  }
  static ChatController _this;

  ChatController._();

  static ChatController get con => _this;

  String _peerId;
  String _peerAvatar;
  String _id;

  var _listMessage;
  String _groupChatId;
  SharedPreferences _prefs;

  File _imageFile;
  bool _isLoading;
  String _imageUrl;

  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _listScrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  get listMessage => _listMessage;
  String get peerId => _peerId;
  String get peerAvatar => _peerAvatar;
  String get id => _id;
  String get groupChatId => _groupChatId;
  SharedPreferences get prefs => _prefs;
  File get imageFile => _imageFile;
  bool get isLoading => _isLoading;
  String get imageUrl => _imageUrl;
  TextEditingController get textEditingController => _textEditingController;
  ScrollController get listScrollController => _listScrollController;
  FocusNode get focusNode => _focusNode;

  set set_id(String __id) => _id = __id;
  set set_peerId(String __peerId) => _peerId = __peerId;
  set set_peerAvatar(String __peerAvatar) => _peerAvatar = __peerAvatar;
  set set_listMessage(var listMessage) => _listMessage = listMessage;
  set set_groupChatId(String __groupChatId) => _groupChatId = __groupChatId;
  set set_isLoading(bool __isLoading) => _isLoading = __isLoading;
  set set_imageUrl(String __imageUrl) => _imageUrl = __imageUrl;


  readLocal() async {
    //_prefs = await SharedPreferences.getInstance();
    //_id = _prefs.getString('id') ?? '';
    if (_id.hashCode <= _peerId.hashCode) {
      _groupChatId = '$_id-$_peerId';
    } else {
      _groupChatId = '$_peerId-$_id';
    }
    setState(() {});
  }

  Future getImage() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (_imageFile != null) {
      setState(() {
        _isLoading = true;
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(_imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      _imageUrl = downloadUrl;
      setState(() {
        _isLoading = false;
        onSendMessage(_imageUrl, 1);
      });
    }, onError: (err) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }

  void onSendMessage(String content, int type) {
    //type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      _textEditingController.clear();

      var documentReference = Firestore.instance
          .collection('messages')
          .document(_groupChatId)
          .collection(_groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': _id,
            'idTo': _peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      });
      _listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 && _listMessage != null && _listMessage[index - 1]['idFrom'] == _id) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 && _listMessage != null && _listMessage[index - 1]['idFrom'] != _id) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress(BuildContext context) {
    Navigator.pop(context);
    return Future.value(false);
  }
}