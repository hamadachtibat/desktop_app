import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_app/provider/auth_provider.dart';
import 'package:desktop_app/services/product_service.dart';
import 'package:desktop_app/widgets/product/product_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Products extends StatelessWidget {
  const Products({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var  _provider = Provider.of<AuthProvider>(context);
    ProductServices _services = ProductServices();
    return FutureBuilder<QuerySnapshot>(
      future:_services.products.
      doc(_provider.storeDetails['uid']).
      collection('products').where('published',isEqualTo: true)
          .where('isavailbale',isEqualTo: true).limit(_provider.storeDetails['numberOfEmployer']).get() ,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

       if(!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator(),);
        }

        return ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return ProductCard(document: document,);
          }).toList(),
        );
      },
    );
  }
}
