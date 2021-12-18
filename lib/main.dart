import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_app/Pages/home_screen.dart';
import 'package:desktop_app/Pages/landing_page.dart';
import 'package:desktop_app/Pages/logging_screen.dart';
import 'package:desktop_app/Pages/main_screen.dart';
import 'package:desktop_app/Pages/map_screen.dart';
import 'package:desktop_app/Pages/my_order_screen.dart';
import 'package:desktop_app/Pages/product_details_screen.dart';
import 'package:desktop_app/Pages/product_favourite_details.dart';
import 'package:desktop_app/Pages/profile_screen.dart';
import 'package:desktop_app/Pages/vendor_homescreen.dart';
import 'package:desktop_app/Pages/welcome_screen.dart';
import 'package:desktop_app/provider/auth_provider.dart';
import 'package:desktop_app/provider/cart_provider.dart';
import 'package:desktop_app/provider/location_provider.dart';
import 'package:desktop_app/provider/order_provider.dart';
import 'package:desktop_app/services/fcm_backround.dart';
import 'package:desktop_app/widgets/product/product_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'Pages/cart_screen.dart';
import 'Pages/on_board_screen.dart';
import 'Pages/profile_update_screen.dart';
import 'Pages/registre_page.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Pages/splash_screen.dart';
import 'localization/locale_constant.dart';
import 'localization/localizations_delegate.dart';

FlutterLocalNotificationsPlugin ?flutterLocalNotificationsPlugin;
AndroidNotificationChannel ?channel;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await  Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(fireBaseBackroudMsgHandler);
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  channel =  const AndroidNotificationChannel('ahmed','ahmed',
      importance: Importance.max);
  await flutterLocalNotificationsPlugin!.
  resolvePlatformSpecificImplementation
  <AndroidFlutterLocalNotificationsPlugin>()?.
  createNotificationChannel(channel!);
  await FirebaseMessaging.instance.
  setForegroundNotificationPresentationOptions(
    alert: true,
    badge:true,
    sound:true,
  );

  runApp(MultiProvider(providers: [

    ChangeNotifierProvider(
      create: (_)=> AuthProvider(),

    ),
    ChangeNotifierProvider(
      create: (_)=> CartProvider(),

    ),
    ChangeNotifierProvider(create: (_)=> LocationProvider()
    ),
    ChangeNotifierProvider(create: (_)=> OrderProvider()
    ),
],
    child: const MyApp(),
  )
  );
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(newLocale);
  }
  const MyApp({Key? key}) : super(key: key);


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale ?_locale;
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() async {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }


late DocumentSnapshot doc;
@override

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      locale: _locale,
      supportedLocales: [
        Locale('en', ''),
        Locale('ar', ''),
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      builder:EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        fontFamily:'Nunito',
        primarySwatch: Colors.green,
        primaryColor: Colors.green,
      ),
      initialRoute: SplashScreen.id,
      routes: {
        HomeScreen.id : (context)=> const HomeScreen(),
        WelcomeScreen.id:(context) => const WelcomeScreen(),
        SplashScreen.id :(context) =>  const SplashScreen(),
        MapScreen.id :(context)=> const MapScreen(),
        LoggingScreen.id:(context)=>const LoggingScreen(),
        LandingScreen.id:(context)=>const LandingScreen(),
        MainScreen.id:(context)=>const MainScreen(),
        VendorHomeScreen.id:(context)=>const VendorHomeScreen(),
        ProductScreen.id:(context) =>const ProductScreen(),
        ProductDetailsScreen.id:(context) =>   ProductDetailsScreen(document: doc,),
        ProductFavouriteDetailsScreen.id:(context) =>   ProductFavouriteDetailsScreen(document: doc,),
        CartScreen.id:(context) => CartScreen(document: doc,),
        ProfileScreen.id : (context)=> const ProfileScreen(),
        MyOrderScreen.id : (context)=> const MyOrderScreen(),
        UpdateProfileScreen.id : (context)=> const UpdateProfileScreen(),




      },
      home: const SplashScreen(),
    );
  }
}


