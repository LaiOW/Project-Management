import 'package:flutter/material.dart';

// Therapeia Blue Color Palette
class TherapediaColors {
  static const Color background = Color(0xFFEDF5FF);
  static const Color mainText = Color(0xFF001141);
  static const Color primaryButton = Color(0xFF0F67FE);
  static const Color accent40 = Color(0xFF78AEFE);
  static const Color accent90 = Color(0xFF002060);
}

class RewardPage extends StatefulWidget {
  const RewardPage({super.key});

  @override
  State<RewardPage> createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  // Placeholder data - No backend needed
  int currentXP = 650;
  int maxXP = 1000;
  int currentStreak = 7;
  
  // Daily quests state
  bool glucoseLogged = true;
  bool mealLogged = true;
  bool medicationTaken = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TherapediaColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Your Rewards',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: TherapediaColors.mainText,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Streak Banner
                _buildStreakBanner(),
                const SizedBox(height: 24),
                
                // Daily Quest Section
                _buildDailyQuestSection(),
                const SizedBox(height: 24),
                
                // Badges Section
                _buildBadgesSection(),
                const SizedBox(height: 24),
                
                // Level Progress
                _buildLevelProgress(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildStreakBanner() {
    double xpProgress = currentXP / maxXP;
    
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF6B9D), Color(0xFFFF8B9D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFF6B9D).withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative sparkles
          Positioned(
            top: 20,
            right: 30,
            child: Icon(Icons.star, color: Colors.white.withOpacity(0.8), size: 24),
          ),
          Positioned(
            top: 50,
            right: 50,
            child: Icon(Icons.star, color: Colors.white.withOpacity(0.6), size: 16),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // Left side - Streak info
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            '$currentStreak-DAY',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'STREAK',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '🔥 Keep it going!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Right side - XP Bar
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'XP',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Vertical XP bar
                      Container(
                        width: 24,
                        height: 100,
                        decoration: BoxDecoration(
                          color: TherapediaColors.accent90,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: FractionallySizedBox(
                            heightFactor: xpProgress,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$currentXP',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDailyQuestSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
          Text(
            'Daily Quest',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: TherapediaColors.mainText,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildQuestItem(
            'Log glucose today',
            '+10 XP',
            glucoseLogged,
            () {
              setState(() {
                glucoseLogged = !glucoseLogged;
                if (glucoseLogged) currentXP += 10;
                else currentXP -= 10;
              });
            },
          ),
          const SizedBox(height: 12),
          
          _buildQuestItem(
            'Log a meal',
            '+20 XP',
            mealLogged,
            () {
              setState(() {
                mealLogged = !mealLogged;
                if (mealLogged) currentXP += 20;
                else currentXP -= 20;
              });
            },
          ),
          const SizedBox(height: 12),
          
          _buildQuestItem(
            'Take medication',
            '+10 XP',
            medicationTaken,
            () {
              setState(() {
                medicationTaken = !medicationTaken;
                if (medicationTaken) currentXP += 10;
                else currentXP -= 10;
              });
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuestItem(String title, String xp, bool completed, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: completed 
                ? Color(0xFFFF6B9D) 
                : Colors.transparent,
              border: Border.all(
                color: completed 
                  ? Color(0xFFFF6B9D)
                  : TherapediaColors.mainText.withOpacity(0.3),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: completed 
              ? Icon(Icons.check, color: Colors.white, size: 20)
              : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: TherapediaColors.mainText,
                decoration: completed ? TextDecoration.lineThrough : null,
                decorationColor: TherapediaColors.mainText.withOpacity(0.5),
              ),
            ),
          ),
          Text(
            xp,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: TherapediaColors.accent40,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBadgesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: TherapediaColors.accent90,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TherapediaColors.accent90.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Badges',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildBadgeItem('⚡', '7-day consistency', true),
          const SizedBox(height: 12),
          _buildBadgeItem('🔥', '14-day streak', false),
          const SizedBox(height: 12),
          _buildBadgeItem('👑', '30-day habit master', false),
        ],
      ),
    );
  }
  
  Widget _buildBadgeItem(String emoji, String title, bool earned) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: earned 
              ? Colors.white.withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Opacity(
              opacity: earned ? 1.0 : 0.3,
              child: Text(
                emoji,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: earned 
                ? Colors.white 
                : Colors.white.withOpacity(0.5),
              fontWeight: earned ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
        if (earned)
          Icon(
            Icons.check_circle,
            color: Colors.greenAccent,
            size: 20,
          ),
      ],
    );
  }
  
  Widget _buildLevelProgress() {
    int currentLevel = 5; // Placeholder
    String levelTitle = 'Novice';
    double xpProgress = currentXP / maxXP;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Level $currentLevel',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: TherapediaColors.mainText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    levelTitle,
                    style: TextStyle(
                      fontSize: 16,
                      color: TherapediaColors.accent40,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: TherapediaColors.primaryButton.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.military_tech,
                  color: TherapediaColors.primaryButton,
                  size: 32,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // XP Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress to Level ${currentLevel + 1}',
                    style: TextStyle(
                      fontSize: 14,
                      color: TherapediaColors.mainText.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    '$currentXP / $maxXP XP',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: TherapediaColors.primaryButton,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: xpProgress,
                  minHeight: 12,
                  backgroundColor: TherapediaColors.background,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    TherapediaColors.primaryButton,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Motivational text
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.emoji_events,
                  color: Color(0xFF4CAF50),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Keep going! ${maxXP - currentXP} XP until next level!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2E7D32),
                      fontWeight: FontWeight.w500,
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
