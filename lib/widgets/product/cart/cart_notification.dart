import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_app/Pages/cart_screen.dart';
import 'package:desktop_app/localization/language/languages.dart';
import 'package:desktop_app/provider/cart_provider.dart';
import 'package:desktop_app/services/cart_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class CartNotification extends StatefulWidget {
  const CartNotification({Key? key}) : super(key: key);

  @override
  _CartNotificationState createState() => _CartNotificationState();
}

class _CartNotificationState extends State<CartNotification> {

  @override
  Widget build(BuildContext context) {
    var cartprovider = Provider.of<CartProvider>(context);
    cartprovider.getShopName();

    cartprovider.getCarttotal();
    return Visibility(
      visible: cartprovider.cartQuantity<1? false: true,
      child: Container(

        decoration: BoxDecoration(
          color: Colors.green[800],
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
              topLeft: Radius.circular(15)),
        ),
        height: 56,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(Languages.of(context)!.youhaveSelected,
                        style: TextStyle(
                          color: Colors.white,
                            fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                            'Cairo' : 'Nunito'
                        ),),
                      Text( ' ${cartprovider.cartQuantity} '
                          ,style: TextStyle(color: Colors.red,),),
                      Text(Languages.of(context)!.employer,style: TextStyle(
                          fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                          'Cairo' : 'Nunito',
                        color: Colors.white,
                      ),),
                    ],
                  ),
                  if(cartprovider.document?.exists?? null  == true)
                  Text('From ${(cartprovider.document!.data() as dynamic)['shopname']} '
                    ,style: TextStyle(color: Colors.white),),
                ],
              ),
            ),
            InkWell(
              onTap: (){
                pushNewScreenWithRouteSettings(
                  context,
                  settings: const RouteSettings(name: CartScreen.id),
                  screen:  CartScreen(document: cartprovider.document as dynamic ,),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: Container(
                child: Row(
                  children: [
                    Text(Languages.of(context)!.showCart
                      ,style: TextStyle(color: Colors.white,
                          fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                          'Cairo' : 'Nunito'),),
                    const SizedBox(width: 5,),
                    const Icon(CupertinoIcons.shopping_cart,color: Colors.white,)
                  ],
                ),
              ),
            )
          ],),
        ),

      ),
    );
  }
}
