import 'package:cloud_firestore/cloud_firestore.dart';

class ProductServices {

  final CollectionReference category = FirebaseFirestore.instance.collection('category');
  final CollectionReference products = FirebaseFirestore.
  instance.collection('vendors');
  final CollectionReference favourites = FirebaseFirestore.instance.collection('favourites');
}