import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Progress Chart Widget
class ProgressChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const ProgressChartWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text('Keine Daten verfügbar'),
      );
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}%',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < data.length) {
                  final date = data[value.toInt()]['date'] as String? ?? '';
                  return Text(
                    date.split('-').last,
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((entry) {
              final index = entry.key;
              final score = entry.value['score'] as double? ?? 0.0;
              return FlSpot(index.toDouble(), score);
            }).toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        minY: 0,
        maxY: 100,
      ),
    );
  }
}

