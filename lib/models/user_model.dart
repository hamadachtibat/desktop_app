
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  static const Number='number';
  static const ID = 'id';

   late String _number;
   late String _id;

  String get number =>_number;
  String get id  =>_id;

  UserModel.fromSnapshot(DocumentSnapshot snapshot){

      _number = (snapshot.data() as dynamic)[Number];
      _id = (snapshot.data() as dynamic)[ID];



  }
}