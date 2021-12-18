

import 'package:flutter/cupertino.dart';

class OrderProvider with ChangeNotifier{

  String ?status;

  filterOrder(statuss){
    status = statuss;
    notifyListeners();
  }
}