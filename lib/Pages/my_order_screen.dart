

import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_app/localization/language/languages.dart';
import 'package:desktop_app/provider/auth_provider.dart';
import 'package:desktop_app/provider/order_provider.dart';
import 'package:desktop_app/services/order_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class MyOrderScreen extends StatefulWidget {
   const MyOrderScreen({Key? key}) : super(key: key);
static const String id = 'oreder-screen';
  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  final OrderServices _order = OrderServices();

  int tag = 0;
  List<String> options = [
    'ordered',
    'Accepted',
    'Rejected',
    'Delivered',
  ];

  @override
  Widget build(BuildContext context) {
    var _userProvider = Provider.of<AuthProvider>(context);
    var _orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title:  Text(Languages.of(context)!.myOrders,
          style: TextStyle(
              fontFamily: Localizations.localeOf(context).languageCode == 'ar'?
              'Cairo' : 'Nunito'
          ),),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(CupertinoIcons.search))
        ],
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: _order.orders.where('userID',isEqualTo: _userProvider.uuser!.uid).
          where('orderStatus', isEqualTo: _orderProvider.status).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if(!snapshot.hasData){
              return Center(child:Center(child: CircularProgressIndicator(), ));
            }

            return Column(
              children: [
                Container(
                  height: 56,
                  width: MediaQuery.of(context).size.width,
                  child: ChipsChoice<int>.single(
                    value: tag,
                    onChanged: (val) => setState((){

                      _orderProvider.filterOrder(options[val]);
                      tag=val;
                    }),
                    choiceItems: C2Choice.listFrom<int, String>(
                      source: options,
                      value: (i, v) => i,
                      label: (i, v) => v,
                    ),
                  )
                ),
                Expanded(

                  child: ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                      return Container(
                        color: Colors.white,
                        child: Column(
                          children:  [
                            ListTile(
                              horizontalTitleGap: 0,
                              leading: const CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 40,
                                child: Icon(CupertinoIcons.square_list),
                              ),
                              title: Text((document.data() as dynamic)['orderStatus'],
                                style: (document.data() as dynamic)['orderStatus']=='Rejected'?
                                TextStyle(color: Colors.red) :(document.data() as dynamic)['orderStatus']=='Accepted'?
                                TextStyle(color: Colors.green)
                                    :TextStyle(color: Colors.orangeAccent),),
                              subtitle: Text("on ${DateFormat.yMMMd().format
                                (DateTime.parse((document.data() as dynamic)['TimeStamp']))}"),
                              trailing: Text("Amount : "
                                  "${((document.data() as dynamic)['total'].toString())} R.O"),
                            ),
                             ExpansionTile(title: const Text("OrderDetails",style: TextStyle(fontSize: 12),),
                              subtitle: const Text("view Order details",style:
                              TextStyle(fontSize: 12,color: Colors.grey),),
                              children: [
                                ListView.builder(
                                itemCount:(document.data() as dynamic)['employers'].length,
                                    shrinkWrap: true,

                                    itemBuilder: (BuildContext context,int index){
                                      return  ListTile(
                                        title: Text(data['employers'][index]['productname']),
                                         leading: CircleAvatar(
                                           backgroundColor: Colors.white,
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.circular(20),
                                              child: Image.network(data['employers'][index]['productUrl']))
                                         ),
                                        subtitle: Row(
                                          children: [
                                            Text(data['employers']
                                            [index]['total'].toString() + " R.O"),
                                            SizedBox(width: 20,),
                                            Text("Desktop : "),
                                            Text(data['employers'][index]['shopname']),
                                          ],
                                        ),
                                      );

                                    } ),
                              ],
                            ),
                           Divider(height: 3,color: Colors.grey,)

                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 56,)
              ],
            );
          },
        ),
      ),
    );
  }
}
