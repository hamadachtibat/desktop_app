


import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider with ChangeNotifier{


  late double latitude=0;
   late double longitude=0;
  bool permission=false;
    String addressLine='Searching';
    String featuredname = 'searching';
  bool loading=false;



  Future<Position> getCurrentPosition()async {
    Position position = await Geolocator.
    getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if(position!=null){
      latitude=position.latitude;
      longitude =position.longitude;
      permission=true;
      notifyListeners();

    }else {
      print("Permission not allowed");
    }
   return position;
  }
  void onCameraMove(CameraPosition cameraPosition)async{
   latitude = cameraPosition.target.latitude;
   longitude = cameraPosition.target.longitude;
   notifyListeners();
  }
   Future<void> getCameraMove() async{
    final coordinates = Coordinates(latitude, longitude);
    final address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    addressLine  = address.first.addressLine;
    featuredname=address.first.featureName;
    notifyListeners();

   }
   Future<void> savePref() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setDouble('latitude', latitude);
    preferences.setDouble('longitude', longitude);
    preferences.setString('address', addressLine);
    preferences.setString('location', featuredname);


   }
}