

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderServices {
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');


 Future<DocumentReference>saveOrder(Map<String,dynamic>data){
 
   var result = orders.add(data);
 return result;
  }
}