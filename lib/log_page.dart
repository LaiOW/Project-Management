import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'app_theme.dart';
import 'glucose_data.dart';
import 'meal_data.dart';
import 'medication_data.dart';
import 'package:uuid/uuid.dart';

class LogPage extends StatefulWidget {
  final Function onSave;

  const LogPage({super.key, required this.onSave});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.background,
          child: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            tabs: const [
              Tab(text: "Glucose"),
              Tab(text: "Meal"),
              Tab(text: "Medication"), // Changed "Meds" to "Medication"
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _GlucoseTab(onSave: widget.onSave),
              const _MealTab(),
              const _MedicationTab(),
            ],
          ),
        ),
      ],
    );
  }
}

class _GlucoseTab extends StatefulWidget {
  final Function onSave;
  const _GlucoseTab({required this.onSave});

  @override
  State<_GlucoseTab> createState() => _GlucoseTabState();
}

class _GlucoseTabState extends State<_GlucoseTab> {
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
      _loadTodayReadings();
      widget.onSave();
      
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
                        height: 56,
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

class _MealTab extends StatefulWidget {
  const _MealTab();

  @override
  State<_MealTab> createState() => _MealTabState();
}

class _MealTabState extends State<_MealTab> {
  final TextEditingController _weightController = TextEditingController(); // Empty initial value
  String _selectedIntensity = "Medium";
  final MealRepository _repository = MealRepository();
  List<MealEntry> _todayEntries = [];

  @override
  void initState() {
    super.initState();
    _loadTodayEntries();
  }

  Future<void> _loadTodayEntries() async {
    final entries = await _repository.getEntriesForToday();
    if (mounted) {
      setState(() {
        _todayEntries = entries;
      });
    }
  }

  Future<void> _onSave() async {
    if (_weightController.text.isEmpty) return;
    int? weight = int.tryParse(_weightController.text);
    if (weight != null) {
      await _repository.saveMeal(weight, _selectedIntensity);
      _loadTodayEntries();
      
      _weightController.clear();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Meal logged successfully!')),
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
            Expanded(
              flex: 6,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Log Your Meal",
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.text,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Input Field only (Centered)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primary, width: 2),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IntrinsicWidth(
                              child: TextField(
                                controller: _weightController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.text),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "--",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text(
                                "grams",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Intensity Selector
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            _buildIntensityOption("Low"),
                            _buildIntensityOption("Medium"),
                            _buildIntensityOption("High"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _onSave,
                          child: const Text("Save Meal", style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom Section: Today's Entries (Same style as Glucose)
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
                      child: _todayEntries.isEmpty 
                        ? const Center(child: Text("No meals today", style: TextStyle(color: Colors.grey)))
                        : ListView.separated(
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: _todayEntries.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final entry = _todayEntries[_todayEntries.length - 1 - index];
                              return _buildMealEntryRow(entry);
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

  Widget _buildIntensityOption(String label) {
    bool isSelected = _selectedIntensity == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIntensity = label;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected ? [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))
            ] : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? AppColors.primary : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealEntryRow(MealEntry entry) {
    Color intensityColor;
    if (entry.intensity == "Low") intensityColor = AppColors.statusNormal;
    else if (entry.intensity == "Medium") intensityColor = AppColors.statusHigh;
    else intensityColor = AppColors.statusVeryHigh;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: intensityColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: intensityColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                "${entry.weight} g",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('HH:mm').format(entry.timestamp),
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
              color: intensityColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              entry.intensity,
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

class _MedicationTab extends StatefulWidget {
  const _MedicationTab();

  @override
  State<_MedicationTab> createState() => _MedicationTabState();
}

class _MedicationTabState extends State<_MedicationTab> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _unitController = TextEditingController(text: "mg");
  
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isBeforeMeal = true;
  
  final MedicationRepository _repository = MedicationRepository();
  List<MedicationEntry> _medications = [];

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  Future<void> _loadMedications() async {
    final list = await _repository.getMedications();
    if (mounted) {
      setState(() {
        _medications = list;
      });
    }
  }

  Future<void> _onAddReminder() async {
    if (_nameController.text.isEmpty || _dosageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // Validation: Check if dosage is numeric
    if (double.tryParse(_dosageController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dosage must be a number')),
      );
      return;
    }

    final entry = MedicationEntry(
      id: const Uuid().v4(),
      name: _nameController.text,
      dosage: _dosageController.text,
      unit: _unitController.text,
      hour: _selectedTime.hour,
      minute: _selectedTime.minute,
      isBeforeMeal: _isBeforeMeal,
      isEnabled: true,
    );

    await _repository.saveMedication(entry);
    _loadMedications();
    
    // Reset form
    _nameController.clear();
    _dosageController.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reminder Added!')),
      );
    }
  }

  Future<void> _onToggle(String id, bool value) async {
    await _repository.toggleMedication(id, value);
    _loadMedications();
  }
  
  Future<void> _onDelete(String id) async {
    await _repository.deleteMedication(id);
    _loadMedications();
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            // Top Section: Input Form (Flex 6)
            Expanded(
              flex: 6,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Set Med Reminder",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.text,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Name Input
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: "Medication Name (e.g. Metformin)",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          prefixIcon: const Icon(Icons.medication, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Dosage Row
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: _dosageController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true), // Force number keyboard
                              decoration: InputDecoration(
                                hintText: "Dosage",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _unitController.text,
                                  isExpanded: true,
                                  items: ["mg", "ml", "units", "pills"].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      _unitController.text = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // Time & Timing Row
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _pickTime,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.access_time, color: Colors.redAccent),
                                    const SizedBox(width: 8),
                                    Text(
                                      _selectedTime.format(context),
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.text),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  _buildTimingToggle("Before", true),
                                  _buildTimingToggle("After", false),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _onAddReminder,
                          child: const Text("Add Reminder", style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom Section: Daily Reminders List (Flex 4)
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
                     BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Daily Reminders",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: _medications.isEmpty 
                        ? const Center(child: Text("No reminders set", style: TextStyle(color: Colors.grey)))
                        : ListView.separated(
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: _medications.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              return _buildReminderCard(_medications[index]);
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

  Widget _buildTimingToggle(String label, bool isBefore) {
    bool isSelected = _isBeforeMeal == isBefore;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isBeforeMeal = isBefore;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? AppColors.primary : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReminderCard(MedicationEntry entry) {
    return Dismissible(
      key: Key(entry.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.redAccent,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        _onDelete(entry.id);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white, // In a white container, but let's give it a slight border or background distinction from list bg
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.text),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "${entry.dosage} ${entry.unit}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: entry.isBeforeMeal ? Colors.orange.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        entry.isBeforeMeal ? "Before Meal" : "After Meal",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: entry.isBeforeMeal ? Colors.orange : Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${entry.hour.toString().padLeft(2, '0')}:${entry.minute.toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: entry.isEnabled,
                    activeColor: AppColors.primary,
                    onChanged: (val) => _onToggle(entry.id, val),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
