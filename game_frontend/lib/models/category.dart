import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;
  final String description;
  final String importanceTitle;
  final String importanceDescription;

  Category({
    required this.name, 
    required this.icon, 
    required this.description,
    this.importanceTitle = 'Why This Matters',
    required this.importanceDescription,
  });
}
