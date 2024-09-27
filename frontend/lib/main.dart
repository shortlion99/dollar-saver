import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'components/budget_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => BudgetProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget App',
      theme: ThemeData(
        primaryColor: Color(0xFF4CD964),
        scaffoldBackgroundColor: Color(0xFF4CD964),
        fontFamily: 'Roboto',
      ),
      home: HomeScreen(),
    );
  }
}