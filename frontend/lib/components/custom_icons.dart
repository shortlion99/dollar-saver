import 'package:flutter/material.dart';

class CustomIcons {
  static IconData getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'electricity':
        return Icons.lightbulb_outline;
      case 'home':
        return Icons.home;
      case 'food & drink':
        return Icons.fastfood;
      case 'pet food':
        return Icons.pets;
      default:
        return Icons.category;
    }
  }
}