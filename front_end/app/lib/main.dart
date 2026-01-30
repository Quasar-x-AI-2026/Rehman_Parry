import 'package:flutter/material.dart';
import '../pages/daily_checkin_page.dart';
import '../pages/chatbot_page.dart';
import '../pages/risk_monitoring_page.dart';
import '../pages/wellness_dashboard_page.dart';

void main() {
  runApp(const CalmCompassApp());
}

class CalmCompassApp extends StatelessWidget {
  const CalmCompassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calm Compass',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A90A4),
          primary: const Color(0xFF4A90A4),
          secondary: const Color(0xFF7FB685),
          surface: Colors.white,
          background: const Color(0xFFF8FAFB),
          error: const Color(0xFFE07A5F),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFB),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A90A4),
            foregroundColor: Colors.white,
            elevation: 2,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: const Color(0xFF4A90A4),
          inactiveTrackColor: const Color(0xFFE2E8F0),
          thumbColor: const Color(0xFF4A90A4),
          // ignore: deprecated_member_use
          overlayColor: const Color(0xFF4A90A4).withOpacity(0.2),
          valueIndicatorColor: const Color(0xFF4A90A4),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFF2D3748),
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Color(0xFF718096),
          ),
        ),
      ),
      home: const MainNavigationPage(),
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DailyCheckInPage(),
    const ChatbotPage(),
    const RiskMonitoringPage(),
    const WellnessDashboardPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4A90A4),
        unselectedItemColor: const Color(0xFF718096),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Check-In',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield_outlined),
            label: 'Risk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Insights',
          ),
        ],
      ),
    );
  }
}
