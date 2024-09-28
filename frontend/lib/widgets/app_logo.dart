import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size; // You can pass a size parameter for the logo

  const AppLogo({Key? key, this.size = 50.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      '/Users/leandreadeconceicao/Desktop/AI-expense-tracker/frontend/lib/assets/images/dollarsaver_logo.png', // Update with your logo path
      height: size,
      width: size,
      fit: BoxFit.contain,
    );
  }
}
