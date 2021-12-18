import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<String> getServerKey() async{
  DocumentSnapshot snapshot = await
  FirebaseFirestore.instance.collection('appData').doc('serverKey').get() ;
  if(snapshot.exists){
    var key = (snapshot.data() as Map)['key'];
    return key;

  }else{
    return 'NON';
  }
}