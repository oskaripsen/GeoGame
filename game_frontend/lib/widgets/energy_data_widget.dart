import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

class EnergyPieChart extends StatelessWidget {
  final Map<String, double> shares;
  final double totalEnergy;

  const EnergyPieChart({
    Key? key,
    required this.shares,
    required this.totalEnergy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate colors for the pie chart sections
    List<Color> colors = shares.keys.map((source) {
      return Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    }).toList();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Energy Profile',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Total Electricity Generation: ${totalEnergy.toStringAsFixed(1)} TWh',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _createSections(colors),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _createLegendItems(colors),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _createSections(List<Color> colors) {
    List<PieChartSectionData> sections = [];
    int colorIndex = 0;
    
    shares.forEach((source, percentage) {
      sections.add(
        PieChartSectionData(
          color: colors[colorIndex],
          value: percentage,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 60,
          titleStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      colorIndex++;
    });
    
    return sections;
  }

  List<Widget> _createLegendItems(List<Color> colors) {
    List<Widget> items = [];
    int colorIndex = 0;
    
    shares.forEach((source, percentage) {
      items.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              color: colors[colorIndex],
            ),
            SizedBox(width: 4),
            Text(source),
          ],
        ),
      );
      colorIndex++;
    });
    
    return items;
  }
}
