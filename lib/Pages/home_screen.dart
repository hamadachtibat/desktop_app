

import 'package:desktop_app/Pages/map_screen.dart';
import 'package:desktop_app/Pages/welcome_screen.dart';
import 'package:desktop_app/provider/auth_provider.dart';
import 'package:desktop_app/provider/location_provider.dart';
import 'package:desktop_app/services/fcm_notification_handler.dart';
import 'package:desktop_app/services/other_store_dtails.dart';
import 'package:desktop_app/services/top_picked_store.dart';
import 'package:desktop_app/widgets/imag_slider.dart';
import 'package:desktop_app/widgets/my_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String id ='Home-screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 String _location='';
 @override
  void initState() {
    getPrefs();
    FirebaseMessaging.instance.getToken().then((value){
      print('token value for this user $value');
    });
    FirebaseMessaging.instance.subscribeToTopic(
        FirebaseAuth.instance.currentUser!.uid).then((value) =>
        print('success'));
    initFirebaseMessagingHandler(channel!);
    super.initState();

  }
 getPrefs()async{
   SharedPreferences preferences = await SharedPreferences.getInstance();
   String? location = preferences.getString('location');
   setState(() {
     _location = location!;
   });
 }
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
          MyAppbar(),
          ];
        },
        body: SingleChildScrollView(

          child: Padding(
            padding: const EdgeInsets.only(top:8.0,),
            child: Column(
              children: [
                ImagSlider(),
                Container(
                height: 250,
                    child: TopPickStore()),
                SizedBox(height: 10,),
                Container(
                  height: 250,
                  child: OtherPickStore(),
                )


              ],
            ),
          ),
        ),
      ),
    );
  }
}
