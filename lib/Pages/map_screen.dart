


import 'package:desktop_app/Pages/logging_screen.dart';
import 'package:desktop_app/Pages/main_screen.dart';
import 'package:desktop_app/localization/language/languages.dart';
import 'package:desktop_app/provider/auth_provider.dart';
import 'package:desktop_app/provider/location_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);
static const String id = "map-screen";
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng currentLocation;
  late GoogleMapController _googleMapController;
  bool _locating = false;
  bool _islogging = false;
  User ?user;


  @override
  void initState() {
    getCurrentUser();
    // TODO: implement initState
    super.initState();
  }
 Future<void>getCurrentUser()async{
setState(() {
  user=FirebaseAuth.instance.currentUser;
  _islogging=false;
});
   if(user==null){
     setState(() {
       _islogging=false;
     });
   }
    if(user!=null){
      setState(() {
        _islogging=true;
        user=FirebaseAuth.instance.currentUser!;
      });
    }
 }
  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    final _auth =Provider.of<AuthProvider>(context);
    setState(() {
      currentLocation = LatLng(locationData.latitude,locationData.longitude);
    });
    void onMapCreated(GoogleMapController controller){
      setState(() {
        _googleMapController = controller;
      });
    }
    return  Scaffold(
      body:

          SafeArea(child: Stack(
            children:[
              GoogleMap(
                initialCameraPosition: CameraPosition(target: currentLocation,zoom: 14.4746),
                zoomControlsEnabled: false,
                minMaxZoomPreference: const MinMaxZoomPreference(
                    1.5,20.8
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                mapToolbarEnabled: true,
                onCameraMove: (CameraPosition cameraPosition){
                  setState(() {
                    _locating=true;
                  });
                  locationData.onCameraMove(cameraPosition);
                },
                onMapCreated: onMapCreated,
                onCameraIdle: (){
                  setState(() {

                    _locating=false;
                  });
                  locationData.getCameraMove();
                },
              ),
              Center(
                child: Container(
                    height:50,
                    margin: const EdgeInsets.only(bottom: 40),
                    child: Image.asset("images/marker.png")),),
                 Positioned(
                   bottom: 0.0,
                   child:
                   Container(
                     height: 200,
                     width: MediaQuery.of(context).size.width,
                     color: Colors.white,
                     child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         _locating? const LinearProgressIndicator(
                           color: Colors.green,
                           backgroundColor: Colors.black12,
                         ):Container(),
                         TextButton.icon(
                           onPressed: (){},
                           icon:const Icon(Icons.location_on,color: Colors.green,) ,
                           label: Text(Provider.of<LocationProvider>(context).featuredname,
                             style: const TextStyle(fontWeight: FontWeight.bold,
                               fontSize: 18,
                               color: Colors.black,

                             ),
                           ),
                         ),
                         Text(Provider.of<LocationProvider>(context).addressLine),
                         SizedBox(height: 20,),
                         AbsorbPointer(
                           absorbing: _locating?true:false,
                           child: FlatButton(onPressed: (){
                             locationData.savePref();
                             if(_islogging==false){
                               Navigator.pushNamed(context, LoggingScreen.id);
                             }else{
                               setState(() {
                                 _auth.latitude=locationData.latitude;
                                 _auth.longitude=locationData.longitude;
                                 _auth.address=locationData.addressLine.toString();
                                 _auth.location = locationData.featuredname;
                               });
                               _auth.updateUser(
                                   id: user?.uid, number: user?.phoneNumber,
                               );
                               Navigator.pushNamed(context, MainScreen.id);
                             }
                           },
                             child: Text(Languages.of(context)!.confirmlocation,
                             style: TextStyle(fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                             'Cairo' : 'Nunito'
                             ),),
                           color: _locating? Colors.grey :Colors.green,),
                         )

                       ],
                     ),
                   ),
                 ),
            ]
          ),
          ),



    );
  }
}
