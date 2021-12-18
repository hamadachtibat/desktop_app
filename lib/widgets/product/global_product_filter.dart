import 'package:desktop_app/provider/auth_provider.dart';
import 'package:desktop_app/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:provider/provider.dart';



class ProductGlobalFilter extends StatefulWidget {
  const ProductGlobalFilter({Key? key}) : super(key: key);

  @override
  _ProductGlobalFilterState createState() => _ProductGlobalFilterState();
}

class _ProductGlobalFilterState extends State<ProductGlobalFilter> {

  final ProductServices _services =ProductServices();
  int tag = 0;
  List<String> options = [
    'All the vendors', //0
    'Salary', //1
    'inactive vendors',//2
    'top Piked',//3
    'top rated',//4
  ];
  bool ?topPiked;
  bool ?active ;
  filter(val){
    if(val==1) {
      setState(() {
        active = true;
      });
    }
    if(val==2) {
      setState(() {
        active = false;
      });
    }
    if(val==3){
      setState(() {
        topPiked=true;
      });
      if(val==0){
        setState(() {
          topPiked=null;
          active = null;
        });
      }
    }


  }
  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<AuthProvider>(context);

    return Column(
      children: [
        ChipsChoice<int>.single(
          value: tag,
          onChanged: (val) {
            setState(() {
              tag = val;
            });
            filter(val);

          } ,
          choiceItems: C2Choice.listFrom<int, String>(
            activeStyle:(i,v){
              return C2ChoiceStyle(
                brightness: Brightness.dark,
                color: Colors.black54,
              );
            } ,
            source: options,
            value: (i, v) => i,
            label: (i, v) => v,
          ),
        ),
        StreamBuilder(
            stream: _services.products.doc(_provider.storeDetails['uid']).collection('products').
    orderBy("salary",descending: true).
            where('isavailbale',isEqualTo: true).where('published',isEqualTo: true).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.hasError){
                return Text(" no vendors to show");
              }
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator(),);

              }
              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
              return Container(

              );
            })
      ],
    );
  }
}
