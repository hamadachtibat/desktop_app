import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_app/Pages/cart_screen.dart';
import 'package:desktop_app/localization/language/languages.dart';
import 'package:desktop_app/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';


class UpdateProfileScreen extends StatefulWidget {

  const UpdateProfileScreen({Key? key}) : super(key: key);
 static const String id = 'update-profile-screen';
  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {

  final _formKey = GlobalKey<FormState>();
  final _fistnameCon=TextEditingController();
  final _lastnameCon=TextEditingController();
  final _mobileCon=TextEditingController();
  final _emailCon = TextEditingController();


  User? user = FirebaseAuth.instance.currentUser;
  final UserServices _userServices = UserServices();

  @override
  void initState() {
    _userServices.getUserById(user!.uid).then((value){
     if(mounted){
       setState(() {
       _fistnameCon.text = (value.data()as dynamic)['firstName'];
       _lastnameCon.text = (value.data()as dynamic)['lastName'];
       _emailCon.text = (value.data()as dynamic)['email'];
       _mobileCon.text = (value.data()as dynamic)['number'];


       });
     }
    });
    super.initState();
  }

  updateProfile(){
    if(_formKey.currentState!.validate()){
      return FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
        'firstName':_fistnameCon.text,
        'lastName': _lastnameCon.text,
        'email': _emailCon.text,
        'number':_mobileCon.text,
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  Text(Languages.of(context)!.updateProfile,
          style: TextStyle(
              fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
              'Cairo' : 'Nunito'
          ),
          ),
      ),
      bottomSheet: InkWell(
        onTap: (){
          if(_formKey.currentState!.validate()){
            EasyLoading.show(status:'Updating Profile..' );
            updateProfile().then((value){
              EasyLoading.showSuccess(Languages.of(context)!.updateProfile);
              Navigator.pop(context);
            });
          }
        },
        child: Container(
          color: Colors.blueGrey[800],
          height: 56,
          width: double.infinity,
          child:  Center(child: Text(Languages.of(context)!.updateProfile,

          style: TextStyle(color: Colors.green,fontSize: 18,fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
          'Cairo' : 'Nunito'
          ),),
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 100,),
              Row(
                children: [
                  Expanded(child: TextFormField(
                    controller: _fistnameCon,
                    decoration: InputDecoration(
                      labelText: Languages.of(context)!.firstName,
                      labelStyle: TextStyle(color: Colors.grey,
                          fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                          'Cairo' : 'Nunito'),
                      contentPadding: EdgeInsets.zero,

                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  )),
                  const SizedBox(width: 20,),
                  Expanded(child:TextFormField(
                    controller: _lastnameCon,
                    decoration: InputDecoration(
                      labelText: Languages.of(context)!.lastName,
                      labelStyle: TextStyle(color: Colors.grey,
                          fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                          'Cairo' : 'Nunito'),
                      contentPadding: EdgeInsets.zero,

                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Please enter your Last Name';
                      }
                      return null;
                    },
                  ), ),
                ],
              ),
              const SizedBox(height: 20,),
              TextFormField(
                enabled: false,
                controller: _mobileCon,
                decoration: InputDecoration(
                  labelText: Languages.of(context)!.addyourPhoneNumber,
                  labelStyle: TextStyle(color: Colors.grey,
                      fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                      'Cairo' : 'Nunito'),
                  contentPadding: EdgeInsets.zero,

                ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'Please enter your Last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              TextFormField(
                controller: _emailCon,
                decoration: InputDecoration(
                  labelText: Languages.of(context)!.email,
                  labelStyle: TextStyle(color: Colors.grey,fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                  'Cairo' : 'Nunito'),
                  contentPadding: EdgeInsets.zero,

                ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'Please enter your Email';
                  }
                  return null;
                },
              ),

            ],
          ),

        ),
      )
    );
  }
}
