import 'package:flutter/material.dart';

class CategorizationSettingsScreen extends StatelessWidget {
  const CategorizationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
        backgroundColor: Color.fromARGB(255, 41, 14, 96) // Custom dark purple
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Manage your expense categories here.'),
            // Add widgets to create and manage categories
          ],
        ),
      ),
    );
  }
}
