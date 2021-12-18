import 'package:desktop_app/Pages/home_screen.dart';
import 'package:desktop_app/Pages/map_screen.dart';
import 'package:desktop_app/provider/location_provider.dart';
import 'package:desktop_app/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);
  static const String id = 'landing-page';

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  LocationProvider _locationProvider = LocationProvider();
  User? user = FirebaseAuth.instance.currentUser;
   late String _location='';
   late String  _address='';
  @override
  void initState() {
    UserServices _userServices =UserServices();
    _userServices.getUserById(user!.uid).then((result) async{
      if(result!=null){
        if((result.data() as dynamic)['laltitude']!=null){
          getprefs(result);
        }else{
          _locationProvider.getCurrentPosition();
          if(_locationProvider.permission==true){
            Navigator.pushNamed(context, MapScreen.id);
          }else{print("permission not allowed");}
        }
      }
    });
    super.initState();
  }
  getprefs(dbResult) async{
    SharedPreferences preferences = await SharedPreferences.getInstance() ;
    String? location = preferences.getString('location');
    if(location==null){
      preferences.setString('address', dbResult.data()['location']);
      preferences.setString('location', dbResult.data()['address']);
      if(mounted){
        setState(() {
          _location = dbResult.data()['location'];
          _address = dbResult.data()['address'];
        });
      }
      Navigator.pushReplacementNamed(context, HomeScreen.id);

    }

    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body : Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
            Padding(
              padding: EdgeInsets.all(8),
                child: Text(_location==null ? "" : _location),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_address==null ? 'please enter you address' : _address,
                style: TextStyle(fontWeight: FontWeight.bold,),),
            ),
            Image.asset("images/city.jpeg",fit: BoxFit.fill,),
            Visibility(
              visible: _location!=null? true:false,
              child: FlatButton(onPressed: (){
                Navigator.pushNamed(context, HomeScreen.id);
              }, child: Text(" confirm location"),color: Colors.orange,),
            ),
              FlatButton(onPressed: (){
                _locationProvider.getCurrentPosition();
                if(_locationProvider.featuredname!=null){
                  Navigator.pushNamed(context, MapScreen.id);
                }else{
                  print('permession not allowed');
                }

              }, child: Text(_location!=null ? "update location " : 'confirm location'
                ),
                color: Colors.green,
              )
            ],
          ),

      ),
    );
  }
}
