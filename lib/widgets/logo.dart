import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double size;

  const Logo({this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logo.png',
      width: size,
      height: size,
    );
  }
}