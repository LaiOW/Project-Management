import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicationEntry {
  final String id;
  final String name;
  final String dosage;
  final String unit;
  final int hour;
  final int minute;
  final bool isBeforeMeal; // true = Before Meal, false = After Meal
  bool isEnabled;

  MedicationEntry({
    required this.id,
    required this.name,
    required this.dosage,
    required this.unit,
    required this.hour,
    required this.minute,
    required this.isBeforeMeal,
    this.isEnabled = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'dosage': dosage,
    'unit': unit,
    'hour': hour,
    'minute': minute,
    'isBeforeMeal': isBeforeMeal,
    'isEnabled': isEnabled,
  };

  factory MedicationEntry.fromJson(Map<String, dynamic> json) {
    return MedicationEntry(
      id: json['id'],
      name: json['name'],
      dosage: json['dosage'],
      unit: json['unit'],
      hour: json['hour'],
      minute: json['minute'],
      isBeforeMeal: json['isBeforeMeal'],
      isEnabled: json['isEnabled'],
    );
  }

  TimeOfDay get time => TimeOfDay(hour: hour, minute: minute);
}

class MedicationRepository {
  static const String _key = 'medication_reminders';

  Future<void> saveMedication(MedicationEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getMedications();
    list.add(entry);
    
    // Sort by time
    list.sort((a, b) {
      if (a.hour != b.hour) return a.hour.compareTo(b.hour);
      return a.minute.compareTo(b.minute);
    });

    final String jsonStr = jsonEncode(list.map((e) => e.toJson()).toList());
    await prefs.setString(_key, jsonStr);
  }

  Future<List<MedicationEntry>> getMedications() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonStr = prefs.getString(_key);

    if (jsonStr == null) {
      return [];
    }

    final List<dynamic> jsonList = jsonDecode(jsonStr);
    return jsonList.map((json) => MedicationEntry.fromJson(json)).toList();
  }

  Future<void> toggleMedication(String id, bool newValue) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getMedications();
    
    final index = list.indexWhere((e) => e.id == id);
    if (index != -1) {
      list[index].isEnabled = newValue;
      final String jsonStr = jsonEncode(list.map((e) => e.toJson()).toList());
      await prefs.setString(_key, jsonStr);
    }
  }

  Future<void> deleteMedication(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getMedications();
    
    list.removeWhere((e) => e.id == id);
    final String jsonStr = jsonEncode(list.map((e) => e.toJson()).toList());
    await prefs.setString(_key, jsonStr);
  }
}
