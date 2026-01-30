import 'package:flutter/material.dart';

class WellnessDashboardPage extends StatefulWidget {
  const WellnessDashboardPage({super.key});

  @override
  State<WellnessDashboardPage> createState() => _WellnessDashboardPageState();
}

class _WellnessDashboardPageState extends State<WellnessDashboardPage> {
  String _selectedPeriod = 'Weekly';

  // Simulated data for demo
  final List<double> _weeklySleepData = [7.5, 6.8, 7.2, 6.5, 7.8, 8.0, 7.5];
  final List<double> _weeklyStressData = [3.0, 3.5, 4.0, 4.5, 4.0, 3.5, 3.0];
  final List<double> _weeklyMoodData = [3.0, 2.5, 2.0, 2.5, 3.0, 3.5, 3.0];
  final List<double> _weeklyEnergyData = [3.5, 3.0, 2.5, 2.0, 2.5, 3.0, 3.5];

  final List<String> _weekLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<String> _monthLabels = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];

  double _calculateAverage(List<double> data) {
    return data.reduce((a, b) => a + b) / data.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wellness Insights',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Period Selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'Weekly', label: Text('Weekly')),
                    ButtonSegment(value: 'Monthly', label: Text('Monthly')),
                  ],
                  selected: {_selectedPeriod},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _selectedPeriod = newSelection.first;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Summary Stats Cards
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    icon: Icons.hotel,
                    label: 'Avg Sleep',
                    value: '${_calculateAverage(_weeklySleepData).toStringAsFixed(1)}h',
                    color: const Color(0xFF4A90A4),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    icon: Icons.favorite_outline,
                    label: 'Avg Mood',
                    value: '${_calculateAverage(_weeklyMoodData).toStringAsFixed(1)}/5',
                    color: const Color(0xFF7FB685),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Sleep Trend Chart
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A90A4).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.hotel,
                            color: Color(0xFF4A90A4),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Sleep Trend',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200,
                      child: _LineChart(
                        data: _weeklySleepData,
                        labels: _weekLabels,
                        color: const Color(0xFF4A90A4),
                        minValue: 0,
                        maxValue: 10,
                        unit: 'hrs',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _InsightBox(
                      icon: Icons.lightbulb_outline,
                      text: 'You\'re getting consistent sleep this week! Keep it up.',
                      color: Color(0xFF81B29A),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Stress & Mood Chart
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4A259).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.psychology_outlined,
                            color: Color(0xFFF4A259),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Stress & Mood',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200,
                      child: _DualLineChart(
                        stressData: _weeklyStressData,
                        moodData: _weeklyMoodData,
                        labels: _weekLabels,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        _Legend(color: Color(0xFFE07A5F), label: 'Stress'),
                        SizedBox(width: 16),
                        _Legend(color: Color(0xFF7FB685), label: 'Mood'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const _InsightBox(
                      icon: Icons.warning_amber_outlined,
                      text: 'Your stress peaked mid-week. Consider scheduling breaks.',
                      color: Color(0xFFF4A259),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Energy Levels Chart
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7FB685).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.bolt_outlined,
                            color: Color(0xFF7FB685),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Energy Levels',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 150,
                      child: _BarChart(
                        data: _weeklyEnergyData,
                        labels: _weekLabels,
                        color: const Color(0xFF7FB685),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Wellness Score Card
            Card(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF4A90A4).withOpacity(0.1),
                      const Color(0xFF7FB685).withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(20),
                child: const Column(
                  children: [
                    Text(
                      'Weekly Wellness Score',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF718096),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '72',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A90A4),
                      ),
                    ),
                    Text(
                      'out of 100',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF718096),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.trending_up,
                          color: Color(0xFF81B29A),
                          size: 20,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '+5 from last week',
                          style: TextStyle(
                            color: Color(0xFF81B29A),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF718096),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  final List<double> data;
  final List<String> labels;
  final Color color;
  final double minValue;
  final double maxValue;
  final String unit;

  const _LineChart({
    required this.data,
    required this.labels,
    required this.color,
    required this.minValue,
    required this.maxValue,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LineChartPainter(
        data: data,
        labels: labels,
        color: color,
        minValue: minValue,
        maxValue: maxValue,
      ),
      child: Container(),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final Color color;
  final double minValue;
  final double maxValue;

  _LineChartPainter({
    required this.data,
    required this.labels,
    required this.color,
    required this.minValue,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 1;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Draw grid lines
    for (int i = 0; i <= 4; i++) {
      final y = size.height * 0.8 * (i / 4);
      canvas.drawLine(
        Offset(30, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // Calculate points
    final points = <Offset>[];
    final stepX = (size.width - 50) / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = 40 + (stepX * i);
      final normalizedValue = (data[i] - minValue) / (maxValue - minValue);
      final y = size.height * 0.8 * (1 - normalizedValue);
      points.add(Offset(x, y));
    }

    // Draw line
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);

    // Draw points and labels
    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], 5, pointPaint);

      // Draw labels
      textPainter.text = TextSpan(
        text: labels[i],
        style: const TextStyle(
          color: Color(0xFF718096),
          fontSize: 11,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(points[i].dx - textPainter.width / 2, size.height * 0.85),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _DualLineChart extends StatelessWidget {
  final List<double> stressData;
  final List<double> moodData;
  final List<String> labels;

  const _DualLineChart({
    required this.stressData,
    required this.moodData,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DualLineChartPainter(
        stressData: stressData,
        moodData: moodData,
        labels: labels,
      ),
      child: Container(),
    );
  }
}

class _DualLineChartPainter extends CustomPainter {
  final List<double> stressData;
  final List<double> moodData;
  final List<String> labels;

  _DualLineChartPainter({
    required this.stressData,
    required this.moodData,
    required this.labels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final stressPaint = Paint()
      ..color = const Color(0xFFE07A5F)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final moodPaint = Paint()
      ..color = const Color(0xFF7FB685)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Calculate points
    final stressPoints = <Offset>[];
    final moodPoints = <Offset>[];
    final stepX = (size.width - 50) / (stressData.length - 1);

    for (int i = 0; i < stressData.length; i++) {
      final x = 40 + (stepX * i);
      final stressY = size.height * 0.8 * (1 - (stressData[i] - 1) / 4);
      final moodY = size.height * 0.8 * (1 - (moodData[i] - 1) / 4);
      stressPoints.add(Offset(x, stressY));
      moodPoints.add(Offset(x, moodY));
    }

    // Draw stress line
    final stressPath = Path();
    stressPath.moveTo(stressPoints[0].dx, stressPoints[0].dy);
    for (int i = 1; i < stressPoints.length; i++) {
      stressPath.lineTo(stressPoints[i].dx, stressPoints[i].dy);
    }
    canvas.drawPath(stressPath, stressPaint);

    // Draw mood line
    final moodPath = Path();
    moodPath.moveTo(moodPoints[0].dx, moodPoints[0].dy);
    for (int i = 1; i < moodPoints.length; i++) {
      moodPath.lineTo(moodPoints[i].dx, moodPoints[i].dy);
    }
    canvas.drawPath(moodPath, moodPaint);

    // Draw labels
    for (int i = 0; i < labels.length; i++) {
      textPainter.text = TextSpan(
        text: labels[i],
        style: const TextStyle(
          color: Color(0xFF718096),
          fontSize: 11,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(stressPoints[i].dx - textPainter.width / 2, size.height * 0.85),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _BarChart extends StatelessWidget {
  final List<double> data;
  final List<String> labels;
  final Color color;

  const _BarChart({
    required this.data,
    required this.labels,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(data.length, (index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 30,
              height: 100 * (data[index] / 5),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              labels[index],
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF718096),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF718096),
          ),
        ),
      ],
    );
  }
}

class _InsightBox extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InsightBox({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: color.withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Settings Page (referenced in dashboard)
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _chatbotAnalysis = true;
  bool _voiceInput = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Settings'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Privacy Controls',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Manage how your data is used',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF718096),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Chatbot Analysis'),
                  subtitle: const Text(
                    'Allow AI to analyze your conversations for insights',
                  ),
                  value: _chatbotAnalysis,
                  onChanged: (value) {
                    setState(() {
                      _chatbotAnalysis = value;
                    });
                  },
                  activeThumbColor: const Color(0xFF4A90A4),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Voice Input'),
                  subtitle: const Text(
                    'Enable voice recording for check-ins and chat',
                  ),
                  value: _voiceInput,
                  onChanged: (value) {
                    setState(() {
                      _voiceInput = value;
                    });
                  },
                  activeThumbColor: const Color(0xFF4A90A4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Card(
            color: const Color(0xFFFFF3E0),
            child: ListTile(
              leading: const Icon(
                Icons.delete_outline,
                color: Color(0xFFE07A5F),
              ),
              title: const Text(
                'Delete My Data',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text(
                'Permanently remove all your wellness data',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: const Text('Delete All Data?'),
                    content: const Text(
                      'This will permanently delete all your wellness data, check-ins, and chat history. This action cannot be undone.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Data deletion feature coming soon'),
                            ),
                          );
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Color(0xFFE07A5F)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'About',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('App Version'),
                  trailing: Text('1.0.0'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Terms of Service'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
