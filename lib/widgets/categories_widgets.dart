
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_app/provider/auth_provider.dart';
import 'package:desktop_app/services/product_service.dart';
import 'package:desktop_app/widgets/product/product_in_category.dart';
import 'package:desktop_app/widgets/product/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class VendorCategories extends StatefulWidget {

  const VendorCategories({Key? key}) : super(key: key);

  @override
  State<VendorCategories> createState() => _VendorCategoriesState();
}

class _VendorCategoriesState extends State<VendorCategories> {

  final List _categoryList = [];
  final ProductServices _productServices = ProductServices();
  @override
  void didChangeDependencies() {
    var _provider = Provider.of<AuthProvider>(context);

    FirebaseFirestore.instance
        .collection('vendors').
    doc(_provider.storeDetails['uid']).collection('products').
    where('seller.selleruid',isEqualTo: _provider.storeDetails['uid'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
       setState(() {
         _categoryList.add(doc['category']['Main-category']);
       });
      });
    });
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {

    var _provider = Provider.of<AuthProvider>(context);



    return FutureBuilder(
        future: _productServices.category.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){return const Text('something went wrong');}
          if(!snapshot.hasData){
            return const Center(child:CircularProgressIndicator(),);
          }

          return  SingleChildScrollView(
            child:Wrap(
              direction: Axis.horizontal,
              children: snapshot.data!.docs.map((DocumentSnapshot document){
                return _categoryList.contains((document.data() as dynamic)['name'])
                    ? InkWell(
                     onTap: (){

                     _provider.SelectedCategory((document.data() as dynamic)['name']);
                     _provider.selectedSubCategoryEmployer(null);
                     pushNewScreenWithRouteSettings(
                       context,
                       settings: const RouteSettings(name: ProductScreen.id),
                       screen: const ProductScreen(),
                       withNavBar: true,
                       pageTransitionAnimation: PageTransitionAnimation.cupertino,
                     );
                     },
                      child: Container(
                  height: 160,width: 150,
                        child: Card(
                  child: Column(
                        children: [
                          Center(child: Image.network((document.data() as dynamic)['imag']),
                          ),
                          Text((document.data() as dynamic)['name'],
                            textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),),
                        ],
                  ),
                ),
                      ),
                    ): const Text('');
              }).toList()
            ) ,
          );
        }
        );
  }
}
