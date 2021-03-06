import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_app/services/cart_services.dart';
import 'package:flutter/material.dart';
import 'cart_card.dart';


class CartList extends StatefulWidget {
  final DocumentSnapshot document;
  const CartList({Key? key, required this.document}) : super(key: key);

  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  final CartServices _cartServices = CartServices();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _cartServices.cart.doc(_cartServices.user!.uid).
      collection('products').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }


        if(!snapshot.hasData){
          return const Center(child: CircularProgressIndicator(),);
        }
        return ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return CartCard(document: document,);

          }).toList(),
        );
      },
    );
  }
}
