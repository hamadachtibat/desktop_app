
import 'package:flutter/material.dart';

class RegistrePage extends StatelessWidget {
  const RegistrePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Hero(
                  tag: 'Logo',
                  child: Image.asset("images/logo.png")),
              TextField(),
              TextField(),
              TextField(),
              TextField(),
            ],
          ),
        ),
      ),
    );
  }
}


