

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_app/services/cart_services.dart';
import 'package:flutter/cupertino.dart';

class CartProvider with ChangeNotifier{

  CartServices _cart = CartServices();
  double subTotal =0.0;
   int cartQuantity = 0;
   QuerySnapshot ?snap;
  DocumentSnapshot ?document;
   bool cod=false;
   List cartList = [];

  Future<double?> getCarttotal()  async {
    List _newList = [];
    double cartTotal =0.0;
    QuerySnapshot snapshot= await
    _cart.cart.doc(_cart.user!.uid).collection('products').get();
  if(snapshot==null){
    return null;
  }
    snapshot.docs.forEach((doc) {
      if(!_newList.contains(doc.data())){
        _newList.add(doc.data());
        cartList =_newList;
        notifyListeners();
      }
      cartTotal = cartTotal+(doc.data() as dynamic)['total'];
    });
  subTotal = cartTotal;
  cartQuantity= snapshot.size;
  snap=snapshot;
  notifyListeners();
  return cartTotal;

}

   getPaymentMethode(index){
    if(index==0){
    cod=true;
    notifyListeners();
    }
    if(index==1){
      cod=false;
      notifyListeners();
    }
    }

   getShopName() async {
     DocumentSnapshot doc = await _cart.cart.doc(_cart.user!.uid).get();
     if(doc.exists){
       document = doc;
       notifyListeners();
     }else {
       document=null;
       notifyListeners();
     }

   }
   }