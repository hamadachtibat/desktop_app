

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_app/models/user_model.dart';

class UserServices {

  String collection = 'users';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> creatUserData(Map<String,dynamic>values)async {

    String id = values['id'];
    await _firestore.collection(collection).doc(id).set(values);
  }
  Future<void> updateUserData(Map<String,dynamic>values)async{
    String id = values['id'];
    await _firestore.collection(collection).doc(id).update(values);

  }
  Future<DocumentSnapshot> getUserById(String id) async {
    final result = await _firestore.collection(collection).doc(id).get();
    return result;
  }
}