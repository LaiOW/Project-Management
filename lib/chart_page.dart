import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'app_theme.dart';
import 'glucose_data.dart';
import 'dart:math';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final GlucoseRepository _repository = GlucoseRepository();
  List<GlucoseReading> _allReadings = [];
  List<GlucoseReading> _filteredReadings = [];
  bool _isLoading = true;
  String _selectedPeriod = "1 Week"; // Default

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final readings = await _repository.getReadings();
    if (mounted) {
      setState(() {
        _allReadings = readings;
        _isLoading = false;
        _filterData();
      });
    }
  }

  void refresh() {
    _loadData();
  }

  void _filterData() {
    final now = DateTime.now();
    DateTime cutoff;

    switch (_selectedPeriod) {
      case "1 Day":
        cutoff = DateTime(now.year, now.month, now.day);
        break;
      case "1 Week":
        cutoff = now.subtract(const Duration(days: 7));
        break;
      case "1 Month":
        cutoff = now.subtract(const Duration(days: 30));
        break;
      case "1 Year":
        cutoff = now.subtract(const Duration(days: 365));
        break;
      default:
        cutoff = now.subtract(const Duration(days: 7));
    }

    setState(() {
      _filteredReadings = _allReadings.where((r) => r.timestamp.isAfter(cutoff)).toList();
      _filteredReadings.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    });
  }

  void _onPeriodChanged(String period) {
    setState(() {
      _selectedPeriod = period;
      _filterData();
    });
  }

  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text("Glucose Report - $_selectedPeriod",
                    style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 20),
              pw.Text("Generated on: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}"),
              pw.SizedBox(height: 20),
              if (_filteredReadings.isEmpty)
                pw.Text("No data available for this period.")
              else
                pw.Table.fromTextArray(
                  context: context,
                  headers: ["Date & Time", "Level (mmol/L)", "Status"],
                  data: _filteredReadings.map((r) {
                    String status = "Normal";
                    if (r.value < 4.0) {
                      status = "Low";
                    } else if (r.value > 10.0) status = "Very High";
                    else if (r.value > 7.8) status = "High";
                    
                    return [
                      DateFormat('yyyy-MM-dd HH:mm').format(r.timestamp),
                      r.value.toStringAsFixed(1),
                      status
                    ];
                  }).toList(),
                ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> _onGeneratePdf() async {
    if (_filteredReadings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No data to generate PDF')),
      );
      return;
    }
    
    // Preview the PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => _generatePdf(),
    );
  }

  Future<void> _onDownloadPdf() async {
     if (_filteredReadings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No data to download')),
      );
      return;
    }

    // Share the PDF (which allows saving to files)
    await Printing.sharePdf(
      bytes: await _generatePdf(), 
      filename: 'glucose_report.pdf'
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Calculate Summary Stats
    double highest = 0;
    double lowest = 0;
    double average = 0;
    double latest = 0;

    if (_filteredReadings.isNotEmpty) {
      final values = _filteredReadings.map((e) => e.value).toList();
      highest = values.reduce(max);
      lowest = values.reduce(min);
      average = values.reduce((a, b) => a + b) / values.length;
    }
    
    if (_allReadings.isNotEmpty) {
       latest = _allReadings.last.value;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Hero Metrics (Immediate Feedback)
          Center(
            child: Column(
              children: [
                const Text(
                  "Current Level",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  "${latest.toStringAsFixed(1)} mmol/L",
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                _buildStatusTag(latest),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // 2. Period Selection
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ["1 Day", "1 Week", "1 Month", "1 Year"]
                  .map((p) => _buildPeriodTab(p))
                  .toList(),
            ),
          ),
          const SizedBox(height: 30),

          // 3. Visualization (Chart)
          Container(
            height: 320,
            padding: const EdgeInsets.fromLTRB(0, 24, 24, 0), // Adjusted padding
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
            child: _filteredReadings.isEmpty
                ? const Center(child: Text("No data for this period"))
                : LineChart(
                    _buildChartData(),
                  ),
          ),
          const SizedBox(height: 24),

          // 4. AI Insights Section
          _buildAIInsights(),
          const SizedBox(height: 24),

          // 5. Functional Extensions (PDF Buttons)
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _onGeneratePdf,
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text("Generate PDF"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _onDownloadPdf,
                  icon: const Icon(Icons.download),
                  label: const Text("Download"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // 5. Statistical Summary (Dark Blue Card)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.text, // Dark Blue
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.text.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem("Highest", highest),
                Container(width: 1, height: 40, color: Colors.white24),
                _buildSummaryItem("Average", average),
                Container(width: 1, height: 40, color: Colors.white24),
                _buildSummaryItem("Lowest", lowest),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTag(double value) {
    String text;
    Color color;
    if (value == 0) return const SizedBox.shrink();
    
    if (value < 4.0) {
      text = "Low";
      color = AppColors.statusLow;
    } else if (value <= 7.8) {
      text = "Normal";
      color = AppColors.statusNormal;
    } else if (value <= 10.0) {
      text = "High";
      color = AppColors.statusHigh;
    } else {
      text = "Very High";
      color = AppColors.statusVeryHigh;
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPeriodTab(String period) {
    bool isSelected = _selectedPeriod == period;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onPeriodChanged(period),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            period,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, double value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 8),
        Text(
          value == 0 ? "--" : value.toStringAsFixed(1),
          style: const TextStyle(
            color: Colors.redAccent, // Red eye-catching numbers
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  LineChartData _buildChartData() {
    double minY = 0;
    double maxY = 20.0;
    
    if (_filteredReadings.isNotEmpty) {
      double minVal = _filteredReadings.map((e) => e.value).reduce(min);
      double maxVal = _filteredReadings.map((e) => e.value).reduce(max);
      minY = (minVal - 2).clamp(0.0, double.infinity);
      maxY = maxVal + 2;
    }

    // Only show "value annotations" (tooltips always visible) if points are few
    // e.g., for 1 Day or 1 Week views.
    bool showAnnotations = _selectedPeriod == "1 Day" || _selectedPeriod == "1 Week";

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 2.0,
        getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.1), strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1, // We map indices
            getTitlesWidget: (value, meta) {
              int index = value.toInt();
              if (index < 0 || index >= _filteredReadings.length) return const SizedBox.shrink();
              
              // Smart Labeling: Don't crowd the x-axis
              int total = _filteredReadings.length;
              bool showLabel = false;
              
              if (total <= 7) {
                showLabel = true; // Show all for small sets
              } else if (index == 0 || index == total - 1) showLabel = true; // Always show start/end
              else if (index % (total ~/ 5 + 1) == 0) showLabel = true; // Distribute others
              
              if (showLabel) {
                 return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    DateFormat('MM/dd').format(_filteredReadings[index].timestamp),
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 2,
            getTitlesWidget: (value, meta) => Text(
              value.toStringAsFixed(0),
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            reservedSize: 30,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (_filteredReadings.length - 1).toDouble(),
      minY: minY,
      maxY: maxY,
      // Logic to show tooltips permanently if requested
      showingTooltipIndicators: showAnnotations 
        ? _filteredReadings.asMap().entries.map((e) {
            return ShowingTooltipIndicators([
              LineBarSpot(
                LineChartBarData(spots: []), // Dummy, not used for matching by index usually
                0,
                FlSpot(e.key.toDouble(), e.value.value),
              ),
            ]);
          }).toList() 
        : [],
      lineTouchData: LineTouchData(
        enabled: true,
        getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((spotIndex) {
            return TouchedSpotIndicatorData(
              FlLine(color: Colors.transparent), // Hide vertical indicator line for permanent labels
              FlDotData(show: true),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
          // tooltipBgColor: Colors.transparent, // Deprecated or changed in newer versions
          getTooltipColor: (spot) => Colors.transparent, // Make bg transparent
          tooltipPadding: const EdgeInsets.all(0),
          tooltipMargin: 8,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              return LineTooltipItem(
                barSpot.y.toStringAsFixed(1),
                const TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: _filteredReadings.asMap().entries.map((e) {
            return FlSpot(e.key.toDouble(), e.value.value);
          }).toList(),
          isCurved: true,
          color: AppColors.primary,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              double val = spot.y;
              Color dotColor = AppColors.statusNormal;
              if (val < 4.0) {
                dotColor = AppColors.statusLow;
              } else if (val > 10.0) dotColor = AppColors.statusVeryHigh;
              else if (val > 7.8) dotColor = AppColors.statusHigh;
              
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
    );
  }
  
  Widget _buildAIInsights() {
    // Placeholder AI insights - no backend needed
    List<Map<String, dynamic>> insights = [
      {
        'icon': Icons.trending_up,
        'color': Color(0xFF4CAF50),
        'text': 'Your glucose levels are most stable in the morning. Great job!',
      },
      {
        'icon': Icons.lightbulb_outline,
        'color': Color(0xFFFFA726),
        'text': 'You tend to spike on Monday mornings. Try a glass of water before breakfast.',
      },
      {
        'icon': Icons.favorite,
        'color': Color(0xFFE91E63),
        'text': '15-minute walks after meals have helped keep your levels steady.',
      },
    ];
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFE3F2FD),
            Color(0xFFF3E5F5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'AI Insights',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Insights list
          ...insights.map((insight) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: (insight['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    insight['icon'] as IconData,
                    color: insight['color'] as Color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    insight['text'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.text,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
          
          const SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Based on your last 7 days of activity',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.text.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
