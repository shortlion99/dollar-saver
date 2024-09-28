import 'package:ai_expense_app/screens/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_expense_app/components/budget_provider.dart'; // Ensure this path is correct

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
        
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
       
      ),
      home: MainScaffold(), // Use MainScaffold
    );
  }
}
