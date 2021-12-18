import 'package:desktop_app/Pages/my_order_screen.dart';
import 'package:desktop_app/Pages/profile_update_screen.dart';
import 'package:desktop_app/Pages/welcome_screen.dart';
import 'package:desktop_app/localization/language/languages.dart';
import 'package:desktop_app/provider/auth_provider.dart';
import 'package:desktop_app/provider/location_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';
import 'map_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const String id = 'profile-screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    var _userProvider = Provider.of<AuthProvider>(context);
    var locationData= Provider.of<LocationProvider>(context);

    _userProvider.getUserDetails();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          pushNewScreen(
            context,
            screen: HomeScreen(),
            withNavBar: true, // OPTIONAL VALUE. True by default.
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        }, icon: Icon(Icons.arrow_back_ios)),
        elevation: 0,
        title:  Text(Languages.of(context)!.myAccount,
          style: TextStyle(
              fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
              'Cairo' : 'Nunito'
          ),
        ),
        centerTitle: true,

      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Center(
          child: Column(
            children:  [
               
              _userProvider.documentSnapshot==null ? Container(): Container(
                color: Colors.redAccent,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                               CircleAvatar(
                                radius: 40,
                                child: Text("P",style: TextStyle(fontSize: 25),)
                              ),
                              const SizedBox(width: 10,),
                              SizedBox(
                               height: 120,
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Row(
                                     children: [

                                       Text((_userProvider.documentSnapshot?.data()as dynamic)['firstName']!= null ?
                                           '${(_userProvider.documentSnapshot?.data()as dynamic)['firstName']}'
                                               ' ${(_userProvider.documentSnapshot?.data()as dynamic)['lastName']} '

                                         :'Edit the Name',style:
                                       const TextStyle(fontSize:20,color: Colors.white),
                                       ),
                                       SizedBox(width: 50,),
                                       IconButton(
                                         onPressed: (){
                                           pushNewScreenWithRouteSettings(
                                             context,
                                             settings: const RouteSettings(name: UpdateProfileScreen.id),
                                             screen: const UpdateProfileScreen(),
                                             withNavBar: false,
                                             pageTransitionAnimation:
                                             PageTransitionAnimation.cupertino,
                                           );
                                         },
                                         icon: const Icon(
                                           Icons.edit,color: Colors.white,),),
                                     ],
                                   ),
                                   Text((_userProvider.documentSnapshot?.data()as dynamic)['email'] !=null ?
                                   '${(_userProvider.documentSnapshot?.data()as dynamic)['email']}'
                                       :'Your Email',style:
                                   const TextStyle(fontSize:20,color: Colors.white),
                                   ),
                                   Text(_userProvider.uuser!.phoneNumber.toString(),style:
                                   const TextStyle(fontSize:20,color: Colors.white),),

                                 ],
                               ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            padding: const EdgeInsets.all(8),
                            color: Colors.white,
                            child: ListTile(
                              tileColor: Colors.white,
                              leading: const Icon(Icons.location_on,color: Colors.black,),
                              title: Text((_userProvider.
                              documentSnapshot?.data()as dynamic)['address']),
                              subtitle: Text((_userProvider.
                              documentSnapshot?.data()as dynamic)['address']),
                              trailing: OutlinedButton(
                                style: ButtonStyle(
                                  side: MaterialStateProperty.all
                                    (BorderSide(color: Colors.redAccent)),

                                ),
                                onPressed: () {
                                  EasyLoading.show(status: 'Locating Please wait');
                                  locationData.getCurrentPosition().then((value){
                                    if(locationData.permission==true){
                                      EasyLoading.dismiss();
                                      pushNewScreenWithRouteSettings(
                                        context,
                                        settings: const RouteSettings(name: MapScreen.id),
                                        screen: const MapScreen(),
                                        withNavBar: false,
                                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                      );
                                    }else{
                                      print("Permission not allowed");
                                    }
                                  });

                              },
                              child:  Text(Languages.of(context)!.change,style:
                              TextStyle(color: Colors.redAccent,

                              ),),),
                            ),

                          ),

                        ],
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.black)
                        ),
                        onPressed: (){
                          pushNewScreenWithRouteSettings(
                            context,
                            settings: const RouteSettings(name: UpdateProfileScreen.id),
                            screen: const UpdateProfileScreen(),
                            withNavBar: false,
                            pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                          );
                        },
                        child:Text(Languages.of(context)!.change,
                          style: TextStyle(color: Colors.white,
                              fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                              'Cairo' : 'Nunito'
                          ),)
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                     ListTile(
                       onTap: (){
                         pushNewScreenWithRouteSettings(
                           context,
                           settings:  const RouteSettings(name: MyOrderScreen.id),
                           screen: const MyOrderScreen(),
                           withNavBar: true,
                           pageTransitionAnimation: PageTransitionAnimation.cupertino,
                         );
                       },
                      horizontalTitleGap: 4.0,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(CupertinoIcons.bag),
                      title: Text(Languages.of(context)!.myOrders),
                    ),

                    SizedBox(height: 40,),
                    ListTile(
                      onTap: (){
                        FirebaseAuth.instance.signOut();
                        pushNewScreenWithRouteSettings(
                          context,
                          settings: const RouteSettings(name: WelcomeScreen.id),
                          screen: const WelcomeScreen(),
                          withNavBar: false,
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                        );
                      },
                      horizontalTitleGap: 4.0,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(CupertinoIcons.power),
                      title: Text('Log-Out'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
