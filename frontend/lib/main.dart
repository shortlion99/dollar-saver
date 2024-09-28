import 'package:ai_expense_app/screens/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        primaryColor: Colors.deepPurple[800],
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.deepPurple[800],
        ),
      ),
      home: MainScaffold(), // Use MainScaffold
    );
  }
}
