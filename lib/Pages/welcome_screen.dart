import 'package:desktop_app/Pages/map_screen.dart';
import 'package:desktop_app/Pages/on_board_screen.dart';
import 'package:desktop_app/localization/language/languages.dart';
import 'package:desktop_app/localization/language_data.dart';
import 'package:desktop_app/localization/locale_constant.dart';
import 'package:desktop_app/provider/auth_provider.dart';
import 'package:desktop_app/provider/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  static const  String id = 'Welcome-screen';
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _validPhoneNumber = false;
  final _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context,listen: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(

          child: Stack(
            children: [



              Column(
                children:  [
                  _createLanguageDropDown(),
                  const Expanded(child: onBaordScreen()),
                   Text(Languages.of(context)!.pickemployer,style:
                   TextStyle(fontSize: 20,fontWeight: FontWeight.w700,
                       fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                       'Cairo' : 'Nunito'),
                      ),
                  const SizedBox(height: 20,),
                  FlatButton(onPressed: () async {
                    setState(() {
                      locationData.loading=true;



                    });

                    await locationData.getCurrentPosition();
                    if(locationData.permission) {
                      setState(() {
                        locationData.loading=false;
                      });
                      locationData.getCurrentPosition().then((value){
                        Navigator.pushReplacementNamed(context, MapScreen.id);
                      });
                    }
                  },
                      color: Colors.green,
                      child:locationData.loading ? CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ) :Text(Languages.of(context)!.yourLocation,style: TextStyle(
                        fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                        'Cairo' : 'Nunito'

                      ),)),
                  const SizedBox(height: 100,),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  _createLanguageDropDown() {
    return DropdownButton<LanguageData>(
      iconSize: 30,
      hint: Text(Languages
          .of(context)!
          .labelSelectLanguage,style: TextStyle(color: Colors.deepOrange,
          fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
          'Cairo' : 'Nunito'),),
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
