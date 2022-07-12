import 'package:flutter/material.dart';

class Player extends StatelessWidget {
  const Player({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Image.asset('assets/images/Pacman.png'),
    );
  }
}
