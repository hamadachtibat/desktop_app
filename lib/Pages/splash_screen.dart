import 'dart:async';

import 'package:desktop_app/Pages/landing_page.dart';
import 'package:desktop_app/Pages/main_screen.dart';
import 'package:desktop_app/Pages/welcome_screen.dart';
import 'package:desktop_app/services/fcm_notification_handler.dart';
import 'package:desktop_app/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String id="Splash-screen";
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 3,),(){
        FirebaseAuth.instance.authStateChanges().listen((User ?user) {
          if(user==null){
            Navigator.pushReplacementNamed(context, WelcomeScreen.id);
          }else{
            getUserData();
          }
        });
    }
    );
    super.initState();





  }
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("images/logo.png"),
            const Text("DesktopApp", style: TextStyle(fontSize: 15,
                fontWeight: FontWeight.bold),
            ),
          ],
        ),


      ),
    );
  }

  getUserData() async{
    UserServices _userServices = UserServices();
    _userServices.getUserById(user!.uid).then((result){
      if((result.data()as dynamic)['address'] != null){
        updateprefs(result);
      } else{
        Navigator.pushReplacementNamed(context,WelcomeScreen.id);
      }

    });

  }
  Future<void> updateprefs(result) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setDouble('latitude', result['laltitude']);
    preferences.setDouble('longitude', result['longitude']);
    preferences.setString('address', result['address']);
    preferences.setString('location', result['location']== null? "" :result['location'] );
    Navigator.pushReplacementNamed(context, MainScreen.id);

  }

}