import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class CartServices{
  CollectionReference cart = FirebaseFirestore.instance.collection('cart');
  User?user = FirebaseAuth.instance.currentUser;
  Future<DocumentReference> addToCart(document) async{
    cart.doc(user!.uid).set({
    'user':user!.uid,
    'selleruid':document.data()['seller']['selleruid'],
    'shopname':document.data()['seller']['shopname'],

    });
    return cart.doc(user!.uid).collection('products').add({
      'productId':document.data()['productId'],
      'productname':document.data()['productName'],
      'nationality':document.data()['nationality'],
      'salary':document.data()['salary'],
      'religion':document.data()['religion'],
      'yearsOfExperience':document.data()['period'],
      'total':document.data()['salary'],
      'productUrl':document.data()['productUrl'],
      'selleruid':document.data()['seller']['selleruid'],
      'shopname':document.data()['seller']['shopname'],



    });
  }
  Future<DocumentReference> addToFavouriteCart(document) async{
    cart.doc(user!.uid).set({
      'user':user!.uid,
      'selleruid':document.data()['product']['seller']['selleruid'],
      'shopname':document.data()['product']['seller']['shopname'],

    });
    return cart.doc(user!.uid).collection('products').add({
      'productUrl':document.data()['product']['productUrl'],
      'productId':document.data()['product']['productId'],
      'productname':document.data()['product']['productName'],
      'nationality':document.data()['product']['nationality'],
      'salary':document.data()['product']['salary'],
      'religion':document.data()['product']['religion'],
      'yearsOfExperience':document.data()['product']['period'],
      'total':document.data()['product']['salary'],


    });
  }
  Future<void> deletEmployerfromCart(document) async{

    return cart.doc(user!.uid).collection('products').doc().delete();

  }
  Future<void> deleteCart() async{
    final result = await cart.doc(user!.uid).collection('products').get().then((value){
      for(DocumentSnapshot ds in value.docs){
        ds.reference.delete();
      }

    });
  }


}