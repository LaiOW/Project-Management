import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'glucose_data.dart';

class LogPage extends StatefulWidget {
  final Function onSave;

  const LogPage({super.key, required this.onSave});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  String _currentInput = "";
  final GlucoseRepository _repository = GlucoseRepository();
  String _feedbackMessage = "Enter value";
  Color _feedbackColor = Colors.grey;

  void _onDigitPress(String digit) {
    if (_currentInput.length < 3) {
      setState(() {
        _currentInput += digit;
        _updateFeedback();
      });
    }
  }

  void _onBackspace() {
    if (_currentInput.isNotEmpty) {
      setState(() {
        _currentInput = _currentInput.substring(0, _currentInput.length - 1);
        _updateFeedback();
      });
    }
  }

  void _updateFeedback() {
    if (_currentInput.isEmpty) {
      _feedbackMessage = "Enter value";
      _feedbackColor = Colors.grey;
      return;
    }

    int? value = int.tryParse(_currentInput);
    if (value == null) return;

    if (value < 70) {
      _feedbackMessage = "Low 🍬";
      _feedbackColor = AppColors.statusLow;
    } else if (value <= 140) {
      _feedbackMessage = "In range ✅";
      _feedbackColor = AppColors.statusNormal;
    } else if (value <= 180) {
      _feedbackMessage = "Slightly high ⚠️";
      _feedbackColor = AppColors.statusHigh;
    } else {
      _feedbackMessage = "High 🚨";
      _feedbackColor = AppColors.statusVeryHigh;
    }
  }

  Future<void> _onSave() async {
    if (_currentInput.isEmpty) return;
    int? value = int.tryParse(_currentInput);
    if (value != null) {
      await _repository.saveReading(value);
      widget.onSave();
      setState(() {
        _currentInput = "";
        _updateFeedback();
      });
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Glucose logged successfully!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 使用 LayoutBuilder 来根据屏幕可用空间动态调整布局
    return LayoutBuilder(
      builder: (context, constraints) {
        // 判断屏幕高度是否较小（比如小于 600px），如果小则使用更紧凑的布局或 ScrollView
        bool isSmallScreen = constraints.maxHeight < 600;

        return SingleChildScrollView( // 添加 ScrollView 防止溢出
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: IntrinsicHeight( // 确保内容可以自然撑开，如果不足则撑满
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: isSmallScreen ? 10 : 0), // 顶部安全空间
                    Text(
                      'Enter Glucose Level',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.text,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: isSmallScreen ? 10 : 20),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
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
                      child: Column(
                        children: [
                          Text(
                            _currentInput.isEmpty ? "--" : _currentInput,
                            style: const TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                          ),
                          const Text(
                            "mg/dL",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 8 : 16),
                    Text(
                      _feedbackMessage,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: _feedbackColor,
                      ),
                    ),
                    // 如果屏幕高度充足，用 Spacer，否则用固定间距
                    if (!isSmallScreen) const Spacer() else const SizedBox(height: 20),
                    _buildKeypad(isSmallScreen),
                    SizedBox(height: isSmallScreen ? 10 : 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _currentInput.isNotEmpty ? _onSave : null,
                        child: const Text("Save Reading"),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 10 : 0), // 底部安全空间
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildKeypad(bool isSmallScreen) {
    // 如果屏幕小，减小按键尺寸和间距
    double keySize = isSmallScreen ? 60 : 80;
    double spacing = isSmallScreen ? 10 : 16;
    double textSize = isSmallScreen ? 24 : 32;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKey("1", keySize, textSize),
            _buildKey("2", keySize, textSize),
            _buildKey("3", keySize, textSize),
          ],
        ),
        SizedBox(height: spacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKey("4", keySize, textSize),
            _buildKey("5", keySize, textSize),
            _buildKey("6", keySize, textSize),
          ],
        ),
        SizedBox(height: spacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKey("7", keySize, textSize),
            _buildKey("8", keySize, textSize),
            _buildKey("9", keySize, textSize),
          ],
        ),
        SizedBox(height: spacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: keySize), // Spacer for alignment
            _buildKey("0", keySize, textSize),
            _buildBackspaceKey(keySize),
          ],
        ),
      ],
    );
  }

  Widget _buildKey(String label, double size, double fontSize) {
    return InkWell(
      onTap: () => _onDigitPress(label),
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceKey(double size) {
    return InkWell(
      onTap: _onBackspace,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        child: Icon(
          Icons.backspace_outlined,
          color: AppColors.text,
          size: size * 0.4, // icon size relative to button size
        ),
      ),
    );
  }
}
