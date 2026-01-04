import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'app_theme.dart';
import 'glucose_data.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final GlucoseRepository _repository = GlucoseRepository();
  List<GlucoseReading> _readings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final readings = await _repository.getReadingsForLast7Days();
    setState(() {
      _readings = readings;
      _isLoading = false;
    });
  }

  // Exposed to parent to refresh data
  void refresh() {
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_readings.isEmpty) {
      return const Center(
        child: Text(
          "No data for the last 7 days.\nStart logging!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
           Text(
            '7-Day Trend',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.text,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Container(
            height: 300,
            padding: const EdgeInsets.only(right: 16, left: 0, top: 24, bottom: 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: LineChart(
              _buildChartData(),
            ),
          ),
          const SizedBox(height: 30),
          _buildInsightBox(),
        ],
      ),
    );
  }

  LineChartData _buildChartData() {
    // Determine min and max Y for better scaling
    double minY = 0;
    double maxY = 300;
    if (_readings.isNotEmpty) {
      minY = (_readings.map((e) => e.value).reduce((curr, next) => curr < next ? curr : next).toDouble() - 20).clamp(0, double.infinity);
      maxY = (_readings.map((e) => e.value).reduce((curr, next) => curr > next ? curr : next).toDouble() + 20);
    }

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 50,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.1),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1, // Show a title roughly every day? Hard with timestamp points
            getTitlesWidget: (value, meta) {
              // We need to map index to date or something similar if using index as X
              // Here, let's use the index in the sorted list as X for simplicity in this "Simple Trend Graph"
              // A more advanced graph would use time on X axis.
              // For a "Simple Trend Graph", showing the last N points is often acceptable, or mapping days.
              
              // Let's try to show day names if we have few points, or nothing if too crowded.
              // Since X is index here (see lineBarsData below), value is index.
              int index = value.toInt();
              if (index >= 0 && index < _readings.length) {
                // Show date if it's the first reading of that day?
                // Or just show M/T/W for the last 7 readings?
                // Given "7-Day Trend", let's format the date.
                
                // To avoid crowding, show only start and end, or every 2nd?
                if (index == 0 || index == _readings.length - 1 || index % (_readings.length ~/ 5 + 1) == 0) {
                   return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      DateFormat('MM/dd').format(_readings[index].timestamp),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  );
                }
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 50,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: const TextStyle(fontSize: 10, color: Colors.grey),
                textAlign: TextAlign.left,
              );
            },
            reservedSize: 30,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (_readings.length - 1).toDouble(),
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: _readings.asMap().entries.map((e) {
            return FlSpot(e.key.toDouble(), e.value.value.toDouble());
          }).toList(),
          isCurved: true,
          color: AppColors.text, // Graph line color
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              // Color segments logic for dots
              double val = spot.y;
              Color dotColor = AppColors.statusNormal;
              if (val < 70) dotColor = AppColors.statusLow;
              else if (val > 180) dotColor = AppColors.statusHigh; // Orange/Red for high
              else if (val > 140) dotColor = AppColors.statusHigh; 
              
              return FlDotCirclePainter(
                radius: 4,
                color: dotColor,
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            color: AppColors.primary.withOpacity(0.1),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final flSpot = barSpot;
              return LineTooltipItem(
                '${flSpot.y.toInt()} mg/dL',
                 const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  Widget _buildInsightBox() {
    // Mock insight generation
    // In a real app, this would be AI-generated based on trends.
    String insight = "You're doing great! Readings are mostly in range.";
    String suggestion = "Keep up the good work!";
    
    // Simple logic for demo
    int highs = _readings.where((r) => r.value > 140).length;
    if (highs > _readings.length / 3) {
      insight = "You tend to spike in the evenings.";
      suggestion = "Try a lighter dinner or a walk after eating.";
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
         boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lightbulb, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              const Text(
                "Insight & Suggestion",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            insight,
            style: const TextStyle(fontSize: 16, color: AppColors.text),
          ),
          const SizedBox(height: 8),
          Text(
            suggestion,
            style: TextStyle(fontSize: 14, color: Colors.grey[600], fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
