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
        importanceDescription: 'Security and governance form the bedrock of a functioning society. Without them, chaos prevails and progress becomes impossible. Understanding these systems helps citizens participate more effectively in democracy, recognize threats to societal stability, and contribute to creating safer communities. Knowledge in this area empowers individuals to become informed voters and engaged community members.',
      ),
      Category(
        name: 'Economy & Finance',
        icon: Icons.attach_money,
        description: 'Drives prosperity and resilience by managing markets, jobs, trade, and public finances.',
        importanceDescription: 'Economic systems touch every aspect of daily life, from the availability of jobs to the cost of necessities. Financial literacy is crucial for individuals and communities to thrive. Learning about economics and finance helps people make informed decisions about their personal resources, understand global market forces, and recognize how policy decisions affect prosperity. This knowledge is essential for reducing inequality and building resilient communities.',
      ),
      Category(
        name: 'Infrastructure & Transport',
        icon: Icons.commute,
        description: 'Supports daily life and economic activity through connected, reliable physical systems.',
        importanceDescription: 'The systems that deliver water, electricity, and transportation form the invisible framework that makes modern life possible. When infrastructure works well, we barely notice it—but when it fails, society grinds to a halt. Understanding infrastructure systems helps citizens advocate for necessary investments, prepare for disruptions, and appreciate the complex networks that support our daily activities. This knowledge is increasingly vital as we face challenges from aging systems and climate change.',
      ),
      Category(
        name: 'Health',
        icon: Icons.local_hospital,
        description: 'Maintains a strong, productive population through accessible and high-quality care.',
        importanceDescription: "Health systems determine not just individual wellbeing but societal productivity and happiness. A population's health directly impacts economic output, social stability, and national resilience. Learning about health systems helps people navigate their own healthcare needs, understand public health measures, and recognize the importance of preventive care. As global health challenges become more complex, this knowledge becomes increasingly essential for everyone, not just medical professionals.",
      ),
      Category(
        name: 'Education',
        icon: Icons.school,
        description: 'Builds human capital and long-term competitiveness through knowledge and skills development.',
        importanceDescription: "Education is society's greatest equalizer and the engine of future innovation. It shapes not just what we know but how we think and solve problems. Understanding educational systems helps communities advocate for quality learning environments, recognize effective teaching approaches, and support lifelong learning opportunities. In our rapidly changing world, learning about education itself is crucial for adapting to new challenges and preparing future generations for success.",
      ),
      Category(
        name: 'Environment & Energy',
        icon: Icons.eco,
        description: 'Safeguards the future by managing natural resources, energy systems, and climate impacts sustainably.',
        importanceDescription: 'Environmental and energy systems underpin everything from food production to manufacturing. As climate change intensifies, understanding these systems becomes not just important but existential. Learning about environment and energy helps citizens make sustainable choices, understand policy debates, and participate in the transition to cleaner technologies. This knowledge is critical for ensuring that future generations inherit a livable planet with the resources they need to thrive.',
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
