import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_app/widgets/product/save_for_later.dart';
import 'package:flutter/material.dart';

import '../add_tocart_widget.dart';
import 'add_to_car_favourite.dart';


class BottomFavouriteSheetContainer extends StatefulWidget {
  final DocumentSnapshot documents;
  const BottomFavouriteSheetContainer({Key? key, required this.documents}) : super(key: key);

  @override
  _BottomFavouriteSheetContainerState createState() => _BottomFavouriteSheetContainerState();
}

class _BottomFavouriteSheetContainerState extends State<BottomFavouriteSheetContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Flexible( flex:1,child: SaveForLater(document: widget.documents,)),
          Flexible( flex:1,child: AddToCartFavouriteWidget(document: widget.documents,)),

        ],
      ),
    );
  }

}