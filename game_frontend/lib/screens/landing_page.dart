import 'package:flutter/material.dart';
import '../models/category.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Category> categories = [
      Category(
        name: 'Security & Governance',
        icon: Icons.security,
        description: 'Ensures national stability, citizen safety, and the rule of law through effective institutions and protection systems.',
      ),
      Category(
        name: 'Economy & Finance',
        icon: Icons.attach_money,
        description: 'Drives prosperity and resilience by managing markets, jobs, trade, and public finances.',
      ),
      Category(
        name: 'Infrastructure & Transport',
        icon: Icons.commute,
        description: 'Supports daily life and economic activity through connected, reliable physical systems.',
      ),
      Category(
        name: 'Health',
        icon: Icons.local_hospital,
        description: 'Maintains a strong, productive population through accessible and high-quality care.',
      ),
      Category(
        name: 'Education',
        icon: Icons.school,
        description: 'Builds human capital and long-term competitiveness through knowledge and skills development.',
      ),
      Category(
        name: 'Environment & Energy',
        icon: Icons.eco,
        description: 'Safeguards the future by managing natural resources, energy systems, and climate impacts sustainably.',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a category and start getting to now know the world!'), 
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.0, // Changed to square for more description space
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return CategoryCard(category: categories[index]);
        },
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context, 
            '/intermediary',
            arguments: category,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                category.icon,
                size: 60.0,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 6.0),
              Text(
                category.name,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4.0),
              Text(
                _getShortDescription(category.name),
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _getShortDescription(String categoryName) {
    switch (categoryName) {
      case 'Security & Governance':
        return 'Ensures national stability, citizen safety, and the rule of law';
      case 'Economy & Finance':
        return 'Drives prosperity and resilience by managing markets and jobs';
      case 'Infrastructure & Transport':
        return 'Supports daily life through connected, reliable physical systems';
      case 'Health':
        return 'Maintains a strong population through quality care access';
      case 'Education':
        return 'Builds human capital through knowledge and skills development';
      case 'Environment & Energy':
        return 'Manages resources, energy systems, and climate impacts sustainably';
      default:
        return 'Learn more about this category';
    }
  }
}
