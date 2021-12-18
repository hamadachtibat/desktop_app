import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_app/provider/cart_provider.dart';
import 'package:desktop_app/services/cart_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class CartCard extends StatefulWidget {
  final DocumentSnapshot document;
   const CartCard({Key? key, required this.document}) : super(key: key);

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
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
      querySnapshot.docs.forEach((doc) {
        if(doc['productId']==(widget.document.data() as dynamic)['productId']){
          setState(() {
            _exist=true;
            doocId = doc.id;
          });
        }
      });
    });
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(
          color: Colors.grey,
        ),),
      ),
      height: 160,
      child: Column(

        children: [

          Row(
            children: [
              SizedBox(height: 120,width: 120,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network((widget.document.data()as dynamic)['productUrl']),
                ),
                ),
              SizedBox(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name : "+(widget.document.data()as dynamic)['productname']),
                  Text("Nationality: "+(widget.document.data()as dynamic)['nationality']),
                  const SizedBox(height: 20,),
                  Text("Experience: "+(widget.document.data()as dynamic)['yearsOfExperience']),
                  Row(
                    children: [

                      Text("Salary:"+(widget.document.data()as dynamic)['salary'].toStringAsFixed(0)+" R.O"),
                      SizedBox(width: 50,),
                      FutureBuilder(
                        future: getCartData(),
                        builder: (BuildContext context ,AsyncSnapshot<dynamic> snapshot ){
                          return InkWell(
                            onTap: (){
                              EasyLoading.show(status: 'Removing..');
                              RemovefromCart(doocId).then((value){
                                EasyLoading.showSuccess('Employer Removed from cart');
                              });
                            },
                            child: const Card(
                              color: Colors.red,
                              child: Padding(
                                padding: EdgeInsets.only(left:30,right: 30,top:7 ,bottom:7 ),
                                child: Icon(CupertinoIcons.delete,color: Colors.white,),
                              ),
                            ),
                          );
                        },

                      ),

                    ],

                  ),


                ],
              ),)
            ],
          ),

        ],
      ),
    );
  }

  Future<void>RemovefromCart(docId)async{
    _cartServices.cart.doc(user!.uid).
    collection('products').doc(docId).delete();
  }
}
