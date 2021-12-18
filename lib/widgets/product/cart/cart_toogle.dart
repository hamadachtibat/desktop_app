import 'package:desktop_app/provider/cart_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';


class CodToggleSwitch extends StatelessWidget {
  const CodToggleSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _cart = Provider.of<CartProvider>(context);
    return Container(
      child: ToggleSwitch(
        minWidth: MediaQuery.of(context).size.width,
        initialLabelIndex: 0,
        cornerRadius: 20.0,
        activeFgColor: Colors.white,
        inactiveBgColor: Colors.grey,
        inactiveFgColor: Colors.white,
        totalSwitches: 2,
        labels: const ['Cash On Delivery', 'Payment Online'],
        icons: const [CupertinoIcons.money_dollar, CupertinoIcons.cart],
        activeBgColors: [[Colors.green],[Colors.pink]],
        onToggle: (index) {
          print('switched to: $index');
          _cart.getPaymentMethode(index);
        },
      ),
    );
  }
}
