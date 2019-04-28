import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  searchByName(String searchField){
    return Firestore.instance.collection('users')
    .where('searchKey', 
      isEqualTo: searchField.substring(0,1).toUpperCase())
    .getDocuments();
  }
  searchByUsername(String username){
    return Firestore.instance.collection('users')
    .where('username',
      isEqualTo: username).getDocuments();
  }
}
