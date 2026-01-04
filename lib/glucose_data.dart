import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GlucoseReading {
  final DateTime timestamp;
  final int value; // mg/dL

  GlucoseReading({required this.timestamp, required this.value});

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'value': value,
  };

  factory GlucoseReading.fromJson(Map<String, dynamic> json) {
    return GlucoseReading(
      timestamp: DateTime.parse(json['timestamp']),
      value: json['value'],
    );
  }
}

class GlucoseRepository {
  static const String _key = 'glucose_readings';

  Future<void> saveReading(int value) async {
    final prefs = await SharedPreferences.getInstance();
    final readings = await getReadings();
    readings.add(GlucoseReading(timestamp: DateTime.now(), value: value));
    
    // Sort by date
    readings.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final List<String> jsonList = readings.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  Future<List<GlucoseReading>> getReadings() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList(_key);

    if (jsonList == null) {
      return [];
    }

    return jsonList.map((json) => GlucoseReading.fromJson(jsonDecode(json))).toList();
  }

  Future<List<GlucoseReading>> getReadingsForLast7Days() async {
    final allReadings = await getReadings();
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    
    return allReadings.where((r) => r.timestamp.isAfter(sevenDaysAgo)).toList();
  }
}
