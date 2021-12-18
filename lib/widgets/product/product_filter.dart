import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_app/provider/auth_provider.dart';
import 'package:desktop_app/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ProductFilterWidget extends StatefulWidget {
  const ProductFilterWidget({Key? key}) : super(key: key);

  @override
  _ProductFilterWidgetState createState() => _ProductFilterWidgetState();
}

class _ProductFilterWidgetState extends State<ProductFilterWidget> {
  List _subCatList = [];
  final ProductServices _productServices = ProductServices();

  @override
  void didChangeDependencies() {
    var _provider = Provider.of<AuthProvider>(context);
    FirebaseFirestore.instance
        .collection('vendors').doc(_provider.storeDetails['uid']).collection('products').
    where('category.Main-category',isEqualTo:_provider.selectedproductCategory )
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          if(mounted){
            _subCatList.add(doc['category']['subcategory']);
          }

        });
      });
    });
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<AuthProvider>(context);
    return FutureBuilder<DocumentSnapshot>(
      future: _productServices.category.doc(_provider.selectedproductCategory).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }



        if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator(),);
        }

        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
        return  Container(
          height: 50,
          color: Colors.grey[800],
          child: ListView(

            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 10,),
              ActionChip(
                  elevation: 4,
                  backgroundColor: Colors.white,
                  label: Text('All ${_provider.selectedproductCategory}'),
                  onPressed: (){
                    _provider.selectedSubCategoryEmployer(null);
                  }),
              ListView.builder(
                  itemCount: data['subcat'].length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context,int index){
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: _subCatList.contains(data['subcat'][index]['name']) ?
                      ActionChip(
                          elevation: 4,
                          backgroundColor: Colors.white,
                          label: Text(data['subcat'][index]['name']),
                          onPressed: (){
                            _provider.selectedSubCategoryEmployer
                              (data['subcat'][index]['name']);


                          }): Container(),
                    );
                  }

              ),
            ],
          ),
        );
      },
    );
  }
}
