import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../models/trend_point.dart';

class TrendChart extends StatelessWidget {
  const TrendChart({super.key, required this.points});

  final List<TrendPoint> points;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const _EmptyChart();
    }

    final maxY = points
        .map((point) => point.count)
        .reduce((left, right) => left > right ? left : right)
        .toDouble();
    final yInterval = maxY <= 10 ? 1.0 : (maxY / 5).ceilToDouble();
    final maxLabels = 7;
    final labelStep = points.length <= maxLabels
        ? 1
        : ((points.length - 1) / (maxLabels - 1)).ceil();

    return SizedBox(
      height: 280,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: points.isEmpty ? 0 : (points.length - 1).toDouble(),
          minY: 0,
          maxY: maxY + 1,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: yInterval,
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
              left: BorderSide(color: Color(0xFFE2E8F0), width: 1),
              right: BorderSide(color: Colors.transparent, width: 0),
              top: BorderSide(color: Colors.transparent, width: 0),
            ),
          ),
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchSpotThreshold: 20,
            getTouchedSpotIndicator: (barData, spotIndexes) {
              return spotIndexes.map((index) {
                return TouchedSpotIndicatorData(
                  FlLine(color: const Color(0xFF0F766E), strokeWidth: 1.5),
                  FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 6,
                        color: const Color(0xFF0F766E),
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                );
              }).toList();
            },
            touchTooltipData: LineTouchTooltipData(
              tooltipBorderRadius: BorderRadius.circular(8),
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              getTooltipColor: (_) => const Color(0xFF0F766E),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final index = spot.x.toInt();
                  if (index < 0 || index >= points.length) {
                    return null;
                  }
                  final point = points[index];
                  return LineTooltipItem(
                    '${point.year}: ${point.count} publications',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: yInterval,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF334155),
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 56,
                interval: labelStep.toDouble(),
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= points.length) {
                    return const SizedBox.shrink();
                  }
                  if (index % labelStep != 0 && index != points.length - 1) {
                    return const SizedBox.shrink();
                  }
                  // Rotate labels slightly to avoid overlap (e.g., 2017 vs 2019)
                  return Transform.rotate(
                    angle: -math.pi / 10, // about -18 degrees
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '${points[index].year}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF334155),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: points
                  .asMap()
                  .entries
                  .map(
                    (entry) => FlSpot(
                      entry.key.toDouble(),
                      entry.value.count.toDouble(),
                    ),
                  )
                  .toList(growable: false),
              isCurved: true,
              barWidth: 3,
              color: const Color(0xFF0F766E),
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: const Color.fromRGBO(15, 118, 110, 0.15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyChart extends StatelessWidget {
  const _EmptyChart();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        'Not enough publication year data to draw a trend chart.',
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF64748B)),
      ),
    );
  }
}
