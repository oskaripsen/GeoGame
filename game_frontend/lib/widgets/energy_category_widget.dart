import 'package:flutter/material.dart';
import '../widgets/energy_data_widget.dart';

class EnergyCategoryWidget extends StatelessWidget {
  final Map<String, dynamic> energyData;

  const EnergyCategoryWidget({Key? key, required this.energyData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Make sure the energyData contains the expected keys
    if (!energyData.containsKey('electricity_shares') || 
        !energyData.containsKey('electricity_generation')) {
      return const Center(
        child: Text(
          'Energy data is not in the expected format',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    try {
      // Convert the dynamic map to a Map<String, double>
      final Map<String, double> shares = {};
      
      // Handle the conversion explicitly
      final sharesData = energyData['electricity_shares'];
      if (sharesData is Map) {
        sharesData.forEach((key, value) {
          if (value is num) {
            shares[key.toString()] = value.toDouble();
          } else if (value is String) {
            try {
              shares[key.toString()] = double.parse(value);
            } catch (e) {
              print('Could not parse $value to double');
              shares[key.toString()] = 0.0;
            }
          } else {
            shares[key.toString()] = 0.0;
          }
        });
      }

      // Convert electricity generation to double
      double totalEnergy = 0.0;
      if (energyData['electricity_generation'] is num) {
        totalEnergy = (energyData['electricity_generation'] as num).toDouble();
      } else if (energyData['electricity_generation'] is String) {
        try {
          totalEnergy = double.parse(energyData['electricity_generation']);
        } catch (e) {
          print('Could not parse electricity_generation to double');
        }
      }

      // Return the widget with fixed height to prevent overflow
      return SizedBox(
        height: 230, // Reduced height to prevent overflow
        child: EnergyPieChart(
          shares: shares,
          totalEnergy: totalEnergy,
        ),
      );
    } catch (e) {
      print("Error rendering energy data: $e");
      return Center(
        child: Text(
          'Error displaying energy data: $e',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
  }
}
