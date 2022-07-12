import 'package:flutter/material.dart';

class Ghost extends StatelessWidget {
  const Ghost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Image.asset('assets/images/gost_alien.png'),
    );
  }
}