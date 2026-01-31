import 'package:flutter/material.dart';
import 'risk_monitoring_page.dart';
import 'daily_checkin_page.dart';

class CheckinAndRiskPage extends StatefulWidget {
  const CheckinAndRiskPage({super.key});

  @override
  State<CheckinAndRiskPage> createState() => _CheckinAndRiskPageState();
}

class _CheckinAndRiskPageState extends State<CheckinAndRiskPage> {
  final GlobalKey<RiskMonitoringPageState> _riskKey =
      GlobalKey<RiskMonitoringPageState>();

  Future<void> _openCheckin() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DailyCheckInPage()),
    );

    // 🔥 THIS IS THE MAGIC
    if (result == true) {
      _riskKey.currentState?.refreshRisk();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wellness Overview"),
        centerTitle: true,
      ),
      body: RiskMonitoringPage(key: _riskKey),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCheckin,
        icon: const Icon(Icons.add),
        label: const Text("Daily Check-In"),
      ),
    );
  }
}
