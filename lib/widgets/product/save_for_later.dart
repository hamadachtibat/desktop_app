import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_app/localization/language/languages.dart';
import 'package:desktop_app/provider/auth_provider.dart';
import 'package:desktop_app/services/product_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class SaveForLater extends StatefulWidget {
  final DocumentSnapshot document;
  const SaveForLater({Key? key, required this.document}) : super(key: key);

  @override
  State<SaveForLater> createState() => _SaveForLaterState();
}

class _SaveForLaterState extends State<SaveForLater> {
  @override
  void initState() {
    getCartData();
    super.initState();
  }

  getCartData() async{
    final snap = await _favouriteServices.favourites.where('custumerId',
        isEqualTo: user!.uid).get();
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

  final ProductServices _favouriteServices = ProductServices();

  User?user = FirebaseAuth.instance.currentUser;

  bool _isloading = true;

  bool _exist = false;

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<AuthProvider>(context);
    FirebaseFirestore.instance
        .collection('favourites').
    where('custumerId',isEqualTo:user!.uid).where(
        'product.productId',isEqualTo:(widget.document.data()as dynamic)['productId'] )
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if((doc['custumerId'])==_provider.uuser!.uid){
setState(() {
   _exist=true;
});
        }
      });
    });

    return _exist?
    InkWell(
      onTap: (){
        EasyLoading.showInfo(Languages.of(context)!.employerAlreadySaved,
          duration: const Duration(
              seconds: 3
          ),
          dismissOnTap: true,
        );

      },
      child: Container(
        height: 56,
        color: Colors.grey,
        child:  Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                Text(Languages.of(context)!.addtofavourite,
                    style: TextStyle(
                      fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                      'Cairo' : 'Nunito',)
                ),
                SizedBox(width: 5,),
                Icon(CupertinoIcons.heart),
              ],
            ),
          ),
        ),),
    ) :InkWell(
      onTap: (){
        EasyLoading.show(status: 'Saving...');
        saveForLater().then((value){
          EasyLoading.showSuccess(Languages.of(context)!.savetofavourites);
          setState(() {
            _exist=true;
          });
        });
      },
      child: Container(
        height: 56,
        color: Colors.grey,
        child:  Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                Text(Languages.of(context)!.addtofavourite,
                    style: TextStyle(
                      fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                      'Cairo' : 'Nunito',)
                ),
                SizedBox(width: 5,),
                Icon(CupertinoIcons.heart)
              ],
            ),
          ),
        ),),
    );
  }

  Future<DocumentReference> saveForLater()async{

    CollectionReference _favourites = FirebaseFirestore.instance.collection('favourites');
    User ?user = FirebaseAuth.instance.currentUser;
    return _favourites.add({
      'product':widget.document.data(),
      'custumerId':user!.uid,
    });
  }
}
