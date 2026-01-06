import 'package:flutter/material.dart';
import 'reward_page.dart';

// Therapeia Blue Color Palette
class TherapediaColors {
  static const Color background = Color(0xFFEDF5FF); // Grade 10
  static const Color mainText = Color(0xFF001141); // Grade 100
  static const Color primaryButton = Color(0xFF0F67FE); // Grade 60
  static const Color accent40 = Color(0xFF78AEFE);
  static const Color accent90 = Color(0xFF002060);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeQuest',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          primary: TherapediaColors.primaryButton,
          secondary: TherapediaColors.accent40,
          surface: TherapediaColors.background,
          onSurface: TherapediaColors.mainText,
        ),
        scaffoldBackgroundColor: TherapediaColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: TherapediaColors.primaryButton,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: TherapediaColors.primaryButton,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: const TextStyle(
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: TherapediaColors.mainText,
            fontSize: 32,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
          headlineMedium: TextStyle(
            color: TherapediaColors.mainText,
            fontSize: 24,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            color: TherapediaColors.mainText,
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
          bodyMedium: TextStyle(
            color: TherapediaColors.mainText,
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// Custom Logo Painter for LifeQuest
class LifeQuestLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer circle - dark blue
    final outerCirclePaint = Paint()
      ..color = TherapediaColors.accent90
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawCircle(center, radius - 8, outerCirclePaint);

    // Inner circle - light blue
    final innerCirclePaint = Paint()
      ..color = TherapediaColors.accent40
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius - 20, innerCirclePaint);

    // Shield shape
    final shieldPath = Path();
    final shieldWidth = radius * 1.4;
    final shieldHeight = radius * 1.6;
    final shieldLeft = center.dx - shieldWidth / 2;
    final shieldTop = center.dy - shieldHeight / 2 - 10;

    shieldPath.moveTo(shieldLeft + shieldWidth / 2, shieldTop);
    shieldPath.lineTo(shieldLeft + shieldWidth, shieldTop + shieldHeight * 0.4);
    shieldPath.lineTo(shieldLeft + shieldWidth, shieldTop + shieldHeight * 0.7);
    shieldPath.cubicTo(
      shieldLeft + shieldWidth,
      shieldTop + shieldHeight,
      shieldLeft + shieldWidth / 2,
      shieldTop + shieldHeight * 1.1,
      shieldLeft + shieldWidth / 2,
      shieldTop + shieldHeight * 1.1,
    );
    shieldPath.cubicTo(
      shieldLeft,
      shieldTop + shieldHeight,
      shieldLeft,
      shieldTop + shieldHeight * 0.7,
      shieldLeft,
      shieldTop + shieldHeight * 0.4,
    );
    shieldPath.close();

    // Shield fill with gradient
    final shieldPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          TherapediaColors.primaryButton,
          TherapediaColors.accent40,
        ],
      ).createShader(Rect.fromLTWH(shieldLeft, shieldTop, shieldWidth, shieldHeight))
      ..style = PaintingStyle.fill;
    canvas.drawPath(shieldPath, shieldPaint);

    // Water drop inside shield
    final dropCenter = Offset(center.dx, center.dy - 5);
    final dropPath = Path();
    dropPath.moveTo(dropCenter.dx, dropCenter.dy - 20);
    dropPath.cubicTo(
      dropCenter.dx - 8,
      dropCenter.dy - 15,
      dropCenter.dx - 12,
      dropCenter.dy - 5,
      dropCenter.dx - 12,
      dropCenter.dy + 5,
    );
    dropPath.cubicTo(
      dropCenter.dx - 12,
      dropCenter.dy + 15,
      dropCenter.dx,
      dropCenter.dy + 25,
      dropCenter.dx,
      dropCenter.dy + 25,
    );
    dropPath.cubicTo(
      dropCenter.dx,
      dropCenter.dy + 25,
      dropCenter.dx + 12,
      dropCenter.dy + 15,
      dropCenter.dx + 12,
      dropCenter.dy + 5,
    );
    dropPath.cubicTo(
      dropCenter.dx + 12,
      dropCenter.dy - 5,
      dropCenter.dx + 8,
      dropCenter.dy - 15,
      dropCenter.dx,
      dropCenter.dy - 20,
    );
    dropPath.close();

    final dropPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawPath(dropPath, dropPaint);

    // Medical symbol (circle and lines) inside water drop
    final symbolCenter = Offset(dropCenter.dx, dropCenter.dy + 2);
    
    // Vertical line
    final linePaint = Paint()
      ..color = TherapediaColors.primaryButton
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(symbolCenter.dx, symbolCenter.dy - 5),
      Offset(symbolCenter.dx, symbolCenter.dy + 5),
      linePaint,
    );

    // Horizontal line
    canvas.drawLine(
      Offset(symbolCenter.dx - 5, symbolCenter.dy),
      Offset(symbolCenter.dx + 5, symbolCenter.dy),
      linePaint,
    );

    // Circle around the symbol
    final symbolCirclePaint = Paint()
      ..color = TherapediaColors.primaryButton
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(symbolCenter, 7, symbolCirclePaint);

    // Top right water drop accent
    final accentDropPath = Path();
    accentDropPath.moveTo(center.dx + 55, center.dy - 45);
    accentDropPath.cubicTo(
      center.dx + 50,
      center.dy - 42,
      center.dx + 48,
      center.dy - 35,
      center.dx + 48,
      center.dy - 28,
    );
    accentDropPath.cubicTo(
      center.dx + 48,
      center.dy - 22,
      center.dx + 55,
      center.dy - 15,
      center.dx + 55,
      center.dy - 15,
    );
    accentDropPath.cubicTo(
      center.dx + 55,
      center.dy - 15,
      center.dx + 62,
      center.dy - 22,
      center.dx + 62,
      center.dy - 28,
    );
    accentDropPath.cubicTo(
      center.dx + 62,
      center.dy - 35,
      center.dx + 60,
      center.dy - 42,
      center.dx + 55,
      center.dy - 45,
    );
    accentDropPath.close();

    final accentPaint = Paint()
      ..color = TherapediaColors.accent40.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    canvas.drawPath(accentDropPath, accentPaint);
  }

  @override
  bool shouldRepaint(LifeQuestLogoPainter oldDelegate) => false;
}

// Splash Screen with Logo
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void _navigateToDisclaimer(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MedicalDisclaimerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TherapediaColors.background,
      body: GestureDetector(
        onTap: () => _navigateToDisclaimer(context),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 40),
                // Logo and Title Section
                Column(
                  children: [
                    // Custom Logo with Shield and Water Drop
                    SizedBox(
                      width: 180,
                      height: 180,
                      child: CustomPaint(
                        painter: LifeQuestLogoPainter(),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // App Name
                    Text(
                      'LifeQuest',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 48,
                        color: TherapediaColors.mainText,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    // Subtitle
                    Text(
                      'DIABETES MANAGEMENT',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 14,
                        color: TherapediaColors.accent40,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                // Tap Anywhere Text
                Column(
                  children: [
                    Text(
                      'TAP ANYWHERE TO START',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: TherapediaColors.accent40,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        letterSpacing: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// User setup data storage
class UserSetupData {
  static String diabetesType = 'Type 2';
  static String glucoseLevel = '0';
  static List<String> medicationsSelected = [];
  static String medicationOther = '';
  static String emergencyContactName = 'Steve';
  static String emergencyContactRelation = 'Dad';
  static String emergencyContactPhone = '011-12345678';
}

// Simple in-memory storage for log entries
class LogEntry {
  final String type; // 'Glucose' or 'Meal'
  final String details; // value or carb info
  final DateTime timestamp;

  LogEntry({required this.type, required this.details, required this.timestamp});
}

class LogStorage {
  static final List<LogEntry> _entries = [];

  static void addEntry(LogEntry entry) {
    _entries.insert(0, entry);
  }

  static List<LogEntry> getEntries() => List.unmodifiable(_entries);

  static List<LogEntry> getEntriesForDay(DateTime day) {
    return _entries.where((e) {
      return e.timestamp.year == day.year && e.timestamp.month == day.month && e.timestamp.day == day.day;
    }).toList(growable: false);
  }
}

// Onboarding Flow - 5 screens before login
class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _step = 0;

  void _next() {
    if (_step < 4) {
      setState(() => _step++);
    } else {
      // Navigate to Login/Signup after onboarding
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginSignupScreen()),
      );
    }
  }

  void _skipToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginSignupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_step) {
      case 0:
        page = _WelcomeOnboard(onContinue: _next);
        break;
      case 1:
        page = _OnboardQuestion(onContinue: _next, onSkip: _skipToLogin);
        break;
      case 2:
        page = _OnboardMedication(onContinue: _next, onSkip: _skipToLogin);
        break;
      case 3:
        page = _OnboardTarget(onContinue: _next, onSkip: _skipToLogin);
        break;
      default:
        page = _EmergencyContact(onContinue: _skipToLogin, onSkip: _skipToLogin);
    }

    return Scaffold(
      backgroundColor: TherapediaColors.background,
      body: page,
    );
  }
}

// Welcome Screen (Screen 1)
class _WelcomeOnboard extends StatelessWidget {
  final VoidCallback onContinue;
  const _WelcomeOnboard({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.health_and_safety, size: 72, color: TherapediaColors.primaryButton),
                  const SizedBox(height: 24),
                  Text('Welcome to', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20)),
                  const SizedBox(height: 8),
                  Text('LifeQuest - Quest', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: TherapediaColors.primaryButton)),
                  const SizedBox(height: 4),
                  Text('for Diabetes', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: TherapediaColors.mainText)),
                ]
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onContinue,
                child: const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('Get Started')),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// Diabetes Type Question (Screen 2)
class _OnboardQuestion extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onSkip;
  const _OnboardQuestion({required this.onContinue, required this.onSkip});

  @override
  State<_OnboardQuestion> createState() => _OnboardQuestionState();
}

class _OnboardQuestionState extends State<_OnboardQuestion> {
  int? _selectedType;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back)),
              Expanded(child: LinearProgressIndicator(value: 0.25, color: TherapediaColors.primaryButton)),
              TextButton(onPressed: widget.onSkip, child: const Text('Skip')),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text('What is your diabetes\ntype?', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 28)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: List.generate(4, (i) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedType = i;
                      UserSetupData.diabetesType = ['Type 1','Type 2','Gestational','Other'][i];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: _selectedType == i ? TherapediaColors.primaryButton : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedType == i ? TherapediaColors.primaryButton : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        ['Type 1','Type 2','Gestational','Other'][i],
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: _selectedType == i ? Colors.white : TherapediaColors.mainText,
                          fontWeight: _selectedType == i ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onContinue,
                child: const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('Continue')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Medication Screen (Screen 3)
class _OnboardMedication extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onSkip;
  const _OnboardMedication({required this.onContinue, required this.onSkip});

  @override
  State<_OnboardMedication> createState() => _OnboardMedicationState();
}

class _OnboardMedicationState extends State<_OnboardMedication> {
  final List<String> _options = const [
    'Metformin',
    'Insulin',
    'Sulfonylureas',
    'DPP-4 inhibitors',
    'GLP-1 agonists',
    'SGLT2 inhibitors',
    'Thiazolidinediones',
    'Other',
  ];
  late List<bool> _selected;
  final TextEditingController _otherController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected = List<bool>.filled(_options.length, false);

    // Restore prior selections
    for (int i = 0; i < _options.length; i++) {
      if (_options[i] != 'Other' && UserSetupData.medicationsSelected.contains(_options[i])) {
        _selected[i] = true;
      }
    }
    if (UserSetupData.medicationOther.isNotEmpty) {
      _selected[_options.length - 1] = true;
      _otherController.text = UserSetupData.medicationOther;
    }

    _syncMedications();
  }

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  void _syncMedications() {
    final meds = <String>[];
    for (int i = 0; i < _options.length; i++) {
      if (_selected[i] && _options[i] != 'Other') {
        meds.add(_options[i]);
      }
    }

    final custom = _otherController.text.trim();
    if (_selected[_options.length - 1] && custom.isNotEmpty) {
      meds.add(custom);
    }

    UserSetupData.medicationsSelected = meds;
    UserSetupData.medicationOther = _selected[_options.length - 1] ? custom : '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back)),
              Expanded(child: LinearProgressIndicator(value: 0.5, color: TherapediaColors.primaryButton)),
              TextButton(onPressed: widget.onSkip, child: const Text('Skip')),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text('What medications do\nyou take?', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 28)),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: _options.length,
              itemBuilder: (c, i) => ListTile(
                title: Text(_options[i]),
                trailing: Checkbox(
                  value: _selected[i],
                  onChanged: (val) {
                    setState(() {
                      _selected[i] = val ?? false;
                      // If "Other" unchecked, clear custom text
                      if (!_selected[i] && _options[i] == 'Other') {
                        _otherController.clear();
                      }
                      _syncMedications();
                    });
                  },
                ),
                subtitle: _options[i] == 'Other' && _selected[i]
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: TextField(
                          controller: _otherController,
                          onChanged: (val) => _syncMedications(),
                          decoration: const InputDecoration(
                            hintText: 'Enter medication name',
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onContinue,
                child: const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('Continue')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Glucose Level Target (Screen 4)
class _OnboardTarget extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onSkip;
  const _OnboardTarget({required this.onContinue, required this.onSkip});

  @override
  State<_OnboardTarget> createState() => _OnboardTargetState();
}

class _OnboardTargetState extends State<_OnboardTarget> {
  String _displayValue = '0';

  @override
  void initState() {
    super.initState();
    _displayValue = UserSetupData.glucoseLevel.isEmpty ? '0' : UserSetupData.glucoseLevel;
  }

  void _showGlucoseDialog() {
    final TextEditingController glucoseInput = TextEditingController(text: _displayValue);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Glucose Level'),
        content: TextField(
          controller: glucoseInput,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            hintText: 'Enter value',
            label: Text('mmol/L'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _displayValue = glucoseInput.text.isEmpty ? '0' : glucoseInput.text;
                UserSetupData.glucoseLevel = _displayValue;
              });
              Navigator.pop(context);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back)),
              Expanded(child: LinearProgressIndicator(value: 0.75, color: TherapediaColors.primaryButton)),
              TextButton(onPressed: widget.onSkip, child: const Text('Skip')),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text('What is your ideal\nglucose level?', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 28)),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: _showGlucoseDialog,
                    child: Column(
                      children: [
                        Text(
                          _displayValue,
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 64),
                        ),
                        const SizedBox(height: 16),
                        const Text('mmol/L', style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: TherapediaColors.primaryButton.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Tap to change',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: TherapediaColors.primaryButton,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onContinue,
                child: const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('Continue')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Emergency Contact Setup (Screen 5)
class _EmergencyContact extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onSkip;
  const _EmergencyContact({required this.onContinue, required this.onSkip});

  @override
  State<_EmergencyContact> createState() => _EmergencyContactState();
}

class _EmergencyContactState extends State<_EmergencyContact> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _relation = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  bool _nameTapped = false;
  bool _relationTapped = false;
  bool _phoneTapped = false;

  @override
  void initState() {
    super.initState();
    // Initialize with default values
    _name.text = UserSetupData.emergencyContactName;
    _relation.text = UserSetupData.emergencyContactRelation;
    _phone.text = UserSetupData.emergencyContactPhone;
  }

  @override
  void dispose() {
    _name.dispose();
    _relation.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back)),
              Expanded(child: LinearProgressIndicator(value: 1.0, color: TherapediaColors.primaryButton)),
              TextButton(onPressed: widget.onSkip, child: const Text('Skip')),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text('Emergency Contact\nSetup', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 28)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Name', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextField(
                  controller: _name,
                  onChanged: (val) => UserSetupData.emergencyContactName = val,
                  onTap: () {
                    if (!_nameTapped) {
                      _name.selection = TextSelection(baseOffset: 0, extentOffset: _name.text.length);
                      _nameTapped = true;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'steve',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Relationship', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextField(
                  controller: _relation,
                  onChanged: (val) => UserSetupData.emergencyContactRelation = val,
                  onTap: () {
                    if (!_relationTapped) {
                      _relation.selection = TextSelection(baseOffset: 0, extentOffset: _relation.text.length);
                      _relationTapped = true;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'dad',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Phone number', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextField(
                  controller: _phone,
                  onChanged: (val) => UserSetupData.emergencyContactPhone = val,
                  onTap: () {
                    if (!_phoneTapped) {
                      _phone.selection = TextSelection(baseOffset: 0, extentOffset: _phone.text.length);
                      _phoneTapped = true;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: '011-12345678',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onContinue();
                },
                child: const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('Sign In')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Medical Disclaimer Splash Screen
class MedicalDisclaimerScreen extends StatefulWidget {
  const MedicalDisclaimerScreen({super.key});

  @override
  State<MedicalDisclaimerScreen> createState() =>
      _MedicalDisclaimerScreenState();
}

class _MedicalDisclaimerScreenState extends State<MedicalDisclaimerScreen> {
  bool _disclaimerAccepted = false;

  void _continueToLogin() {
    if (_disclaimerAccepted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingFlow()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the medical disclaimer to continue'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TherapediaColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: TherapediaColors.primaryButton.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.health_and_safety,
                      size: 64,
                      color: TherapediaColors.primaryButton,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Title
                Text(
                  'Privacy & Safety Check',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: TherapediaColors.mainText,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Medical Disclaimer',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: TherapediaColors.accent40,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 24),

                // Disclaimer Content
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.08),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.3),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.orange,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Important Notice',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'This app is for self-management purposes only... Not a medical diagnosis. It is not intended for treatment, cure, or prevention of any disease. Always consult qualified healthcare professionals before making health decisions.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '🚨 In emergencies, contact emergency services immediately.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Acceptance Checkbox
                Container(
                  decoration: BoxDecoration(
                    color: _disclaimerAccepted
                        ? TherapediaColors.primaryButton.withOpacity(0.08)
                        : Colors.transparent,
                    border: Border.all(
                      color: _disclaimerAccepted
                          ? TherapediaColors.primaryButton
                          : TherapediaColors.mainText.withOpacity(0.2),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CheckboxListTile(
                    title: Text(
                      'I have read and agree to the Medical Disclaimer and Privacy Policy.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    value: _disclaimerAccepted,
                    onChanged: (value) {
                      setState(() {
                        _disclaimerAccepted = value ?? false;
                      });
                    },
                    activeColor: TherapediaColors.primaryButton,
                    checkColor: Colors.white,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Continue Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _continueToLogin,
                    child: const Text('Continue'),
                  ),
                ),
                const SizedBox(height: 16),

                // Info Message
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'By continuing, you acknowledge that you have read and accepted the medical disclaimer and privacy terms.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Login & Signup Screen
class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool _isLoginMode = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _showPassword = false;
  bool _isLoading = false;

  void _toggleAuthMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
    });
  }

  void _handleAuth() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!_isLoginMode && _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate authentication delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Dashboard(initialIndex: 0)),
        );
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TherapediaColors.background,
      appBar: AppBar(
        title: Text(_isLoginMode ? 'Login' : 'Sign Up'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Header
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: TherapediaColors.primaryButton.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      size: 48,
                      color: TherapediaColors.primaryButton,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  _isLoginMode ? 'Welcome Back' : 'Create Account',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: TherapediaColors.mainText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                    _isLoginMode
                      ? 'Login to your LifeQuest account'
                      : 'Join us and start your wellness journey',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: TherapediaColors.mainText.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Name Field (Signup only)
                if (!_isLoginMode) ...[
                  Text(
                    'Full Name',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your full name',
                      hintStyle: TextStyle(
                        color: TherapediaColors.mainText.withOpacity(0.5),
                        fontFamily: 'Inter',
                      ),
                      prefixIcon: const Icon(
                        Icons.person,
                        color: TherapediaColors.accent40,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: TherapediaColors.mainText.withOpacity(0.2),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: TherapediaColors.primaryButton,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.5),
                    ),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      color: TherapediaColors.mainText,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Email Field
                Text(
                  'Email Address',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(
                      color: TherapediaColors.mainText.withOpacity(0.5),
                      fontFamily: 'Inter',
                    ),
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: TherapediaColors.accent40,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: TherapediaColors.mainText.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: TherapediaColors.primaryButton,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.5),
                  ),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: TherapediaColors.mainText,
                  ),
                ),
                const SizedBox(height: 20),

                // Password Field
                Text(
                  'Password',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(
                      color: TherapediaColors.mainText.withOpacity(0.5),
                      fontFamily: 'Inter',
                    ),
                    prefixIcon: const Icon(
                      Icons.lock_outlined,
                      color: TherapediaColors.accent40,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility_off : Icons.visibility,
                        color: TherapediaColors.accent40,
                      ),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: TherapediaColors.mainText.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: TherapediaColors.primaryButton,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.5),
                  ),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: TherapediaColors.mainText,
                  ),
                ),
                const SizedBox(height: 32),

                // Auth Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleAuth,
                    child: _isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                        : Text(_isLoginMode ? 'Login' : 'Sign Up'),
                  ),
                ),
                const SizedBox(height: 16),

                // Toggle Auth Mode
                Center(
                  child: GestureDetector(
                    onTap: _toggleAuthMode,
                    child: RichText(
                      text: TextSpan(
                        text: _isLoginMode
                            ? "Don't have an account? "
                            : 'Already have an account? ',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: TherapediaColors.mainText.withOpacity(0.7),
                        ),
                        children: [
                          TextSpan(
                            text: _isLoginMode ? 'Sign Up' : 'Login',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                              color: TherapediaColors.primaryButton,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// History Page showing saved log entries grouped by date
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  String _formatDate(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime d) {
    return '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final entries = LogStorage.getEntries();
    // group by date string
    final Map<String, List<LogEntry>> groups = {};
    for (final e in entries) {
      final dateStr = _formatDate(e.timestamp);
      groups.putIfAbsent(dateStr, () => []).add(e);
    }

    return Scaffold(
      backgroundColor: TherapediaColors.background,
      appBar: AppBar(
        title: const Text('History'),
        elevation: 0,
      ),
      body: entries.isEmpty
          ? Center(
              child: Text(
                'No entries yet',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: TherapediaColors.mainText.withOpacity(0.6),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final dateStr = groups.keys.elementAt(index);
                final dayEntries = groups[dateStr]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      child: Text(
                        dateStr,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: TherapediaColors.primaryButton,
                        ),
                      ),
                    ),
                    ...dayEntries.map((entry) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Icon(
                              entry.type == 'Glucose' ? Icons.opacity : Icons.restaurant,
                              color: TherapediaColors.primaryButton,
                            ),
                            title: Text(entry.type),
                            subtitle: Text(entry.details),
                            trailing: Text(
                              _formatTime(entry.timestamp),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        )),
                    const SizedBox(height: 8),
                  ],
                );
              },
            ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Dashboard with Bottom Navigation
class Dashboard extends StatefulWidget {
  final int initialIndex;
  const Dashboard({super.key, this.initialIndex = 0});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [];

  @override
  Widget build(BuildContext context) {
    // Build pages lazily to include MyHomePage as Home tab
    final pages = <Widget>[
      const MyHomePage(title: 'Home'),
      const Center(child: Text('Chart Page - content placeholder')),
      const LogPage(),
      const RewardPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: TherapediaColors.primaryButton,
        unselectedItemColor: TherapediaColors.mainText.withOpacity(0.5),
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Chart'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: 'Log'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events_outlined), label: 'Reward'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

// Settings Page
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TherapediaColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Section
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  'John Doe',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Active since Feb 2024',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: TherapediaColors.mainText.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 32),

                // PERSONAL Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PERSONAL',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: TherapediaColors.accent40,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Diabetes Profile
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Diabetes Profile'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Current Diabetes Type:',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    UserSetupData.diabetesType,
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: TherapediaColors.primaryButton,
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                )
                              ],
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.person_outline, color: TherapediaColors.primaryButton, size: 28),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Diabetes Profile',
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        UserSetupData.diabetesType,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: TherapediaColors.mainText.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Icon(Icons.chevron_right, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Medications
                      GestureDetector(
                        onTap: () {
                          final meds = UserSetupData.medicationsSelected;
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Medications'),
                              content: meds.isEmpty
                                  ? const Text('No medications selected')
                                  : Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: meds
                                          .map((m) => Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                child: Text('• $m'),
                                              ))
                                          .toList(),
                                    ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                )
                              ],
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.medication_outlined, color: TherapediaColors.primaryButton, size: 28),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Medications',
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      Text(
                                        UserSetupData.medicationsSelected.isEmpty
                                            ? 'Not set'
                                            : UserSetupData.medicationsSelected.join(', '),
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: TherapediaColors.mainText.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Icon(Icons.chevron_right, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Emergency Contact
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Emergency Contact'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name:',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    UserSetupData.emergencyContactName,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Relation:',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    UserSetupData.emergencyContactRelation,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Phone:',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    UserSetupData.emergencyContactPhone,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                )
                              ],
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.phone_outlined, color: TherapediaColors.primaryButton, size: 28),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Emergency Contact',
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        UserSetupData.emergencyContactName,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: TherapediaColors.mainText.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Icon(Icons.chevron_right, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // LEGAL & PRIVACY Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LEGAL & PRIVACY',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: TherapediaColors.accent40,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Data Privacy Policy
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Data Privacy Policy'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Review how we protect you',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Your data privacy is important to us. We collect and use your health information securely and only for the purpose of helping you manage your diabetes.',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                )
                              ],
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.verified_outlined, color: TherapediaColors.primaryButton, size: 28),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Data Privacy Policy',
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Review how we protect you',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: TherapediaColors.mainText.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Icon(Icons.chevron_right, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Medical Disclaimer
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Medical Disclaimer'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Important health notice',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'This app is for self-management purposes only... Not a medical diagnosis. It is not intended for treatment, cure, or prevention of any disease. Always consult qualified healthcare professionals before making health decisions.',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                )
                              ],
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.description_outlined, color: TherapediaColors.primaryButton, size: 28),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Medical Disclaimer',
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Important health notice',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: TherapediaColors.mainText.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Icon(Icons.chevron_right, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // PREFERENCES Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PREFERENCES',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: TherapediaColors.accent40,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Notification Settings'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Muted Time Range:',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '10 PM - 7 AM',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: TherapediaColors.primaryButton,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'You will not receive notifications during this time period.',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                )
                              ],
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.notifications_outlined, color: TherapediaColors.primaryButton, size: 28),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Notifications',
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Muted 10 PM - 7 AM',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: TherapediaColors.mainText.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Icon(Icons.chevron_right, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Log Out Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Log Out'),
                          content: const Text('Are you sure you want to log out?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (_) => const LoginSignupScreen()),
                                );
                              },
                              child: const Text('Log Out'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, color: Colors.red.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Log Out',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Log Page with plus-to-open entry UI
class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  bool _isGlucose = true;
  final TextEditingController _readingController = TextEditingController();
  int _carbIndex = 1; // 0 low,1 medium,2 high
  String? _mealImagePath; // Store selected meal image path

  @override
  void dispose() {
    _readingController.dispose();
    super.dispose();
  }

  Future<void> _pickMealImage() async {
    try {
      // Show options to pick from gallery or camera
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Pick from Gallery'),
                  onTap: () async {
                    Navigator.pop(context);
                    // Simulate file picker - in real app, use image_picker plugin
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening gallery...')),
                    );
                    // Note: In production, integrate image_picker package
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take Photo'),
                  onTap: () async {
                    Navigator.pop(context);
                    // Simulate camera - in real app, use image_picker plugin
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening camera...')),
                    );
                    // Note: In production, integrate image_picker package
                  },
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Daily Log',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 28,
              color: TherapediaColors.mainText,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HistoryPage()),
              );
            },
            icon: const Icon(Icons.history, color: TherapediaColors.primaryButton, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isGlucose = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isGlucose ? TherapediaColors.primaryButton : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.opacity, color: _isGlucose ? Colors.white : TherapediaColors.accent40),
                    const SizedBox(width: 8),
                    Text('Glucose', style: TextStyle(color: _isGlucose ? Colors.white : TherapediaColors.accent40)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isGlucose = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isGlucose ? TherapediaColors.primaryButton : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.restaurant, color: !_isGlucose ? Colors.white : TherapediaColors.accent40),
                    const SizedBox(width: 8),
                    Text('Meal Log', style: TextStyle(color: !_isGlucose ? Colors.white : TherapediaColors.accent40)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlucoseForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: Column(
              children: [
                Text('ENTER READING', style: Theme.of(context).textTheme.bodyMedium?.copyWith(letterSpacing: 2, color: TherapediaColors.accent40)),
                const SizedBox(height: 12),
                TextField(
                  controller: _readingController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 48, color: TherapediaColors.primaryButton),
                  decoration: const InputDecoration(border: InputBorder.none, hintText: '000'),
                ),
                const SizedBox(height: 8),
                Align(alignment: Alignment.centerRight, child: Text('mg/dL', style: Theme.of(context).textTheme.bodyMedium)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_readingController.text.isNotEmpty) {
                  LogStorage.addEntry(LogEntry(
                    type: 'Glucose',
                    details: '${_readingController.text} mg/dL',
                    timestamp: DateTime.now(),
                  ));
                  _readingController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reading saved')));
                  setState(() {});
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a reading')));
                }
              },
              child: const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Text('Save Reading')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickMealImage,
            child: Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                border: Border.all(color: TherapediaColors.accent40.withOpacity(0.4), width: 1.2),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt_outlined, color: TherapediaColors.accent40, size: 36),
                    const SizedBox(height: 8),
                    Text(
                      _mealImagePath == null ? 'Add Meal Photo' : 'Photo Selected ✓',
                      style: TextStyle(
                        color: _mealImagePath == null ? Colors.blueAccent : Colors.green,
                        fontWeight: _mealImagePath == null ? FontWeight.normal : FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text('optional', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    if (_mealImagePath != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Tap to change',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: TherapediaColors.primaryButton,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CARB CONTENT', style: Theme.of(context).textTheme.bodyMedium?.copyWith(letterSpacing: 1.5, color: TherapediaColors.accent40)),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(3, (i) {
                    final labels = ['Low', 'Medium', 'High'];
                    final selected = _carbIndex == i;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _carbIndex = i),
                        child: Container(
                          margin: EdgeInsets.only(left: i == 0 ? 0 : 8),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: selected ? TherapediaColors.primaryButton : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(child: Text(labels[i], style: TextStyle(color: selected ? Colors.white : TherapediaColors.mainText.withOpacity(0.7)))),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final labels = ['Low', 'Medium', 'High'];
                LogStorage.addEntry(LogEntry(
                  type: 'Meal',
                  details: '${labels[_carbIndex]} Carb${_mealImagePath != null ? ' (with photo)' : ''}',
                  timestamp: DateTime.now(),
                ));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Meal logged')));
                setState(() {
                  _mealImagePath = null; // Reset after logging
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: TherapediaColors.primaryButton),
              child: const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Text('Log Meal')),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TherapediaColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildToggle(),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _isGlucose ? _buildGlucoseForm() : _buildMealForm(),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Today\'s Entries',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...LogStorage.getEntriesForDay(DateTime.now()).map((entry) => Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: Icon(
                                entry.type == 'Glucose' ? Icons.opacity : Icons.restaurant,
                                color: TherapediaColors.primaryButton,
                              ),
                              title: Text(entry.type),
                              subtitle: Text(entry.details),
                              trailing: Text(
                                '${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          )),
                          if (LogStorage.getEntriesForDay(DateTime.now()).isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Text(
                                  'No entries today',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: TherapediaColors.mainText.withOpacity(0.6),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar removed here because LogPage now has its own Tabs that look better without a duplicate AppBar title above it.
      // Or we can keep it simple. Let's keep it but make it minimal.
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 2,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: TherapediaColors.primaryButton.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'You have pushed the button this many times:',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: TherapediaColors.primaryButton,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        backgroundColor: TherapediaColors.primaryButton,
        child: const Icon(Icons.add),
      ),
    );
  }
}
