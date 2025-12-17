import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/design_system.dart';

/// Progress Chart Widget
/// Zeigt Fortschritt in einfachen, kindgerechten Charts
class ProgressChartWidget extends StatelessWidget {
  const ProgressChartWidget({
    super.key,
    required this.data,
    this.title,
    this.showLegend = true,
  });

  final Map<String, double> data; // Label -> Value (0-100)
  final String? title;
  final bool showLegend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TherapyDesignSystem.spacingLG),
      decoration: BoxDecoration(
        color: TherapyDesignSystem.surfaceWhite,
        borderRadius: BorderRadius.circular(TherapyDesignSystem.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: TherapyDesignSystem.headingSmall,
            ),
            const SizedBox(height: TherapyDesignSystem.spacingLG),
          ],
          // Einfacher Balkendiagramm
          SizedBox(
            height: 200,
            child: BarChart(
              _buildBarChartData(),
            ),
          ),
          if (showLegend) ...[
            const SizedBox(height: TherapyDesignSystem.spacingLG),
            _buildLegend(),
          ],
        ],
      ),
    );
  }

  BarChartData _buildBarChartData() {
    final entries = data.entries.toList();
    final colors = [
      TherapyDesignSystem.primaryBlue,
      TherapyDesignSystem.secondaryOrange,
      TherapyDesignSystem.successGreen,
      TherapyDesignSystem.warningYellow,
    ];

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: 100,
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              if (value.toInt() < entries.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    entries[value.toInt()].key,
                    style: TherapyDesignSystem.bodyMedium.copyWith(
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }
              return const Text('');
            },
            reservedSize: 60,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                '${value.toInt()}%',
                style: TherapyDesignSystem.bodyMedium.copyWith(
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 25,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: TherapyDesignSystem.surfaceGray,
            strokeWidth: 1,
          );
        },
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: TherapyDesignSystem.surfaceGray,
          width: 1,
        ),
      ),
      barGroups: entries.asMap().entries.map((entry) {
        final index = entry.key;
        final dataEntry = entry.value;
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: dataEntry.value,
              color: colors[index % colors.length],
              width: 40,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildLegend() {
    final entries = data.entries.toList();
    final colors = [
      TherapyDesignSystem.primaryBlue,
      TherapyDesignSystem.secondaryOrange,
      TherapyDesignSystem.successGreen,
      TherapyDesignSystem.warningYellow,
    ];

    return Wrap(
      spacing: TherapyDesignSystem.spacingLG,
      runSpacing: TherapyDesignSystem.spacingMD,
      children: entries.asMap().entries.map((entry) {
        final index = entry.key;
        final dataEntry = entry.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: colors[index % colors.length],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: TherapyDesignSystem.spacingSM),
            Text(
              '${dataEntry.key}: ${dataEntry.value.toInt()}%',
              style: TherapyDesignSystem.bodyMedium,
            ),
          ],
        );
      }).toList(),
    );
  }
}

/// Einfacher Progress Ring für schnelle Übersicht
class ProgressRingWidget extends StatelessWidget {
  const ProgressRingWidget({
    super.key,
    required this.value, // 0.0 - 1.0
    required this.label,
    this.size = 120,
    this.color,
  });

  final double value;
  final String label;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final progressColor = color ?? TherapyDesignSystem.primaryBlue;

    return Column(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Hintergrund-Ring
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 12,
                  backgroundColor: TherapyDesignSystem.surfaceGray,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    TherapyDesignSystem.surfaceGray,
                  ),
                ),
              ),
              // Progress-Ring
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: 12,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                ),
              ),
              // Prozent-Anzeige
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(value * 100).toInt()}%',
                    style: TherapyDesignSystem.headingMedium.copyWith(
                      color: progressColor,
                    ),
                  ),
                  Text(
                    label,
                    style: TherapyDesignSystem.bodyMedium.copyWith(
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

