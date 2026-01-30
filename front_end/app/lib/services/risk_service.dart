import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class RiskService {
  static const String _baseUrl =
      "http://localhost:8000/risk";
  // Android emulator:
  // static const String _baseUrl = "http://10.0.2.2:8000/risk";

  static Future<Map<String, dynamic>> fetchRisk() async {
    final response = await http.get(Uri.parse(_baseUrl));

    // 🔍 DEBUG (TEMPORARY BUT IMPORTANT)
    debugPrint("RISK API STATUS: ${response.statusCode}");
    debugPrint("RISK API BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Failed to load risk data");
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
