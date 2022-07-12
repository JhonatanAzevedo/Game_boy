import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: (() {
                Modular.to.pushNamed("/pacman");
              }),
              child: const Text('Pacman'),
            ),
            ElevatedButton(
              onPressed: (() {
                Modular.to.pushNamed("/snake");
              }),
              child: const Text('Snake'),
            ),
          ],
        ),
      ),
    );
  }
}
