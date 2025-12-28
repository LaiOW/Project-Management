import 'package:flutter/material.dart';

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
      title: 'Therapeia',
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
        MaterialPageRoute(builder: (context) => const LoginSignupScreen()),
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
                        'This app is for self-management purposes only. It is not intended for medical diagnosis, treatment, cure, or prevention of any disease. Always consult qualified healthcare professionals before making health decisions.',
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
                      'I have read and understand this disclaimer',
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
          MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Therapeia')),
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
                      ? 'Login to your Therapeia account'
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
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
