
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ImagSlider extends StatefulWidget {
  const ImagSlider({Key? key}) : super(key: key);

  @override
  _ImagSliderState createState() => _ImagSliderState();
}

class _ImagSliderState extends State<ImagSlider> {


  Future getImgSliderDb() async{
    var _firestore= FirebaseFirestore.instance;
    QuerySnapshot  snapshot =await _firestore.collection('sliders').get()  ;
    return snapshot.docs;
  }
  @override
  void initState() {
    getImgSliderDb();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       FutureBuilder(
           future: getImgSliderDb(),

           builder: (_,AsyncSnapshot snapshot){
             if(snapshot.data!=null){
               return CarouselSlider.builder(itemCount: snapshot.data!.length,
                   itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex){
                     DocumentSnapshot imagSlider=snapshot.data[itemIndex];
                     Object? getImag= imagSlider.data();
                     return SizedBox(
                       width: MediaQuery.of(context).size.width,
                       child: Image.network((getImag as dynamic)['imag'],
                         fit: BoxFit.fill,),
                     );

               }, options: CarouselOptions(
                   height: 150,

                   viewportFraction: 1,
                   initialPage: 0,
                   autoPlay: true,
                   autoPlayCurve: Curves.fastOutSlowIn,
                 ),);
             }else{ return Container(
               color: Colors.orange,
             );}
           })

      ],
    );
  }
}
