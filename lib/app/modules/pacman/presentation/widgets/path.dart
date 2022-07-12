import 'package:flutter/material.dart';

class MyPath extends StatelessWidget {
  final Color? innercolor;
  final Widget? child;
  final Color? outerColor;
  const MyPath({Key? key, this.innercolor, this.child, this.outerColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.all(12),
          color: outerColor,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: innercolor,
              child: Center(
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
