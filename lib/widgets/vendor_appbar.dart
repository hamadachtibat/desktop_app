import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_app/provider/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';



class VendorAppBar extends StatelessWidget {
  const VendorAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _authData = Provider.of<AuthProvider>(context);
    mapLauncher() async {
      GeoPoint location = _authData.storeDetails['location'];
      final availableMaps = await MapLauncher.installedMaps;
      print(availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

      await availableMaps.first.showMarker(
        coords: Coords(location.latitude, location.longitude),
        title: _authData.storeDetails['shopname'],
      );
    }

    return SliverAppBar(
      floating: true,
      snap: true,
      expandedHeight: 300,
      flexibleSpace: SizedBox(
        child: Padding(
          padding: const EdgeInsets.only(top: 90),
          child: Card(
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),

                image: DecorationImage(
                    image: NetworkImage(_authData.storeDetails['url']),
                  fit: BoxFit.fill,
                ),

              ),
              child: Container(
                color: Colors.grey.withOpacity(0.7),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const SizedBox(height: 20,),
                    Text(_authData.storeDetails['address'],style:
                    const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,

                    ),),
                    Text(_authData.storeDetails['email'],style:
                    const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,

                    ),
                    ),
                    SizedBox(height: 8,),
                    Row(children: const [
                      Icon(Icons.star,color: Colors.yellow,),
                      Icon(Icons.star,color: Colors.yellow),
                      Icon(Icons.star,color: Colors.yellow),
                      Icon(Icons.star,color: Colors.yellow),
                      Icon(Icons.star,),
                      SizedBox(width: 10,),
                      Text('(4.0)', style: TextStyle(fontWeight: FontWeight.bold),)

                      
                    ],
                    ),
                    Padding(
                      padding:  const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children:
                       [
                        CircleAvatar(backgroundColor: Colors.white,
                        child: IconButton(icon:Icon(Icons.phone),
                          onPressed: (){
                           launch('tel://${_authData.storeDetails['phonenumber']}');
                          },
                        ),
                        ),
                        SizedBox(width: 10,),
                        CircleAvatar(backgroundColor: Colors.white,
                        child: IconButton(icon:Icon(Icons.map),
                          onPressed: (){
                           mapLauncher();
                          },
                        ),),
                      ],),
                    )


                  ],
                ),

              ),
            ),
          ),
          ),
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,

      ),
      actions: [
        IconButton(onPressed: () {

        }, icon: const Icon(CupertinoIcons.search),),
      ],
      title: Text(_authData.storeDetails['shopname']),centerTitle: true,
    );
  }
}
