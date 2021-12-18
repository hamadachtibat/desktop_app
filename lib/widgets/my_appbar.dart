


import 'package:desktop_app/Pages/map_screen.dart';
import 'package:desktop_app/Pages/welcome_screen.dart';
import 'package:desktop_app/localization/language/languages.dart';
import 'package:desktop_app/localization/language_data.dart';
import 'package:desktop_app/localization/locale_constant.dart';
import 'package:desktop_app/provider/location_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
 class MyAppbar extends StatefulWidget {

   const MyAppbar({Key? key}) : super(key: key);

  @override
  State<MyAppbar> createState() => _MyAppbarState();
}

class _MyAppbarState extends State<MyAppbar> {
  String _location='';
  String _address = '';
  @override
  void initState() {
    getPrefs();
    super.initState();
  }
  getPrefs()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? location = preferences.getString('location');
    String? address = preferences.getString('address');
    setState(() {
      _location = location!;
      _address = address!;
    });
  }
   @override
   Widget build(BuildContext context) {
     final locationData = Provider.of<LocationProvider>(context);
     return SliverAppBar(
       stretch: true,
       snap: true,
       floating: true,
       automaticallyImplyLeading: true,
       backgroundColor: Colors.green ,
       elevation: 0.0,
       leading: Container(

       ),
       centerTitle:true ,
       title: FlatButton(
         onPressed: (){
           locationData.getCurrentPosition().then((value){
             if(locationData.permission==true){
               pushNewScreenWithRouteSettings(
                 context,
                 settings: RouteSettings(name: MapScreen.id),
                 screen: MapScreen(),
                 withNavBar: false,
                 pageTransitionAnimation: PageTransitionAnimation.cupertino,
               );
             }else{
               print("Permission not allowed");
             }
           });

         },
         child: Column(
           mainAxisSize: MainAxisSize.min,
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
             Row(
               mainAxisSize: MainAxisSize.min,
               mainAxisAlignment: MainAxisAlignment.start,
               children:  [
                 const Icon(Icons.location_on,color: Colors.white,
                 ),
                 Flexible(
                   child: Text(_location==null ? "set Address":_location,style: const TextStyle(color: Colors.white),
                     overflow: TextOverflow.ellipsis,),
                 ),
                 const SizedBox(width: 40,),
                 const Icon(Icons.edit,color: Colors.white,
                 ),
               ],
             ),
             Flexible(child: Text(_address,overflow: TextOverflow.ellipsis,)),
           ],
         ),
       ),
       actions:  [
         _createLanguageDropDown(),
       ],
       bottom:  PreferredSize(
         preferredSize:const Size.fromHeight(60) ,
         child: Padding(
           padding: const EdgeInsets.all(10.0),
           child: TextField(
             decoration: InputDecoration(
               hintText: Languages.of(context)!.search,
               hintStyle: TextStyle(fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
               'Cairo' : 'Nunito'),
               prefixIcon: Icon(Icons.search,color: Colors.grey,),
               border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(50),
                 borderSide: BorderSide.none,

               ),
               contentPadding: EdgeInsets.zero,
               filled: true,
               fillColor: Colors.white,

             ),
           ),
         ),
       ),

     );
   }
  _createLanguageDropDown() {
    return DropdownButton<LanguageData>(
      iconSize: 30,
      hint: Icon(Icons.language),
      onChanged: (LanguageData ?language) {
        changeLanguage(context, language!.languageCode);
      },

      items: LanguageData.languageList()
          .map<DropdownMenuItem<LanguageData>>(
            (e) =>
            DropdownMenuItem<LanguageData>(
              value: e,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    e.flag,
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(e.name)
                ],
              ),
            ),
      )
          .toList(),
    );
  }
}
