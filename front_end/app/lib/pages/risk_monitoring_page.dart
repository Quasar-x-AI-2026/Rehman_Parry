import 'package:flutter/material.dart';

enum RiskLevel { low, medium, high }

class RiskMonitoringPage extends StatefulWidget {
  const RiskMonitoringPage({super.key});

  @override
  State<RiskMonitoringPage> createState() => _RiskMonitoringPageState();
}

class _RiskMonitoringPageState extends State<RiskMonitoringPage> {
  // Simulated risk data - in real app this would come from backend analysis
  final RiskLevel _currentRisk = RiskLevel.medium;
  final String _trendDirection = 'up'; // 'up', 'down', 'steady'
  bool _showActions = false;

  Color _getRiskColor(RiskLevel risk) {
    switch (risk) {
      case RiskLevel.low:
        return const Color(0xFF81B29A); // Sage Green
      case RiskLevel.medium:
        return const Color(0xFFF4A259); // Soft Amber
      case RiskLevel.high:
        return const Color(0xFFE07A5F); // Muted Coral
    }
  }

  String _getRiskLabel(RiskLevel risk) {
    switch (risk) {
      case RiskLevel.low:
        return 'LOW RISK';
      case RiskLevel.medium:
        return 'MEDIUM RISK';
      case RiskLevel.high:
        return 'HIGH RISK';
    }
  }

  String _getRiskExplanation(RiskLevel risk) {
    switch (risk) {
      case RiskLevel.low:
        return 'Your wellness indicators show healthy patterns. You\'re managing stress well and maintaining good self-care habits.';
      case RiskLevel.medium:
        return 'Your stress levels have been elevated for 3 consecutive days. This suggests increased pressure that could lead to burnout if sustained.';
      case RiskLevel.high:
        return 'Multiple wellness indicators show concerning patterns. Your sleep, stress, and energy levels suggest high burnout risk. Please prioritize self-care and consider professional support.';
    }
  }

  IconData _getTrendIcon() {
    switch (_trendDirection) {
      case 'up':
        return Icons.trending_up;
      case 'down':
        return Icons.trending_down;
      case 'steady':
      default:
        return Icons.trending_flat;
    }
  }

  String _getTrendText() {
    switch (_trendDirection) {
      case 'up':
        return 'Risk increasing';
      case 'down':
        return 'Risk decreasing';
      case 'steady':
      default:
        return 'Stable';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wellness Check',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Risk Status Hero Card
            Card(
              elevation: 4,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _getRiskColor(_currentRisk).withOpacity(0.1),
                      _getRiskColor(_currentRisk).withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Risk Circle Indicator
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getRiskColor(_currentRisk).withOpacity(0.2),
                        border: Border.all(
                          color: _getRiskColor(_currentRisk),
                          width: 8,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.shield_outlined,
                          size: 56,
                          color: _getRiskColor(_currentRisk),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Risk Level Text
                    Text(
                      _getRiskLabel(_currentRisk),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _getRiskColor(_currentRisk),
                        letterSpacing: 1.2,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Last Updated
                    Text(
                      'Updated ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} today',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Explanation Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: _getRiskColor(_currentRisk),
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'What This Means',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _getRiskExplanation(_currentRisk),
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Trend Indicator Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Trend Analysis',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          _getTrendIcon(),
                          color: _trendDirection == 'down'
                              ? const Color(0xFF81B29A)
                              : _trendDirection == 'up'
                                  ? const Color(0xFFE07A5F)
                                  : const Color(0xFF718096),
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getTrendText(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Text(
                                'Compared to last week',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF718096),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Mini trend chart (simplified visualization)
                    Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(7, (index) {
                          final heights = [0.4, 0.5, 0.6, 0.7, 0.8, 0.75, 0.7];
                          return Container(
                            width: 30,
                            height: 50 * heights[index],
                            decoration: BoxDecoration(
                              color: index < 5
                                  ? const Color(0xFF4A90A4).withOpacity(0.3)
                                  : const Color(0xFF4A90A4),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('7 days ago', style: TextStyle(fontSize: 11, color: Color(0xFF718096))),
                        Text('Today', style: TextStyle(fontSize: 11, color: Color(0xFF718096))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Action Card
            Card(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _showActions = !_showActions;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lightbulb_outline,
                            color: Color(0xFF4A90A4),
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'What can I do?',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            _showActions
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: const Color(0xFF718096),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_showActions)
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        children: [
                          const Divider(),
                          const SizedBox(height: 12),
                          _ActionItem(
                            icon: Icons.self_improvement,
                            title: 'Try a 5-minute breathing exercise',
                            subtitle: 'Reduce stress immediately',
                            onTap: () {
                              _showBreathingExercise(context);
                            },
                          ),
                          const SizedBox(height: 12),
                          _ActionItem(
                            icon: Icons.calendar_today,
                            title: 'Schedule self-care time',
                            subtitle: 'Block 30 minutes for yourself',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Calendar integration coming soon!'),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          _ActionItem(
                            icon: Icons.chat_bubble_outline,
                            title: 'Talk to our AI support',
                            subtitle: 'Share how you\'re feeling',
                            onTap: () {
                              // Navigate to chat
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Switching to Chat tab...'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Resources Card
            Card(
              color: const Color(0xFFFFF3E0),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.local_hospital_outlined,
                          color: Color(0xFFE07A5F),
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Need Immediate Help?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'If you\'re in crisis or need professional support:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: const Text('Crisis Resources'),
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '🇺🇸 USA:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('Call/Text: 988 (Suicide & Crisis Lifeline)'),
                                Text('Text "HELLO" to 741741 (Crisis Text Line)'),
                                SizedBox(height: 12),
                                Text(
                                  '🌍 International:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('Visit: findahelpline.com'),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.phone),
                      label: const Text('View Crisis Hotlines'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE07A5F),
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
    );
  }

  void _showBreathingExercise(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.self_improvement, color: Color(0xFF4A90A4)),
            SizedBox(width: 12),
            Text('Breathing Exercise'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '4-7-8 Breathing Technique',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text('1. Breathe in through your nose for 4 seconds'),
            SizedBox(height: 8),
            Text('2. Hold your breath for 7 seconds'),
            SizedBox(height: 8),
            Text('3. Exhale slowly through your mouth for 8 seconds'),
            SizedBox(height: 16),
            Text(
              'Repeat 4 times',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Start Exercise'),
          ),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF4A90A4).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF4A90A4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF718096),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF718096),
            ),
          ],
        ),
      ),
    );
  }
}
