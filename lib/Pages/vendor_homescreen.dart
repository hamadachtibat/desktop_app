
import 'package:desktop_app/provider/auth_provider.dart';
import 'package:desktop_app/widgets/categories_widgets.dart';
import 'package:desktop_app/widgets/imag_slider.dart';
import 'package:desktop_app/widgets/my_appbar.dart';
import 'package:desktop_app/widgets/product/products_list.dart';
import 'package:desktop_app/widgets/vendor_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorHomeScreen extends StatelessWidget {
  static const String id = 'vendorhomescreen';
  const VendorHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
           headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
         return [
           const VendorAppBar(),
         ];
           },

          body:ListView(
           shrinkWrap: true,
           children: const [
             ImagSlider(),
             Padding(
               padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 12),
               child: VendorCategories(),
             ),
             Products(),
             SizedBox(height: 60,)
           ],

          ),
      ),
    );
  }
}
