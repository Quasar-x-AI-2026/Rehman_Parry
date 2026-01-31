import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RiskMonitoringPage extends StatefulWidget {
  const RiskMonitoringPage({super.key});

  @override
  State<RiskMonitoringPage> createState() => RiskMonitoringPageState();
}

class RiskMonitoringPageState extends State<RiskMonitoringPage> {
  Future<Map<String, dynamic>>? riskFuture;
  
  @override
  void initState() {
    super.initState();
    refreshRisk();
  }
  void refreshRisk() {
    setState(() {
      riskFuture = fetchRisk();
    });
  }
static const String baseUrl = "http://10.0.0.185:8000";
  // 🔗 API CALL
    Future<Map<String, dynamic>> fetchRisk() async {
    final url = Uri.parse("$baseUrl/risk");
    debugPrint("📡 FETCH RISK => $url");

    final response = await http.get(url);

    debugPrint("📥 STATUS => ${response.statusCode}");
    debugPrint("📥 BODY => ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Failed to load risk data");
    }

    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Risk Monitoring"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          refreshRisk();
        },
        child: FutureBuilder<Map<String, dynamic>>(
          future: riskFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text("Failed to load risk data"),
              );
            }

            final data = snapshot.data!;

            // 🛑 Handle no-data state safely
            if (data["current"] == null) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Not enough check-ins yet.\nCheck in for a few days to see your burnout risk.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );
            }
            return _buildContent(context, data);
          },
        ),
      ),
    );
  }

  // 🧠 MAIN CONTENT
  Widget _buildContent(BuildContext context, Map<String, dynamic> data) {
    final risk = data["current"]["risk"];
    final score = data["current"]["score"];
    final updatedAt =
        DateTime.parse(data["current"]["updated_at"]).toLocal();
    final explanation = data["explanation"];
    final trend = data["trend"]["direction"];
    final List stressSeries = data["stress_series"];

    Color riskColor = risk == "HIGH"
        ? Colors.red
        : risk == "MEDIUM"
            ? Colors.orange
            : Colors.green;

    IconData trendIcon = trend == "increasing"
        ? Icons.trending_up
        : trend == "decreasing"
            ? Icons.trending_down
            : Icons.trending_flat;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 🛡️ RISK CARD
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(Icons.shield, size: 48, color: riskColor),
                  const SizedBox(height: 8),
                  Text(
                    "$risk RISK",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: riskColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Updated ${DateFormat.Hm().format(updatedAt)} today",
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Score: ${score.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 📖 WHAT THIS MEANS
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "What this means",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    explanation,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 📈 TREND CARD
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(trendIcon, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        "Risk $trend",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 📊 STRESS BARS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: stressSeries.map<Widget>((value) {
                      return Container(
                        width: 18,
                        height: (value as int) * 12.0,
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
