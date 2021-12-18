



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_app/Pages/home_screen.dart';
import 'package:desktop_app/Pages/landing_page.dart';
import 'package:desktop_app/Pages/main_screen.dart';
import 'package:desktop_app/Pages/map_screen.dart';
import 'package:desktop_app/localization/language/languages.dart';
import 'package:desktop_app/provider/location_provider.dart';
import 'package:desktop_app/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthProvider with ChangeNotifier{
  User? uuser =FirebaseAuth.instance.currentUser;
  late String selectedStore;
  late String selectedStoreId;
  late DocumentSnapshot storeDetails;
  late String selectedproductCategory ;
   String ?selectedSubCategory;
    DocumentSnapshot ?documentSnapshot;

  getSelectedStore(storeInformation){
    storeDetails = storeInformation;
    notifyListeners();


  }
  SelectedCategory(categorychoice){
    selectedproductCategory = categorychoice;
    notifyListeners();
  }

  selectedSubCategoryEmployer(subCategorychoice){
    selectedSubCategory = subCategorychoice;
    notifyListeners();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String smsOtp ;
  late String verificationId;
  final UserServices _userServices = UserServices();
  bool loading=false;
  LocationProvider locationdata = LocationProvider();
  late String screen;
  double ?latitude;
  double ?longitude;
  String? address;
  String? location;

  set error(String error) {}


  Future<void>verifyPhone({required BuildContext context,required String number,}) async{
    this.loading = true;
    notifyListeners();
   final PhoneCodeSent smsOtpSend = (String verId, int? resendToken) async {

     this.verificationId = verId;

     smsOtpDialog(context,number);
   };
    try{
      _auth.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: (PhoneAuthCredential credential) async {
            this.loading=false;
            notifyListeners();
            await _auth.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            this.loading =false;
            notifyListeners();
            if (e.code == 'invalid-phone-number') {
              print('The provided phone number is not valid.');
            }// Handle other errors
          },
          codeSent: smsOtpSend,
          codeAutoRetrievalTimeout: (String verId){
            this.verificationId = verId;
          });

  }catch(e){
      this.loading=false;
      print(e);
    }
    }

 Future<dynamic>smsOtpDialog(BuildContext context, String number){
    return showCupertinoDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Column(
              children:  [
                Text(Languages.of(context)!.verificationCode,
                  style: TextStyle(fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                  'Cairo' : 'Nunito'),),
                SizedBox(height: 6,),
                Text(Languages.of(context)!.enterDigits,style: TextStyle(fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                'Cairo' : 'Nunito'),),
              ],
            ),
            content: Container(
              height: 85,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (value){
                  this.smsOtp=value;
                },
              ),
            ),
            actions: [
              FlatButton(onPressed: () async {
                try {
                  PhoneAuthCredential credential = PhoneAuthProvider.
                  credential(verificationId: verificationId, smsCode: smsOtp);

                  final User? user = (await _auth.signInWithCredential(
                      credential)).user;
                  if (user != null) {
                    uuser=user;
                    notifyListeners();
                    loading =false;
                    notifyListeners();
                    _userServices.getUserById(user.uid).then((snapshot) {
                      if (snapshot.exists) {
                    if(this.screen=='loggin'){

                      Navigator.pushReplacementNamed(context, LandingScreen.id);}
                    else{
                      updateUser(id: user.uid,number: user.phoneNumber);
                     Navigator.pushReplacementNamed(context,MainScreen.id);}
                    }else{
                        _creatUser(id: user.uid,number: user.phoneNumber);
                        Navigator.pushReplacementNamed(context, MainScreen.id);

                    }
                    });

                  }
                }
                  catch(e){
                  error='invalid OTP';
                  notifyListeners();
                Navigator.of(context).pop();
                }
                },
                  color: Colors.green,
                  child: Text(Languages.of(context)!.login,style: TextStyle(fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
          'Cairo' : 'Nunito'),),),
            ],
          );
    }).whenComplete((){
      this.loading=false;
      notifyListeners();
    });
 }
 void _creatUser({ String ?id , String? number
     }){
    _userServices.creatUserData({
      'id':id,
      'number':number,
      'laltitude':this.latitude,
      'longitude':this.longitude,
      'address':this.address,
      'location':location,

    });
loading=false;
notifyListeners();
}
  void updateUser  ( {String ?id ,String ?number,}){

    try{
      _userServices.updateUserData({
        'id':id,
        'number':number,
        'laltitude':this.latitude,
        'longitude':this.longitude,
        'address' :this.address,
        'location': location,
      });
      this.loading=false;
      notifyListeners();
    }catch(e){
      print(e.toString());

    }

  }
  Future<DocumentSnapshot> getUserDetails() async{
    DocumentSnapshot result = await FirebaseFirestore.instance.collection('users').
    doc(_auth.currentUser!.uid).get();
    if(result.exists){
      documentSnapshot = result;
      notifyListeners();
    }else{
      documentSnapshot=null;
    }

    return result;
  }
}