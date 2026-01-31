import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const SummaryCard({
    super.key,
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

/// =======================
/// LINE CHART
/// =======================
class LineChart extends StatelessWidget {
  final List<double> data;
  final List<String> labels;
  final Color color;
  final double minValue;
  final double maxValue;
  final String unit;

  const LineChart({
    super.key,
    required this.data,
    required this.labels,
    required this.color,
    required this.minValue,
    required this.maxValue,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    if (data.length < 2) return const SizedBox();
    return CustomPaint(
      painter: LineChartPainter(
        data: data,
        labels: labels,
        color: color,
        minValue: minValue,
        maxValue: maxValue,
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final Color color;
  final double minValue;
  final double maxValue;

  LineChartPainter({
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
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()..color = color;

    final stepX = size.width / (data.length - 1);
    final points = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = stepX * i;
      final normalized = (data[i] - minValue) / (maxValue - minValue);
      final y = size.height * (1 - normalized);
      points.add(Offset(x, y));
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }

    canvas.drawPath(path, paint);

    for (final p in points) {
      canvas.drawCircle(p, 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// =======================
/// DUAL LINE CHART
/// =======================
class DualLineChart extends StatelessWidget {
  final List<double> stressData;
  final List<double> moodData;
  final List<String> labels;

  const DualLineChart({
    super.key,
    required this.stressData,
    required this.moodData,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    if (stressData.length < 2 || moodData.length < 2) {
      return const SizedBox();
    }
    return CustomPaint(
      painter: DualLineChartPainter(
        stressData: stressData,
        moodData: moodData,
        labels: labels,
      ),
    );
  }
}

class DualLineChartPainter extends CustomPainter {
  final List<double> stressData;
  final List<double> moodData;
  final List<String> labels;

  DualLineChartPainter({
    required this.stressData,
    required this.moodData,
    required this.labels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final stressPaint = Paint()
      ..color = const Color(0xFFE07A5F)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final moodPaint = Paint()
      ..color = const Color(0xFF7FB685)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final stepX = size.width / (stressData.length - 1);

    Path stressPath = Path();
    Path moodPath = Path();

    for (int i = 0; i < stressData.length; i++) {
      final x = stepX * i;
      final stressY = size.height * (1 - (stressData[i] / 5));
      final moodY = size.height * (1 - (moodData[i] / 5));

      if (i == 0) {
        stressPath.moveTo(x, stressY);
        moodPath.moveTo(x, moodY);
      } else {
        stressPath.lineTo(x, stressY);
        moodPath.lineTo(x, moodY);
      }
    }

    canvas.drawPath(stressPath, stressPaint);
    canvas.drawPath(moodPath, moodPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// =======================
/// BAR CHART
/// =======================
class BarChart extends StatelessWidget {
  final List<double> data;
  final List<String> labels;
  final Color color;

  const BarChart({
    super.key,
    required this.data,
    required this.labels,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(data.length, (index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 28,
              height: 100 * (data[index] / 5),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              labels[index],
              style: const TextStyle(fontSize: 11),
            ),
          ],
        );
      }),
    );
  }
}

/// =======================
/// LEGEND
/// =======================
class Legend extends StatelessWidget {
  final Color color;
  final String label;

  const Legend({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 3,
          color: color,
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}

/// =======================
/// INSIGHT BOX
/// =======================
class InsightBox extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const InsightBox({
    super.key,
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
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

/// =======================
/// SETTINGS PAGE
/// =======================
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool chatbotAnalysis = true;
  bool voiceInput = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy & Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Chatbot Analysis'),
            value: chatbotAnalysis,
            onChanged: (v) => setState(() => chatbotAnalysis = v),
          ),
          SwitchListTile(
            title: const Text('Voice Input'),
            value: voiceInput,
            onChanged: (v) => setState(() => voiceInput = v),
          ),
        ],
      ),
    );
  }
}
