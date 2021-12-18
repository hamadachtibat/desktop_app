


import 'package:desktop_app/Pages/home_screen.dart';
import 'package:desktop_app/localization/language/languages.dart';
import 'package:desktop_app/provider/auth_provider.dart';
import 'package:desktop_app/provider/location_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';


class LoggingScreen extends StatefulWidget {
  const LoggingScreen({Key? key}) : super(key: key);
 static const String id ='logging-screen';
  @override
  _LoggingScreenState createState() => _LoggingScreenState();
}

class _LoggingScreenState extends State<LoggingScreen> {
  final TextEditingController  _phoneNumberController =TextEditingController();
  bool _validPhoneNumber = false;
  @override
  Widget build(BuildContext context) {
    final auth =Provider.of<AuthProvider>(context);
    final locationData =Provider.of<LocationProvider>(context);
    return Scaffold(
      body:
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              const SizedBox(height: 200,),
              Text(Languages.of(context)!.login,style:
              TextStyle(fontSize: 20,fontWeight: FontWeight.bold,
                  fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                  'Cairo' : 'Nunito'
              ),),
               Text(Languages.of(context)!.addyourPhoneNumber,style:
              TextStyle(fontSize: 13,fontWeight: FontWeight.w700,
                  color:Colors.grey,
                  fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                  'Cairo' : 'Nunito'
              ),
              ),
              TextField(
                controller: _phoneNumberController,
                cursorColor: Colors.green,
                decoration:  InputDecoration(

                  labelText: Languages.of(context)!.addyourPhoneNumber,
                  labelStyle: TextStyle(color: Colors.green),
                ),
                autofocus: true,
                maxLength: 8,
                keyboardType: TextInputType.phone,
                onChanged: (value){
                  if(value.length==8){
                    setState((){
                      _validPhoneNumber = true;
                    });
                  }else{
                    setState((){
                      _validPhoneNumber = false;
                    });
                  }
                },
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    child: AbsorbPointer(
                      absorbing: _validPhoneNumber?false:true,
                      child: TextButton(onPressed:(){
                        EasyLoading.show(status: 'Logging...');
                        setState((){
                          auth.screen = 'map-screen';
                          auth.loading=true;
                          auth.latitude=locationData.latitude;
                          auth.longitude=locationData.longitude;
                          auth.address=locationData.addressLine;
                        });

                        String number='+968${_phoneNumberController.text}';
                        auth.verifyPhone(context:context, number:number,
                        ).
                        then((value){
                          EasyLoading.dismiss();
                          _phoneNumberController.clear();
                          setState(() {
                            auth.loading=false;
                          });
                        });

                      },
                        child: auth.loading? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ):Text( Languages.of(context)!.coontinue,
                          style:  TextStyle(fontSize: 15,color: Colors.white,
                            fontWeight: FontWeight.bold,
                          fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                          'Cairo' : 'Nunito' ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: _validPhoneNumber?
                          MaterialStateProperty.all(Colors.green):MaterialStateProperty.all(Colors.grey)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],

          ),
        ),
      ),
    );

  }
}

