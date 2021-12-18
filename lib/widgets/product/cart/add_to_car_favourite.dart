import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_app/localization/language/languages.dart';
import 'package:desktop_app/services/cart_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';




class AddToCartFavouriteWidget extends StatefulWidget {
  final DocumentSnapshot document ;
  const AddToCartFavouriteWidget({Key? key, required this.document}) : super(key: key);

  @override
  _AddToCartFavouriteWidgetState createState() => _AddToCartFavouriteWidgetState();
}

class _AddToCartFavouriteWidgetState extends State<AddToCartFavouriteWidget> {

  @override
  void initState() {
    getCartData();
    super.initState();
  }
  getCartData() async{
    final snap = await _cartServices.cart.doc(user!.uid).collection('products').get();
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
    where('productId',isEqualTo:(widget.document.data() as dynamic)['product']['productId'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if(doc['productId']==(widget.document.data() as dynamic)['product']['productId']){
          setState(() {
            _exist=true;
            doocId = doc.id;
          });
        }
      });
    });



    return _isloading ? Container(
      height: 56,
      child: const Center(child: CircularProgressIndicator(),),
    ):_exist?
    InkWell(
      onTap: (){
        EasyLoading.show(status: Languages.of(context)!.removeFromCart);
        RemovefromCart(doocId).then((value){
          EasyLoading.showSuccess(Languages.of(context)!.removeFromCart);
          setState(() {
            _exist =false;
          });
        });


      },
      child: Container(
        height: 56,
        color: Colors.red[300],
        child:  Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                Text(Languages.of(context)!.removeFromCart,
                  style: TextStyle(
                      fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                      'Cairo' : 'Nunito'
                  ),
                ),
                SizedBox(width: 5,),
                Icon(CupertinoIcons.cart),
              ],
            ),
          ),
        ),),
    ) :

    InkWell(
      onTap: (){
        EasyLoading.show(status: 'Adding....');
        _cartServices.addToFavouriteCart(widget.document).then((value){
          EasyLoading.showSuccess('In Cart');
          setState(() {
            _exist =true;
          });
        });

      },
      child: Container(
        height: 56,
        color: Colors.red[300],
        child:  Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                Text(Languages.of(context)!.add,
                  style: TextStyle(
                      fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                      'Cairo' : 'Nunito'
                  ),),
                SizedBox(width: 5,),
                Icon(CupertinoIcons.cart),
              ],
            ),
          ),
        ),),
    );
  }
  Future<void>RemovefromCart(docId)async{
    _cartServices.cart.doc(user!.uid).collection('products').doc(docId).delete();
  }
}