import '../core/api_client.dart';
import 'package:flutter/material.dart';

class DailyCheckInPage extends StatefulWidget {
  const DailyCheckInPage({super.key});

  @override
  State<DailyCheckInPage> createState() => _DailyCheckInPageState();
}

class _DailyCheckInPageState extends State<DailyCheckInPage> {
  double _sleepHours = 7.0;
  double _stressLevel = 3.0;
  int _selectedMood = 2; // 0-4, where 2 is neutral
  double _energyLevel = 3.0;
  String _workload = 'Medium';
  final TextEditingController _noteController = TextEditingController();

  int get _completedFields {
    int count = 0;
    if (_sleepHours > 0) count++;
    if (_stressLevel > 0) count++;
    if (_selectedMood >= 0) count++;
    if (_energyLevel > 0) count++;
    if (_workload.isNotEmpty) count++;
    if (_noteController.text.isNotEmpty) count++;
    return count;
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submitCheckIn() async {
    try {
      final success = await ApiClient.submitCheckin(
        stress: _stressLevel.round(),
        energy: _energyLevel.round(),
        mood: _selectedMood.toString(),
        workload: _workload,
        sleepHours: _sleepHours,
      );

      if (!mounted) return;

      if (success) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xFF81B29A), size: 28),
                SizedBox(width: 12),
                Text('Check-In Complete!'),
              ],
            ),
            content: const Text(
              'Your wellness data has been recorded.',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ],
          ),
        );
      } else {
        _showError();
      }
    } catch (e) {
      _showError();
    }
  }

  void _showError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to save check-in. Try again.'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _completedFields / 6.0;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Check-In',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              DateTime.now().toString().split(' ')[0],
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  title: const Text('Daily Check-In'),
                  content: const Text(
                    'Your daily check-in helps us monitor your wellness patterns and provide personalized insights for stress prevention.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it'),
                    ),
                  ],
                ),
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
            // Progress Indicator
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progress: $_completedFields/6 fields',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF718096),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFE2E8F0),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xFF4A90A4)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Welcome Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.wb_sunny_outlined,
                      color: Color(0xFF4A90A4),
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${_getGreeting()}! How are you feeling today?',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Sleep Hours
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'How many hours did you sleep?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${_sleepHours.toStringAsFixed(1)} hours',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A90A4),
                      ),
                    ),
                    Slider(
                      value: _sleepHours,
                      min: 0,
                      max: 12,
                      divisions: 24,
                      label: '${_sleepHours.toStringAsFixed(1)} hrs',
                      onChanged: (value) {
                        setState(() {
                          _sleepHours = value;
                        });
                      },
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('0h',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF718096))),
                        Text('12h',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF718096))),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Stress Level
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Stress Level',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: _stressLevel,
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: _stressLevel.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          _stressLevel = value;
                        });
                      },
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Calm',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF718096))),
                        Text('Very Stressed',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF718096))),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Mood Selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'How are you feeling today?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(5, (index) {
                        final emojis = ['😔', '😕', '😐', '🙂', '😊'];
                        final labels = [
                          'Very Sad',
                          'Sad',
                          'Neutral',
                          'Happy',
                          'Very Happy'
                        ];
                        final isSelected = _selectedMood == index;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedMood = index;
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0x334A90A4)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF4A90A4)
                                        : const Color(0xFFE2E8F0),
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    emojis[index],
                                    style: const TextStyle(fontSize: 32),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                labels[index],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? const Color(0xFF4A90A4)
                                      : const Color(0xFF718096),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Energy Level
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Energy Level',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: _energyLevel,
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: _energyLevel.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          _energyLevel = value;
                        });
                      },
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Exhausted',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF718096))),
                        Text('Energized',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF718096))),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Work/Study Load
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Today\'s workload',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'Low', label: Text('Low')),
                        ButtonSegment(value: 'Medium', label: Text('Medium')),
                        ButtonSegment(value: 'High', label: Text('High')),
                      ],
                      selected: {_workload},
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() {
                          _workload = newSelection.first;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Voice Note (Optional)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add a note (helps us understand your mood)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _noteController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText:
                            'Share anything that affected your mood today (optional)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.mic),
                          onPressed: () {
                            // Voice input simulation
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Voice input feature coming soon!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: _submitCheckIn,
              child: const Text('Submit Check-In'),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
