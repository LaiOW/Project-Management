import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MealEntry {
  final DateTime timestamp;
  final int weight; // in grams
  final String intensity; // Low, Medium, High

  MealEntry({required this.timestamp, required this.weight, required this.intensity});

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'weight': weight,
    'intensity': intensity,
  };

  factory MealEntry.fromJson(Map<String, dynamic> json) {
    return MealEntry(
      timestamp: DateTime.parse(json['timestamp']),
      weight: json['weight'],
      intensity: json['intensity'],
    );
  }
}

class MealRepository {
  static const String _key = 'meal_entries';

  Future<void> saveMeal(int weight, String intensity) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await getEntries();
    entries.add(MealEntry(timestamp: DateTime.now(), weight: weight, intensity: intensity));
    
    // Sort by date
    entries.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final List<String> jsonList = entries.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  Future<List<MealEntry>> getEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList(_key);

    if (jsonList == null) {
      return [];
    }

    return jsonList.map((json) => MealEntry.fromJson(jsonDecode(json))).toList();
  }

  Future<List<MealEntry>> getEntriesForToday() async {
    final allEntries = await getEntries();
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    
    return allEntries.where((e) => e.timestamp.isAfter(startOfDay)).toList();
  }
}
