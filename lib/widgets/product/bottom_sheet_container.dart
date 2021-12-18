import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_app/widgets/product/save_for_later.dart';
import 'package:flutter/material.dart';

import 'add_tocart_widget.dart';


class BottomSheetContainer extends StatefulWidget {
  final DocumentSnapshot documents;
  const BottomSheetContainer({Key? key, required this.documents}) : super(key: key);

  @override
  _BottomSheetContainerState createState() => _BottomSheetContainerState();
}

class _BottomSheetContainerState extends State<BottomSheetContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Flexible( flex:1,child: SaveForLater(document: widget.documents,)),
          Flexible( flex:1,child: AddToCartWidget(document: widget.documents,)),

        ],
      ),
    );
  }

}
