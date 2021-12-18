import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_app/Pages/profile_screen.dart';
import 'package:desktop_app/localization/language/languages.dart';
import 'package:desktop_app/models/notification_payload_notification.dart';
import 'package:desktop_app/provider/auth_provider.dart';
import 'package:desktop_app/provider/cart_provider.dart';
import 'package:desktop_app/provider/location_provider.dart';
import 'package:desktop_app/services/cart_services.dart';
import 'package:desktop_app/services/order_service.dart';
import 'package:desktop_app/services/send_notification.dart';
import 'package:desktop_app/services/store_service.dart';
import 'package:desktop_app/services/user_service.dart';
import 'package:desktop_app/widgets/product/cart/cart_list.dart';
import 'package:desktop_app/widgets/product/cart/cart_toogle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'map_screen.dart';

class CartScreen extends StatefulWidget {
  final DocumentSnapshot document;
  const CartScreen({Key? key, required this.document}) : super(key: key);
  static const String id = 'cart-screen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String _location='';
  String _address = '';
  getPrefs()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? location = preferences.getString('location');
    String? address = preferences.getString('address');
    setState(() {
      _location = location!;
      _address = address!;
    });
  }
  
  final Storeservices _storeservices = Storeservices();
  final UserServices _userServices = UserServices();
  final CartServices _cartServices = CartServices();
  final OrderServices _orderServices = OrderServices();
  bool chekingUser = false;
  User ?user=FirebaseAuth.instance.currentUser;
  DocumentSnapshot ?doc;
  @override
  void initState() {
    getPrefs();
    _storeservices.getVendorsDetails((widget.document.data()as dynamic)['selleruid']).
    then((value){
      if(value.exists){
        setState(() {
          doc=value;
        });
      } else {
        setState(() {
          doc=null;
        });
      }

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var _cartProvider = Provider.of<CartProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);
    var _userProvider = Provider.of<AuthProvider>(context);
    _userProvider.getUserDetails();


    return Scaffold(
      bottomSheet: Container(
        height: 200,
        color: Colors.blueGrey[800],
        child: Column(
          children: [
            Divider(),
            Container(
              color: Colors.white,
              height: 120,
              width: MediaQuery.of(context).size.width,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children:  [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          InkWell(
                            onTap: (){
                              locationData.getCurrentPosition().then((value){
                                if(locationData.permission==true){
                                  pushNewScreenWithRouteSettings(
                                    context,
                                    settings: const RouteSettings(name: MapScreen.id),
                                    screen: const MapScreen(),
                                    withNavBar: false,
                                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                  );
                                }else{
                                  print("Permission not allowed");
                                }
                              });

                            },
                              child: const Text("غير العنوان ",style: TextStyle(fontFamily: 'Cairo',color: Colors.red),)),
                          const SizedBox(width: 190,),
                          const Expanded(child: Text(": عنوانك هو ",style: TextStyle(fontFamily: 'Cairo'),)),

                        ],
                      ),
                      Flexible(child:

                      Text(
                          '$_location,${_address}',maxLines: 3,
                        overflow: TextOverflow.ellipsis,style: const TextStyle(
                          fontSize: 12,
                        ),)),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(Languages.of(context)!.toPay,
                        style: TextStyle(color: Colors.green,
                            fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                            'Cairo' : 'Nunito'
                        ),),
                      Text('${_cartProvider.subTotal.toStringAsFixed(0)} R.O',style: TextStyle(color: Colors.white),),
                    ],
                  ),

                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.redAccent)
                    ),
                    onPressed: (){
                      EasyLoading.show(status: 'PLease wait ...');
                      setState(() {
                        chekingUser =true;
                      });
                      _userServices.getUserById(user!.uid).then((value){
                        if((value.data() as dynamic)['firstName']==null){
                          EasyLoading.dismiss();
                          setState(() {
                            chekingUser =false;
                          });
                          EasyLoading.showInfo(Languages.of(context)!.pleaseupdateProfile);
                          pushNewScreenWithRouteSettings(
                            context,
                            settings: const RouteSettings(name: ProfileScreen.id),
                            screen: const ProfileScreen(),
                            withNavBar: false,
                            pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          );

                        }else{
                          EasyLoading.showInfo('Please wait...');
                          EasyLoading.dismiss();
                          saveOrder(_cartProvider,_cartProvider.subTotal,
                              _userProvider);
                          var notificationPayload =
                          NotificationPayloadModel(to:'/topics/${(
                              widget.document.data()as dynamic)['selleruid']}',
                              notification: NotificationContent(
                                  title: 'New Order',
                                  body: 'You Have a New Order From ${
                                      (_userProvider.
                                      documentSnapshot!.data() as dynamic)['number']
                                  }'),
                          );
                          sendNotification(notificationPayload);
                          EasyLoading.showSuccess(Languages.of(context)!.orderSucces);
                          setState(() {
                            chekingUser=false;
                          });
                        }
                      });
                    }, child: chekingUser? CircularProgressIndicator() :
                  Text(Languages.of(context)!.orderConfirmation,
                    style: TextStyle(
                        fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                        'Cairo' : 'Nunito'
                    ),),)
                ],
              ),
            ),
          ],
        ),
      ),
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
            return [
               SliverAppBar(
                iconTheme: const IconThemeData(
                  color: Colors.black
                ),
                floating: true,
                snap: true,
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                title: Text(Languages.of(context)!.cart,
                  style: TextStyle(fontSize: 20,
                      fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                      'Cairo' : 'Nunito',
                      color: Colors.black),),
              ),
            ];
          }

          , body: _cartProvider.cartQuantity>0?SingleChildScrollView(
             scrollDirection: Axis.vertical,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                 crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   Column(
                          children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(Languages.of(context)!.youhaveSelected,
                            style: TextStyle(
                              fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                              'Cairo' : 'Nunito',
                                fontSize: 12,color: Colors.grey
                          ),),
                          Text(' : ${_cartProvider.cartQuantity} ',
                    style: TextStyle(fontSize: 12,color: Colors.grey)),
                        ],
                      ),
                    Text(' To Pay : ${_cartProvider.subTotal.toStringAsFixed(0)} R.O ',
                        style: TextStyle(fontSize: 12,color: Colors.grey)),
                   ],
                  ),

                  Column(
                    children: [
                      doc==null? Container():Container(

                        child: Column(
                          children: [
                            ListTile(
                              leading: Container(

                                height: 100,width: 100,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.network((doc?.data() as dynamic)['url'],fit: BoxFit.cover,)),
                              ),
                              title: Text((doc?.data()as dynamic)['shopname']),
                              subtitle: Text("Address : "+ (doc?.data()as dynamic)['address']),
                            ),
                            Divider(color: Colors.grey,),

                            const CodToggleSwitch(),
                            Divider(color: Colors.grey,)
                          ],
                        ),
                      ),
                      CartList(document: widget.document,),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 100.0),
                    child: SizedBox(height: 100,),
                  ),
                   ],

                  ),
                  ),
                 ),
          ):Center(child: Container(
        width: 300,
            height: 200,
            child: Card(

                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: const [
                      Icon(Icons.add_shopping_cart_outlined),
                      Text("Your Cart is Empty!!"),
                    ],
                  ),
                ),
      ),
          ),
      ),
              ),
            );
  }
  saveOrder(CartProvider cartProvider,payable,AuthProvider authProvider){
  _orderServices.saveOrder({
    'employers': cartProvider.cartList,
    'userID': user!.uid,
    'total':payable,
    'cod' :cartProvider.cod,
    'seller': {
      'shopname':(widget.document.data() as dynamic)['shopname'],
      'sellerId':(widget.document.data()as dynamic)['selleruid'],

    },
    'TimeStamp':DateTime.now().toString(),
    'orderStatus': 'ordered',
    'userDetails': authProvider.documentSnapshot!.data()


  }).then((value){
  _cartServices.deleteCart().then((value){
    Navigator.pop(context);
  });

  });


  }
}
