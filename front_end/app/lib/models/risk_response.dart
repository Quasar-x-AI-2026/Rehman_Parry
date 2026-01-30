class RiskResponse {
  final String risk;
  final double score;
  final DateTime updatedAt;
  final String trend;
  final String explanation;
  final List<int> stressSeries;

  RiskResponse({
    required this.risk,
    required this.score,
    required this.updatedAt,
    required this.trend,
    required this.explanation,
    required this.stressSeries,
  });

  factory RiskResponse.fromJson(Map<String, dynamic> json) {
    return RiskResponse(
      risk: json["current"]["risk"],
      score: (json["current"]["score"] as num).toDouble(),
      updatedAt: DateTime.parse(json["current"]["updated_at"]),
      trend: json["trend"]["direction"],
      explanation: json["explanation"],
      stressSeries:
          List<int>.from(json["stress_series"].map((e) => e as int)),
    );
  }
}
