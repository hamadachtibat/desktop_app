import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_app/Pages/product_details_screen.dart';
import 'package:desktop_app/localization/language/languages.dart';
import 'package:desktop_app/services/cart_services.dart';
import 'package:desktop_app/widgets/product/save_for_later.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class ProductCard extends StatefulWidget {
  final DocumentSnapshot document ;
  const ProductCard({Key? key, required this.document}) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  void initState() {
    getCartData();
    super.initState();
  }
  getCartData() async{
    final snap =  await _cartServices.cart.doc(user!.uid).collection('products').get();
    if(snap.docs.isEmpty){
      setState(() {
        _isloading = false;
      });
    }else{
      setState(() {
        _isloading = false;
      });
    }
  }
  final CartServices _cartServices = CartServices();
  User?user = FirebaseAuth.instance.currentUser;
  bool _isloading = true;
  bool _exist = false;
  String ?doocId;
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('cart').doc(user!.uid).collection('products').
    where('productId',isEqualTo:(widget.document.data() as dynamic)['productId'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if(doc['productId']==(widget.document.data() as dynamic)['productId']){
          setState(() {
            _exist=true;
            doocId = doc.id;
          });
        }
      }
    });
    return Container(
      height: 230,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1,color: Colors.grey)
        )
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0,bottom: 8.0,right: 10,left: 10),

        child: Row(
          children: [
           Material(
             elevation: 5,
             borderRadius: BorderRadius.circular(10),
             child: InkWell(
               onTap: (){
                 pushNewScreenWithRouteSettings(
                   context,
                   settings: const RouteSettings(name: ProductDetailsScreen.id),
                   screen:  ProductDetailsScreen(document: widget.document),
                   withNavBar: false,
                   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                 );
               },
               child: SizedBox(
                 height: 160,width: 130,

               child: ClipRRect(
                   borderRadius: BorderRadius.circular(10),
                   child: Image.network((widget.document.data()as dynamic)['productUrl'])),
               ),
             ),
           ),
            Container(child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Row(
                            children: [
                              Text(Languages.of(context)!.nationality,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: Localizations.localeOf(context).
                                languageCode == 'ar'?
                                'Cairo' : 'Nunito'),),
                              Text((widget.document.data()as dynamic)['nationality'],
                                style: TextStyle(
                                fontSize: 10,
                              ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6,),
                        Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                          child: Row(
                            children: [
                              Text(Languages.of(context)!.employerName,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: Localizations.localeOf(context).
                                    languageCode == 'ar'?
                                    'Cairo' : 'Nunito'),
                              ),

                              Text((widget.document.data()as dynamic)['productName'],

                              ),
                              SizedBox(width: 50,),
                              TextButton(onPressed: () {
                                pushNewScreenWithRouteSettings(
                                  context,
                                  settings: const RouteSettings(name: ProductDetailsScreen.id),
                                  screen:  ProductDetailsScreen(document: widget.document),
                                  withNavBar: false,
                                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                );
                              }, child: Text(Languages.of(context)!.details

                                ,style: TextStyle(
                                color: Colors.white,
                                    fontFamily: Localizations.localeOf(context).
                                    languageCode == 'ar'?
                                    'Cairo' : 'Nunito'
                              ),),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.blueAccent)
                                ),
                              )
                              /*PopupMenuButton<String>(

                               onSelected: (String value){
                                },
                               itemBuilder: (BuildContext context)=> <PopupMenuEntry<String>> [
                                PopupMenuItem<String>(
                                 value: 'More details',
                                 child: ListTile(
                                 leading:Icon(Icons.check) ,
                                  title: Text('More details'),
                                   onTap: (){
                                     pushNewScreenWithRouteSettings(
                                       context,
                                       settings: const RouteSettings(name: ProductDetailsScreen.id),
                                       screen:  ProductDetailsScreen(document: widget.document),
                                       withNavBar: false,
                                       pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                     );
                                   },
    ),
    ),

    ]

    ),*/
                            ],
                          ),
                        ),
                        SizedBox(height: 6,),
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Container(
                            padding: EdgeInsets.only(top: 10,bottom: 10,left: 6,right: 8),
                            width: MediaQuery.of(context).size.width-180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.grey,

                            ),
                            child: Row(
                              children: [
                                Text(Languages.of(context)!.function,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: Localizations.localeOf(context).
                                      languageCode == 'ar'?
                                      'Cairo' : 'Nunito'),
                                ),
                                Text((widget.document.data()as dynamic)['postappliedfor'],
                                  style: TextStyle(

                                ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 6,),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Row(
                            children: [
                              Text(Languages.of(context)!.salary,style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: Localizations.localeOf(context).
                                  languageCode == 'ar'?
                                  'Cairo' : 'Nunito'),
                              ),
                              Text((widget.document.data()as dynamic)['salary'].toString() +" R.O"),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),

             Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width-160,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children:  [
                          _exist ? FutureBuilder(
                            future: getCartData(),
                            builder: (BuildContext context ,AsyncSnapshot<dynamic> snapshot ){
                              return InkWell(
                                onTap: (){
                                  EasyLoading.show(status: 'Removing..');
                                  RemovefromCart(doocId).then((value){
                                    EasyLoading.showSuccess(
                                        Languages.of(context)!.removeItem);
                                    setState(() {
                                      _exist =false;
                                    });

                                  });


                                },
                                child:  Card(
                                  color: Colors.red,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:30,right: 30,top:7 ,bottom:7 ),
                                    child: Text(Languages.of(context)!.removeFromCart,
                                      style:  TextStyle(color: Colors.white,
                                          fontSize: 15,
                                          fontFamily: Localizations.localeOf(context).
                                          languageCode == 'ar'?
                                          'Cairo' : 'Nunito'

                                      ),
                                    ),
                                  ),
                                ),

                              );
                            },
                          ):
                          FutureBuilder(
                            future: getCartData(),
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                              return InkWell(
                                onTap: (){
                                  EasyLoading.show(status: 'Adding....');
                                  _cartServices.addToCart(widget.document).then((value){
                                    EasyLoading.showSuccess('In Cart');
                                    setState(() {
                                      _exist = true;
                                    });
                                  });
                                },
                                child:  Card(
                                  color: Colors.pink,
                                  child: Padding(
                                    padding: EdgeInsets.only(left:30,right: 30,top:7 ,bottom:7 ),
                                    child: Text(Languages.of(context)!.add,
                                      style: TextStyle(color: Colors.white,
                                          fontFamily: Localizations.localeOf(context).
                                          languageCode == 'ar'?
                                          'Cairo' : 'Nunito'
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          ),

                        ],
                      ),
                    ),

                  ],
                ),

              ],
            ),)
          ],
        ),
      ),
    );
  }
  Future<void>RemovefromCart(docId)async{
    _cartServices.cart.doc(user!.uid).collection('products').doc(docId).delete();
  }
}
