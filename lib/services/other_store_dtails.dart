import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_app/Pages/vendor_homescreen.dart';
import 'package:desktop_app/Pages/welcome_screen.dart';
import 'package:desktop_app/localization/language/languages.dart';
import 'package:desktop_app/provider/auth_provider.dart';
import 'package:desktop_app/services/store_service.dart';
import 'package:desktop_app/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class OtherPickStore extends StatefulWidget {
  const OtherPickStore({Key? key}) : super(key: key);

  @override
  _OtherPickStoreState createState() => _OtherPickStoreState();
}

class _OtherPickStoreState extends State<OtherPickStore> {
  Storeservices _storeservices = Storeservices();
  UserServices _userServices = UserServices();
  User? user = FirebaseAuth.instance.currentUser;
  var _userlaltitude = 0.0;
  var _userlogitude = 0.0;

  @override
  void initState() {
    _userServices.getUserById(user!.uid).then((result){
      if(user!=null) {

        setState(() {
          _userlaltitude = ((result.data() as dynamic)['laltitude']);
          _userlogitude = ((result.data() as dynamic)['longitude']);
        });



      }else {
        Navigator.pushReplacementNamed(context, WelcomeScreen.id);
      }
    });
    super.initState();
  }

  String getDistance(location){
    var distance = Geolocator.distanceBetween(_userlaltitude,
        _userlogitude,
        location.latitude,
        location.longitude);
    var distanceKM=distance/1000;
    return distanceKM.toStringAsFixed(2);
  }
  @override
  Widget build(BuildContext context) {
    var _authData = Provider.of<AuthProvider>(context);
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _storeservices.getOrdinaryPickedStore(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){

            return const Center( child:  Text('No data to Show'),);
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(

                  children: [

                    Text(Languages.of(context)!.otherStore,style: TextStyle(
                        fontSize: 22,fontWeight:FontWeight.bold ,
                        fontFamily: Localizations.localeOf(context).
                        languageCode == 'ar'?
                        'Cairo' : 'Nunito',
                    ),),
                    SizedBox(width: 20,),


                  ],
                ),
              ),
              Flexible(

                child: Wrap(
                  direction: Axis.horizontal,
                  children:snapshot.data!.docs.map((DocumentSnapshot docu){

                    return InkWell(
                      onTap: (){
                        _authData.getSelectedStore(docu);
                        pushNewScreenWithRouteSettings(
                          context,
                          settings: const RouteSettings(name: VendorHomeScreen.id),
                          screen: const VendorHomeScreen(),
                          withNavBar: true,
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          width: 150,
                          child: Column(
                            children: [

                              SizedBox(
                                child: Card(child:
                                ClipRRect(

                                  child: Image.network(docu['url'],fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                ),
                                height: 150,
                                width: 150,

                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    child: Text(docu['shopname'],style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 16,
                                    ),
                                      maxLines: 3,
                                    ),
                                    height: 25,
                                    width: 120,
                                  ),

                                  Text('${getDistance(docu['location']).toString()} KM',
                                    style: TextStyle(color: Colors.orange,
                                        fontWeight: FontWeight.bold),),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              )
                            ],
                          ),

                        ),
                      ),
                    );

                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}