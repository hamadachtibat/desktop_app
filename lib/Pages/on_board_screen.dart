import 'package:desktop_app/localization/language/languages.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import '../constants.dart';


class onBaordScreen extends StatefulWidget {
  const onBaordScreen({Key? key}) : super(key: key);

  @override
  _onBaordScreenState createState() => _onBaordScreenState();
}
final _controller = PageController(
   initialPage :0,
);
int _currentPage=0;


List<Widget> _pages=[
  Column(
    children: [
      Expanded(child: Image.asset("images/enteraddress.png")),
       Text("set your Location",style: kpageTextStyle,),
    ],
  ),
  Column(
    children: [

      Expanded(child: Image.asset("images/cleaners.jpeg")),
      const Text("Employer in All Categories",style: kpageTextStyle,),
    ],
  ),
  Column(
    children: [

      Expanded(child: Image.asset("images/deliverfood.png")),
      const Text("Set Your Delivery Address",style:kpageTextStyle,),
    ],
  ),
];

class _onBaordScreenState extends State<onBaordScreen> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              children: [
                Column(
                  children: [
                    Expanded(child: Image.asset("images/enteraddress.png")),
                    Text(Languages.of(context)!.yourLocation,
                      style:TextStyle(
                        fontSize: 20,fontWeight: FontWeight.w700,
                      fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                      'Cairo' : 'Nunito'),),
                  ],
                ),
                Column(
                  children: [

                    Expanded(child: Image.asset("images/cleaners.jpeg")),
                     Text(Languages.of(context)!.employerinallcategories
                       ,style: TextStyle(
                             fontSize: 20,fontWeight: FontWeight.w700,
                             fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                             'Cairo' : 'Nunito'),),
                  ],
                ),
                Column(
                  children: [

                    Expanded(child: Image.asset("images/deliverfood.png")),
                     Text(Languages.of(context)!.adressdelivery,
                       style:TextStyle(
                           fontSize: 20,fontWeight: FontWeight.w700,
                           fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
                           'Cairo' : 'Nunito'),),
                  ],
                ),
              ],
              onPageChanged: (index){
                setState(() {
                  _currentPage = index;
                });

              },
              ),
            ),
          const SizedBox(height: 20,),
          DotsIndicator(
            dotsCount: _pages.length,
            position: _currentPage.toDouble(),
            decorator: DotsDecorator(
            size: const Size.square(9.0),
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            activeColor: Colors.green,
    ),
          ),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }
}
