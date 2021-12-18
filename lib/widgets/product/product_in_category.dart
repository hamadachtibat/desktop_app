import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_app/provider/auth_provider.dart';
import 'package:desktop_app/services/product_service.dart';
import 'package:desktop_app/widgets/product/product_card_widget.dart';
import 'package:desktop_app/widgets/product/product_filter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ProductsListScreen extends StatelessWidget {
  const ProductsListScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var  _provider = Provider.of<AuthProvider>(context);
    ProductServices _services = ProductServices();
    return FutureBuilder<QuerySnapshot>(
      future:_services.products.doc(_provider.storeDetails['uid']).
      collection('products').limit(_provider.storeDetails['numberOfEmployer']).where('published',isEqualTo: true).
      where('isavailbale',isEqualTo: true).
      where('category.Main-category',
          isEqualTo: _provider.selectedproductCategory).where('category.subcategory',
          isEqualTo: _provider.selectedSubCategory)
      .get() ,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator(),);
        }

        return Column(
          children: [

            Container(
              color: Colors.grey[200],
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0,top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    Text('Total employer in this Category are :'),
                    CircleAvatar(child: Text('${snapshot.data!.docs.length}'),)

                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  return ProductCard(document: document,);
                }).toList(),
              ),
            ),
            SizedBox(height: 50,)
          ],
        );
      },
    );
  }
}