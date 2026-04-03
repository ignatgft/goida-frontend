import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../core/theme/ios_theme.dart';

/// iOS-стиль график (как в Apple Finance/Stocks)
/// - Плавная линия (кривая)
/// - Градиентное заполнение
/// - Анимация при появлении
class IosLineChart extends StatelessWidget {
  final List<double> data;
  final Duration animationDuration;

  const IosLineChart({
    super.key,
    required this.data,
    this.animationDuration = const Duration(milliseconds: 1200),
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    final minValue = data.reduce(min);
    final maxValue = data.reduce(max);
    final range = maxValue - minValue;
    final padding = range * 0.1; // 10% padding

    return AspectRatio(
      aspectRatio: 2.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: data.length - 1,
            minY: minValue - padding,
            maxY: maxValue + padding,
            lineBarsData: [
              LineChartBarData(
                spots: data.asMap().entries.map((entry) {
                  return FlSpot(entry.key.toDouble(), entry.value);
                }).toList(),
                isCurved: true,
                curveSmoothness: 0.35,
                color: IosTheme.primaryAccent,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      IosTheme.gradientStart.withValues(alpha: 0.3),
                      IosTheme.gradientEnd.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                shadow: Shadow(
                  color: IosTheme.primaryAccent.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    return LineTooltipItem(
                      data[spot.x.toInt()].toStringAsFixed(2),
                      TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }).toList();
                },
                tooltipPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                tooltipMargin: 8,
              ),
              handleBuiltInTouches: true,
            ),
          ),
          duration: animationDuration,
          curve: Curves.easeInOut,
        ),
      ),
    );
  }
}

/// Данные для графика за период
class ChartDataPoint {
  final DateTime date;
  final double value;

  ChartDataPoint({required this.date, required this.value});
}

/// Генератор демо-данных для графика (30 дней)
class ChartDataGenerator {
  static List<double> generateDemoData({
    required double baseValue,
    required double volatility,
    required int days,
  }) {
    final random = Random(42); // Fixed seed for reproducibility
    final data = <double>[];
    var currentValue = baseValue;

    for (int i = 0; i < days; i++) {
      final change = (random.nextDouble() - 0.45) * volatility;
      currentValue += change;
      currentValue = max(currentValue, baseValue * 0.8); // Floor
      data.add(currentValue);
    }

    return data;
  }

  static List<DateTime> generateDateLabels(int days) {
    final now = DateTime.now();
    return List.generate(
      days,
      (index) => now.subtract(Duration(days: days - index - 1)),
    );
  }
}
