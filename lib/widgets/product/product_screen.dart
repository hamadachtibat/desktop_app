import 'package:desktop_app/provider/auth_provider.dart';
import 'package:desktop_app/widgets/product/product_filter.dart';
import 'package:desktop_app/widgets/product/product_in_category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../vendor_appbar.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);
  static const String id = 'products-screen';

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<AuthProvider>(context);
    return Scaffold(
        body:NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                floating: true,
                snap: true,
                title: Text(_provider.selectedproductCategory,),
                centerTitle: true,
                expandedHeight: 110,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.only(top: 88),
                  child: Container(
                    height: 56,
                    color: Colors.grey,
                    child: ProductFilterWidget(),
                  ),
                ),


              ),
            ];
          },
          body:ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: const [
              ProductsListScreen()
            ],
          )
        ),
    );
  }
}
