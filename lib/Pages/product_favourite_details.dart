import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_app/localization/language/languages.dart';
import 'package:desktop_app/widgets/product/bottom_sheet_container.dart';
import 'package:desktop_app/widgets/product/cart/favourite_bottom_sheet.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


class ProductFavouriteDetailsScreen extends StatelessWidget {
  const ProductFavouriteDetailsScreen({Key? key, required this.document}) : super(key: key);

  static const String id = 'product-favourite-screen';
  final DocumentSnapshot document;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
              onPressed: (){},
              icon: const Icon(CupertinoIcons.search)
          ),
        ],
      ),
      bottomSheet: BottomFavouriteSheetContainer(documents: document,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: 200,
                height: 200,
                child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 80,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(90),
                        child: Image.network(
                          (document.data()as dynamic)['product']['productUrl'],fit: BoxFit.fill,width: 150,))),
              ),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Chip(
                  avatar: CircleAvatar(
                      backgroundColor: Colors.white,
                      child:  (document.data()as dynamic)['product']['cleaning']=='yes'?
                      Icon(Icons.check,color: Colors.green,):Icon(Icons.block,color: Colors.red,)
                  ),
                  label:   Text(Languages.of(context)!.cleaning,style: TextStyle(
                      fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                      'Cairo' : 'Nunito'
                  ),),
                ),
                Chip(
                  avatar: CircleAvatar(
                      backgroundColor: Colors.white,
                      child:  (document.data()as dynamic)['product']['washing']=='yes'?
                      Icon(Icons.check,color: Colors.green,):Icon(Icons.block,color: Colors.red,)
                  ),
                  label:  Text(Languages.of(context)!.washing,style: TextStyle(
                      fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                      'Cairo' : 'Nunito'
                  ),),
                ),
                Chip(
                  avatar: CircleAvatar(
                      backgroundColor: Colors.white,
                      child:  (document.data()as dynamic)['product']['babySitting']=='yes'?
                      Icon(Icons.check,color: Colors.green,):Icon(Icons.block,color: Colors.red,)
                  ),
                  label:   Text(Languages.of(context)!.babysitting,
                    style: TextStyle(
                        fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                        'Cairo' : 'Nunito'
                    ),
                  ),),
              ],
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(

                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.green,
                        width: 2
                    ),
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(Languages.of(context)!.employerName,style: TextStyle(
                          fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                          'Cairo' : 'Nunito'
                      ),),
                      Text( (document.data()as dynamic)['product']['productName']),
                    ],
                  ),
                ),),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(

                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.green,
                        width: 2
                    ),
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(Languages.of(context)!.function,
                          style: TextStyle(
                            fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                            'Cairo' : 'Nunito',)
                      ),
                      Text((document.data()as dynamic)['product']['postappliedfor']),
                    ],
                  ),
                ),),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(

                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.green,
                        width: 2
                    ),
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(Languages.of(context)!.nationality,
                        style: TextStyle(
                          fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                          'Cairo' : 'Nunito',),
                      ),
                      Text((document.data()as dynamic)['product']['nationality']),
                    ],
                  ),
                ),),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(

                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.green,
                        width: 2
                    ),
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(Languages.of(context)!.religion,style: TextStyle(
                        fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                        'Cairo' : 'Nunito',),),
                      Text((document.data()as dynamic)['product']['religion']),
                    ],
                  ),
                ),),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(

                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.green,
                        width: 2
                    ),
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(Languages.of(context)!.age,style: TextStyle(
                        fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                        'Cairo' : 'Nunito',),),
                      Text((document.data()as dynamic)['product']['age']),
                    ],
                  ),
                ),),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(

                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.green,
                        width: 2
                    ),
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(Languages.of(context)!.salary,style: TextStyle(
                        fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                        'Cairo' : 'Nunito',),),
                      Text((document.data()as dynamic)['product']['salary'].toString()+' R.O'),
                    ],
                  ),
                ),),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.green,
                        width: 2
                    ),
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(Languages.of(context)!.placebirth,
                          style: TextStyle(
                            fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                            'Cairo' : 'Nunito',)
                      ),
                      Text((document.data()as dynamic)['product']['placeofbirthday']),
                    ],
                  ),
                ),),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(

                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.green,
                        width: 2
                    ),
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(Languages.of(context)!.maritalstatus,
                          style: TextStyle(
                            fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                            'Cairo' : 'Nunito',)
                      ),
                      Text( (document.data()as dynamic)['product']['marriedStatus']),
                    ],
                  ),
                ),),
            ),
            SizedBox(height: 10,),
            Visibility(
              visible: (document.data()as dynamic)['product']['marriedStatus']=='yes'?true:false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(

                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.green,
                          width: 2
                      ),
                      borderRadius: BorderRadius.circular(50)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(Languages.of(context)!.childnumber,
                            style: TextStyle(
                              fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                              'Cairo' : 'Nunito',)
                        ),
                        Text( (document.data()as dynamic)['product']['numberOfchildren']),
                      ],
                    ),
                  ),),
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(

                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.green,
                        width: 2
                    ),
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(Languages.of(context)!.education,
                          style: TextStyle(
                            fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                            'Cairo' : 'Nunito',)
                      ),
                      Text( (document.data()as dynamic)['product']['education']),
                    ],
                  ),
                ),),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(

                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.green,
                        width: 2
                    ),
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(Languages.of(context)!.spookingarabic,
                          style: TextStyle(
                            fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                            'Cairo' : 'Nunito',)
                      ),
                      Text((document.data()as dynamic)['product']['spookingarabic']),
                    ],
                  ),
                ),),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(

                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.green,
                        width: 2
                    ),
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(Languages.of(context)!.height,
                          style: TextStyle(
                            fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                            'Cairo' : 'Nunito',)
                      ),
                      Text((document.data()as dynamic)['product']['height']),
                    ],
                  ),
                ),),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(

                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.green,
                        width: 2
                    ),
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(Languages.of(context)!.weight,
                          style: TextStyle(
                            fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                            'Cairo' : 'Nunito',)
                      ),
                      Text((document.data()as dynamic)['product']['weight']),
                    ],
                  ),
                ),),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(

                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.green,
                        width: 2
                    ),
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(Languages.of(context)!.dateofissue,
                          style: TextStyle(
                            fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                            'Cairo' : 'Nunito',)
                      ),
                      Text((document.data()as dynamic)['product']['dateofissue']),
                    ],
                  ),
                ),),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(

                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.green,
                        width: 2
                    ),
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(Languages.of(context)!.expirationdate,
                          style: TextStyle(
                            fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                            'Cairo' : 'Nunito',)
                      ),
                      Text( (document.data()as dynamic)['product']['dateofexp']),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 50,)

          ],
        ),
      ),
    );
  }

}