import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiClient {
  static const String baseUrl = "http://10.0.0.185:8000";

  static Future<bool> submitCheckin({
    required int stress,
    required int energy,
    required String mood,
    required String workload,
    required double sleepHours,
    required String note,
  }) async {
    final url = Uri.parse("$baseUrl/checkin");

    debugPrint("📡 CHECKIN URL => $url");
    debugPrint("📝 NOTE SENT => '$note'");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "stress": stress,
        "energy": energy,
        "mood": mood,
        "workload": workload,
        "sleep_hours": sleepHours,
        "note": note,
      }),
    );

    debugPrint("📥 STATUS => ${response.statusCode}");
    debugPrint("📥 BODY => ${response.body}");

    return response.statusCode == 200;
  }
}
