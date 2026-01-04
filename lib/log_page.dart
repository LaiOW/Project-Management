import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'app_theme.dart';
import 'glucose_data.dart';

class LogPage extends StatefulWidget {
  final Function onSave;

  const LogPage({super.key, required this.onSave});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  // Use a controller to manage the input field
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  
  final GlucoseRepository _repository = GlucoseRepository();
  String _feedbackMessage = "Enter value";
  Color _feedbackColor = Colors.grey;
  List<GlucoseReading> _todayReadings = [];

  @override
  void initState() {
    super.initState();
    _loadTodayReadings();
    // Listen to changes in the text field to update feedback
    _controller.addListener(_updateFeedback);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadTodayReadings() async {
    final readings = await _repository.getReadingsForToday();
    if (mounted) {
      setState(() {
        _todayReadings = readings;
      });
    }
  }

  void _updateFeedback() {
    String text = _controller.text;
    if (text.isEmpty) {
      setState(() {
        _feedbackMessage = "Enter value";
        _feedbackColor = Colors.grey;
      });
      return;
    }

    double? value = double.tryParse(text);
    if (value == null) return;

    // mmol/L Ranges
    String newMessage;
    Color newColor;

    if (value < 4.0) {
      newMessage = "Low 🍬";
      newColor = AppColors.statusLow;
    } else if (value <= 7.8) {
      newMessage = "In range ✅";
      newColor = AppColors.statusNormal;
    } else if (value <= 10.0) {
      newMessage = "Slightly high ⚠️";
      newColor = AppColors.statusHigh;
    } else {
      newMessage = "High 🚨";
      newColor = AppColors.statusVeryHigh;
    }

    setState(() {
      _feedbackMessage = newMessage;
      _feedbackColor = newColor;
    });
  }

  Future<void> _onSave() async {
    if (_controller.text.isEmpty) return;
    double? value = double.tryParse(_controller.text);
    if (value != null) {
      await _repository.saveReading(value);
      _loadTodayReadings(); // Refresh list immediately
      widget.onSave();
      
      // Clear input and hide keyboard
      _controller.clear();
      _focusNode.unfocus();
      
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Glucose logged successfully!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            // Top Section: Input (Flex 6)
            Expanded(
              flex: 6, 
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        'Enter Glucose Level',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppColors.text,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 20),
                      // Input Field with System Keyboard
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _feedbackColor, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IntrinsicWidth(
                              child: TextField(
                                controller: _controller,
                                focusNode: _focusNode,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "--",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text(
                                "mmol/L",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _feedbackMessage,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: _feedbackColor,
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 56, // Taller button
                        child: ElevatedButton(
                          onPressed: _onSave,
                          child: const Text("Save Reading", style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom Section: Today Entries (Flex 4 - approx 40%)
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                     BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Today's Entries",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: _todayReadings.isEmpty 
                        ? const Center(child: Text("No readings today", style: TextStyle(color: Colors.grey)))
                        : ListView.separated(
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: _todayReadings.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final reading = _todayReadings[_todayReadings.length - 1 - index];
                              return _buildEntryRow(reading);
                            },
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEntryRow(GlucoseReading reading) {
    String statusText;
    Color statusColor;
    
    if (reading.value < 4.0) {
      statusText = "Low";
      statusColor = AppColors.statusLow;
    } else if (reading.value <= 7.8) {
      statusText = "Normal";
      statusColor = AppColors.statusNormal;
    } else if (reading.value <= 10.0) {
      statusText = "High";
      statusColor = AppColors.statusHigh;
    } else {
      statusText = "High";
      statusColor = AppColors.statusVeryHigh;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                "${reading.value.toStringAsFixed(1)} mmol/L",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('HH:mm').format(reading.timestamp),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              statusText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
