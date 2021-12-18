 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_app/Pages/product_details_screen.dart';
import 'package:desktop_app/Pages/product_favourite_details.dart';
import 'package:desktop_app/localization/language/languages.dart';
import 'package:desktop_app/provider/auth_provider.dart';
import 'package:desktop_app/services/cart_services.dart';
import 'package:desktop_app/services/product_service.dart';
import 'package:desktop_app/widgets/product/product_card_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class MyFavouriteItems extends StatefulWidget {
   const MyFavouriteItems({Key? key}) : super(key: key);

  @override
  State<MyFavouriteItems> createState() => _MyFavouriteItemsState();
}

class _MyFavouriteItemsState extends State<MyFavouriteItems> {
  final ProductServices productServices=ProductServices();
  User ?user=FirebaseAuth.instance.currentUser;
  final CartServices  _cart = CartServices();
  @override
  void didChangeDependencies() {
    var _provider = Provider.of<AuthProvider>(context);
    _provider.getUserDetails();
    super.didChangeDependencies();
  }
   @override
   Widget build(BuildContext context) {
     var _provider = Provider.of<AuthProvider>(context);
     return Scaffold(
       appBar: AppBar(
         title:  Text(Languages.of(context)!.favourite,
           style: TextStyle(
               fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
               'Cairo' : 'Nunito'
           ),),
         centerTitle: true,
       ),
       body: StreamBuilder<QuerySnapshot>(
         stream: productServices.favourites.
         where('custumerId',isEqualTo:_provider.uuser!.uid ).snapshots(),
         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> ?snapshot) {
       if (snapshot!.hasError) {
         return const Center(child: Text('went wrong'),);
       }

       if(!snapshot.hasData) {
         return Center(child: Text("You don t Have Favourite Employer !!"),);
       }
        if(snapshot.hasData){
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot ?document) {
              Map<String, dynamic> data = document!.data()! as Map<String, dynamic>;
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
                              settings: const RouteSettings(name: ProductFavouriteDetailsScreen.id),
                              screen:  ProductFavouriteDetailsScreen(document: document),
                              withNavBar: false,
                              pageTransitionAnimation: PageTransitionAnimation.cupertino,
                            );
                          },
                          child: SizedBox(
                            height: 160,width: 130,

                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network((document.data()as dynamic)['product']['productUrl'])),
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
                                        Text((document.data()as dynamic)['product']['nationality'],
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

                                        Text((document.data()as dynamic)['product']['productName'],

                                        ),
                                        SizedBox(width: 50,),
                                        TextButton(onPressed: () {
                                          pushNewScreenWithRouteSettings(
                                            context,
                                            settings: const RouteSettings(name: ProductFavouriteDetailsScreen.id),
                                            screen:  ProductFavouriteDetailsScreen(
                                                document: document),
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
                                          Text((document.data()as dynamic)['product']['postappliedfor'],
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
                                        Text((document.data()as dynamic)['product']['salary'].toString() +" R.O"),
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
                                  children: [

                                    InkWell(
                                      onTap: (){
                                        EasyLoading.show(status: Languages.of(context)!.removeFromFavourites);
                                        removeitem(document.id).then((value){
                                          EasyLoading.showSuccess(Languages.of(context)!.removeFromFavourites);
                                        });
                                      },
                                      child:  Card(
                                        color: Colors.red,
                                        child: Padding(
                                          padding: EdgeInsets.only(left:30,right: 30,top:7 ,bottom:7 ),
                                          child: Text(Languages.of(context)!.removeFromFavourites,
                                            style: TextStyle(color: Colors.white,
                                                fontFamily: Localizations.localeOf(context).
                                                languageCode == 'ar'?
                                                'Cairo' : 'Nunito'),
                                          ),
                                        ),
                                      ),
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
            }).toList(),
          );
        }
       return ListView(
         children: snapshot.data!.docs.map((DocumentSnapshot ?document) {
           Map<String, dynamic> data = document!.data()! as Map<String, dynamic>;
           return Container(
             height: 190,
             width: MediaQuery.of(context).size.width,
             decoration: const BoxDecoration(
                 border: Border(
                     bottom: BorderSide(width: 1,color: Colors.grey)
                 )
             ),
             child: Padding(
               padding: const EdgeInsets.only(top: 8.0,bottom: 8.0,right: 10),

               child: Row(
                 children: [
                   Material(
                     elevation: 5,
                     borderRadius: BorderRadius.circular(10),
                     child: InkWell(
                       onTap: (){
                         pushNewScreenWithRouteSettings(
                           context,
                           settings: const RouteSettings(name: ProductFavouriteDetailsScreen.id),
                           screen:  ProductFavouriteDetailsScreen(document: document),
                           withNavBar: false,
                           pageTransitionAnimation: PageTransitionAnimation.cupertino,
                         );
                       },
                       child: SizedBox(
                         height: 160,width: 130,

                         child: ClipRRect(
                             borderRadius: BorderRadius.circular(10),
                             child: Image.network(data['product']['productUrl'])),
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
                               Text(data['product']['nationality'],style: TextStyle(
                                 fontSize: 10,
                               ),
                               ),
                               SizedBox(height: 6,),
                               Text(data['product']['productName']),
                               SizedBox(height: 6,),
                               Container(
                                 padding: EdgeInsets.only(top: 10,bottom: 10,left: 6),
                                 width: MediaQuery.of(context).size.width-180,
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(4),
                                   color: Colors.grey,

                                 ),
                                 child: Row(
                                   children: [
                                     Text("Religion : "),
                                     Text(data['product']['religion'],style: TextStyle(
                                     ),
                                     ),
                                   ],
                                 ),
                               ),
                               SizedBox(height: 6,),
                               Text(data['product']['salary'].toString() +" R.O"),

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
                               children: [

                                 InkWell(
                                   onTap: (){
                                     EasyLoading.show(status: 'Removing...');
                                     removeitem(document.id).then((value){
                                       EasyLoading.showSuccess('item removed from your favourites');
                                     });
                                   },
                                   child: const Card(
                                     color: Colors.red,
                                     child: Padding(
                                       padding: EdgeInsets.only(left:30,right: 30,top:7 ,bottom:7 ),
                                       child: Text('remove from favourite',
                                         style: TextStyle(color: Colors.white),
                                       ),
                                     ),
                                   ),
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
         }).toList(),
       );
     },
     )
     );
   }
   Future<void>removeitem(docId)async{
     return productServices.favourites.doc(docId).delete();
   }
}

