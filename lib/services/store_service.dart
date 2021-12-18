
import 'package:cloud_firestore/cloud_firestore.dart';

class Storeservices{
  CollectionReference vendors = FirebaseFirestore.instance.collection('vendors');
  getTopPickedStore() {
    return FirebaseFirestore.instance.collection('vendors').
    where('acountverified',isEqualTo: true).where('isTopPick',isEqualTo: true).
    orderBy('shopname').snapshots();
  }
  getOrdinaryPickedStore() {
    return FirebaseFirestore.instance.collection('vendors').
    where('acountverified',isEqualTo: true).where('isTopPick',isEqualTo: false).
    orderBy('shopname').snapshots();
  }
  Future<DocumentSnapshot> getVendorsDetails(selleruid) async{
    DocumentSnapshot snapshot = await vendors.doc(selleruid).get();
    return snapshot;
  }

}